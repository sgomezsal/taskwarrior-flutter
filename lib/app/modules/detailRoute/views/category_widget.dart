import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    required this.name,
    required this.value,
    required this.callback,
    this.isEditable = true,
    super.key,
  });

  final String name;
  final dynamic value;
  final void Function(dynamic) callback;
  final bool isEditable;

  static const List<String> categoryOptions = [
    'inbox',
    'calendar',
    'check-list',
    'next-actions',
    'waiting',
    'tickler-file',
    'reference-material',
    'someday-maybe',
  ];

  @override
  Widget build(BuildContext context) {
    debugPrint('CategoryWidget: Building with name=$name, value=$value, isEditable=$isEditable');
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final Color? textColor = isEditable
        ? tColors.primaryTextColor
        : tColors.primaryDisabledTextColor;
    final Color primaryTextColorNonNull =
        tColors.primaryTextColor ?? Colors.black;

    return Card(
      color: tColors.secondaryBackgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '$name:'.padRight(13),
                  style: GoogleFonts.poppins(
                    fontWeight: TaskWarriorFonts.bold,
                    fontSize: TaskWarriorFonts.fontSizeMedium,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 56, // Minimum height for dropdown
              child: DropdownButtonFormField<String>(
              value: value as String?,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color: primaryTextColorNonNull.withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color: primaryTextColorNonNull.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color: primaryTextColorNonNull,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: tColors.secondaryBackgroundColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
              ),
              style: GoogleFonts.poppins(
                fontSize: TaskWarriorFonts.fontSizeMedium,
                color: textColor,
              ),
              dropdownColor: tColors.secondaryBackgroundColor,
              iconEnabledColor: textColor,
              iconDisabledColor: tColors.primaryDisabledTextColor,
              hint: Text(
                SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                    .sentences
                    .notSelected,
                style: GoogleFonts.poppins(
                  fontSize: TaskWarriorFonts.fontSizeMedium,
                  color: textColor?.withOpacity(0.6),
                ),
              ),
              items: [
                ...categoryOptions.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      style: GoogleFonts.poppins(
                        fontSize: TaskWarriorFonts.fontSizeMedium,
                        color: textColor,
                      ),
                    ),
                  );
                }),
              ],
              onChanged: isEditable
                  ? (String? newValue) {
                      callback(newValue);
                    }
                  : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

