import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class CategoryColumn extends StatelessWidget {
  const CategoryColumn({
    required this.categories,
    required this.categoryFilter,
    required this.callback,
    super.key,
  });

  final List<String> categories;
  final String categoryFilter;
  final void Function(String) callback;

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
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Category : ",
                style: TextStyle(
                  fontFamily: FontFamily.poppins,
                  fontWeight: TaskWarriorFonts.bold,
                  fontSize: TaskWarriorFonts.fontSizeSmall,
                  color: tColors.primaryTextColor,
                ),
              ),
              SizedBox(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        categoryFilter == ""
                            ? SentenceManager(
                                    currentLanguage: AppSettings.selectedLanguage)
                                .sentences
                                .notSelected
                            : categoryFilter,
                        style: TextStyle(
                          fontFamily: FontFamily.poppins,
                          fontSize: TaskWarriorFonts.fontSizeSmall,
                          color: tColors.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        ExpansionTile(
          key: const PageStorageKey('categories-expansion'),
          title: Text(
            'Category',
            style: TextStyle(
              fontFamily: FontFamily.poppins,
              fontWeight: TaskWarriorFonts.bold,
              fontSize: TaskWarriorFonts.fontSizeSmall,
              color: tColors.primaryTextColor,
            ),
          ),
          iconColor: tColors.primaryTextColor,
          collapsedIconColor: tColors.primaryTextColor,
          textColor: tColors.primaryTextColor,
          collapsedTextColor: tColors.primaryTextColor,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'All Categories',
                    style: TextStyle(
                      fontFamily: FontFamily.poppins,
                      fontSize: TaskWarriorFonts.fontSizeSmall,
                      color: tColors.primaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            CategoryTile(
              category: '',
              categoryFilter: categoryFilter,
              callback: callback,
            ),
            if (categories.isNotEmpty)
              ...categories.map((category) => CategoryTile(
                    category: category,
                    categoryFilter: categoryFilter,
                    callback: callback,
                  ))
            else
              Column(
                children: [
                  Text(
                    'No categories found',
                    style: TextStyle(
                      fontFamily: FontFamily.poppins,
                      fontSize: TaskWarriorFonts.fontSizeSmall,
                      color: tColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    required this.category,
    required this.categoryFilter,
    required this.callback,
    super.key,
  });

  final String category;
  final String categoryFilter;
  final void Function(String) callback;

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final displayText = category.isEmpty ? 'All Categories' : category;
    return GestureDetector(
      onTap: () => callback(category),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Radio<String>(
            value: category,
            groupValue: categoryFilter.isEmpty ? '' : categoryFilter,
            onChanged: (_) => callback(category),
            activeColor: tColors.primaryTextColor,
          ),
          Text(
            displayText,
            style: TextStyle(
              color: tColors.primaryTextColor,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

