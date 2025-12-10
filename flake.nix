{
  description = "Taskwarrior Flutter - NixOS Mutable Local SDK Strategy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
          };
        };

        # Rust Cross-Compile
        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" ];
          targets = [ 
            "aarch64-linux-android"
            "armv7-linux-androideabi"
            "x86_64-linux-android"
          ];
        };

        # SDK Base de Nix (Solo lectura, servirá de semilla)
        androidComposition = pkgs.androidenv.composeAndroidPackages {
          buildToolsVersions = [ "30.0.3" "33.0.1" "34.0.0" ];
          platformVersions = [ "33" "34" ]; 
          abiVersions = [ "arm64-v8a" "x86_64" ]; 
          includeNDK = true;
          ndkVersions = ["26.1.10909125"]; 
          includeEmulator = false;
        };
        
        androidSdkBase = androidComposition.androidsdk;

        nativeBuildInputs = with pkgs; [ pkg-config cmake ninja clang gnumake ];

        buildInputs = with pkgs; [
          flutter
          jdk17
          androidSdkBase # Lo usamos para copiarlo, no para usarlo directo
          rustToolchain 
          cargo-ndk
          
          # Linux libs
          gtk3 glib pcre libepoxy xorg.libX11 xorg.libXdmcp
          libselinux libsepol libthai libdatrie libxkbcommon
          dbus at-spi2-core
          
          android-tools
          xdg-user-dirs
        ];

      in
      {
        devShells.default = pkgs.mkShell {
          inherit buildInputs nativeBuildInputs;

          shellHook = ''
            # --- Configuración del SDK Local Mutable ---
            # Definimos una carpeta local dentro del proyecto para el SDK
            export LOCAL_SDK_PATH="$(pwd)/.local_android_sdk"
            export NIX_SDK_SOURCE="${androidSdkBase}/libexec/android-sdk"

            echo "=========================================================="
            echo "🔧 Configurando entorno Android SDK Local (Permite SDK 36)"
            
            if [ ! -d "$LOCAL_SDK_PATH" ]; then
                echo "   -> Creando copia local del SDK en $LOCAL_SDK_PATH..."
                echo "   -> (Esto permite que Gradle descargue Android 36 automáticamente)"
                mkdir -p "$LOCAL_SDK_PATH"
                # Copiamos el contenido base de Nix
                cp -Lr "$NIX_SDK_SOURCE/"* "$LOCAL_SDK_PATH/"
                # Damos permisos de escritura
                chmod -R u+w "$LOCAL_SDK_PATH"
                echo "   -> Copia terminada."
            else
                echo "   -> SDK local detectado."
            fi

            # Configuramos las variables para usar la COPIA LOCAL
            export ANDROID_HOME="$LOCAL_SDK_PATH"
            export ANDROID_SDK_ROOT="$LOCAL_SDK_PATH"
            export NDK_HOME="$LOCAL_SDK_PATH/ndk/26.1.10909125"
            export ANDROID_NDK_ROOT="$NDK_HOME"
            
            # Forzamos a Flutter a ver este SDK
            flutter config --android-sdk "$ANDROID_HOME" > /dev/null 2>&1
            
            # --- Resto de variables ---
            export JAVA_HOME=${pkgs.jdk17}
            export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath buildInputs}:$LD_LIBRARY_PATH
            export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)/rust/target/debug
            export CHROME_EXECUTABLE=${pkgs.chromium}/bin/chromium
            export XDG_DOCUMENTS_DIR="$HOME/Documents"
            export BINDGEN_EXTRA_CLANG_ARGS="-isystem ${pkgs.llvmPackages.libclang.lib}/lib/clang/${pkgs.llvmPackages.libclang.version}/include -isystem ${pkgs.glibc.dev}/include"

            echo "=========================================================="
            echo "🚀 Entorno listo. Ejecuta: flutter run -d <dispositivo>"
            echo "=========================================================="
          '';
        };
      }
    );
}
