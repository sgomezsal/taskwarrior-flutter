// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taskwarrior/app/modules/detailRoute/controllers/detail_route_controller.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/dateTimePicker.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/description_widget.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/priority_widget.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/status_widget.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/tags_widget.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/category_widget.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class DetailRouteView extends GetView<DetailRouteController> {
  const DetailRouteView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.initDetailsPageTour();
    controller.showDetailsPageTour(context);
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return WillPopScope(
      onWillPop: () async {
        if (!controller.onEdit.value) {
          debugPrint(
              'DetailRouteView: No edits made, navigating back without prompt.');
          // Get.offAll(() => const HomeView());
          Navigator.of(context).pop();
          // Get.toNamed(Routes.HOME);
          return false;
        }
        debugPrint(
            'DetailRouteView: Unsaved edits detected, prompting user for action.');

        bool? save = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: tColors.dialogBackgroundColor,
              title: Text(
                SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                    .sentences
                    .saveChangesConfirmation,
                style: TextStyle(
                  color: tColors.primaryTextColor,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Get.back(); // Close the dialog first
                    // // Wait for dialog to fully close before showing snackbar
                    // Future.delayed(const Duration(milliseconds: 100), () {
                    //   controller.saveChanges();
                    // });

                    controller.saveChanges();
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .yes,
                    style: TextStyle(
                      color: tColors.primaryTextColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Get.offAll(() => const HomeView());

                    Navigator.of(context).pop();
                  },
                  child: Text(
                    SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .no,
                    style: TextStyle(
                      color: tColors.primaryTextColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .cancel,
                    style: TextStyle(
                      color: tColors.primaryTextColor,
                    ),
                  ),
                ),
              ],
            );
          },
        );
        return save == true;
      },
      child: Scaffold(
          backgroundColor: tColors.primaryBackgroundColor,
          appBar: AppBar(
              leading: BackButton(color: TaskWarriorColors.white),
              backgroundColor: Palette.kToDark,
              title: Text(
                '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageID}: ${(controller.modify.id == 0) ? '-' : controller.modify.id}',
                style: TextStyle(
                  color: TaskWarriorColors.white,
                ),
              )),
          body: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Obx(
                () {
                  final DetailRouteController ctrl = controller;
                  final bool isReadOnly = ctrl.isReadOnly.value;
                  
                  return ListView(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    children: [
                      // Description
                      if (ctrl.descriptionValue.value.isNotEmpty)
                        AttributeWidget(
                          name: 'description',
                          value: ctrl.descriptionValue.value,
                          callback: (newValue) => ctrl.setAttribute('description', newValue),
                          waitKey: ctrl.waitKey,
                          dueKey: ctrl.dueKey,
                          untilKey: ctrl.untilKey,
                          priorityKey: ctrl.priorityKey,
                        ),
                      // Status
                      AttributeWidget(
                        name: 'status',
                        value: ctrl.statusValue.value,
                        callback: (newValue) => ctrl.setAttribute('status', newValue),
                        waitKey: ctrl.waitKey,
                        dueKey: ctrl.dueKey,
                        untilKey: ctrl.untilKey,
                        priorityKey: ctrl.priorityKey,
                      ),
                      // Entry
                      if (ctrl.entryValue.value != null)
                        AttributeWidget(
                          name: 'entry',
                          value: ctrl.entryValue.value,
                          callback: (newValue) => ctrl.setAttribute('entry', newValue),
                          waitKey: ctrl.waitKey,
                          dueKey: ctrl.dueKey,
                          untilKey: ctrl.untilKey,
                          priorityKey: ctrl.priorityKey,
                        ),
                      // Modified
                      if (ctrl.modifiedValue.value != null)
                        AttributeWidget(
                          name: 'modified',
                          value: ctrl.modifiedValue.value,
                          callback: (newValue) => ctrl.setAttribute('modified', newValue),
                          waitKey: ctrl.waitKey,
                          dueKey: ctrl.dueKey,
                          untilKey: ctrl.untilKey,
                          priorityKey: ctrl.priorityKey,
                        ),
                      // Start
                      if (ctrl.startValue.value != null)
                        AttributeWidget(
                          name: 'start',
                          value: ctrl.startValue.value,
                          callback: (newValue) => ctrl.setAttribute('start', newValue),
                          waitKey: ctrl.waitKey,
                          dueKey: ctrl.dueKey,
                          untilKey: ctrl.untilKey,
                          priorityKey: ctrl.priorityKey,
                        ),
                      // End
                      if (ctrl.endValue.value != null)
                        AttributeWidget(
                          name: 'end',
                          value: ctrl.endValue.value,
                          callback: (newValue) => ctrl.setAttribute('end', newValue),
                          waitKey: ctrl.waitKey,
                          dueKey: ctrl.dueKey,
                          untilKey: ctrl.untilKey,
                          priorityKey: ctrl.priorityKey,
                        ),
                      // Due
                      if (ctrl.dueValue.value != null)
                        AttributeWidget(
                          name: 'due',
                          value: ctrl.dueValue.value,
                          callback: (newValue) => ctrl.setAttribute('due', newValue),
                          waitKey: ctrl.waitKey,
                          dueKey: ctrl.dueKey,
                          untilKey: ctrl.untilKey,
                          priorityKey: ctrl.priorityKey,
                        ),
                      // Wait
                      if (ctrl.waitValue.value != null)
                        AttributeWidget(
                          name: 'wait',
                          value: ctrl.waitValue.value,
                          callback: (newValue) => ctrl.setAttribute('wait', newValue),
                          waitKey: ctrl.waitKey,
                          dueKey: ctrl.dueKey,
                          untilKey: ctrl.untilKey,
                          priorityKey: ctrl.priorityKey,
                        ),
                      // Until
                      if (ctrl.untilValue.value != null)
                        AttributeWidget(
                          name: 'until',
                          value: ctrl.untilValue.value,
                          callback: (newValue) => ctrl.setAttribute('until', newValue),
                          waitKey: ctrl.waitKey,
                          dueKey: ctrl.dueKey,
                          untilKey: ctrl.untilKey,
                          priorityKey: ctrl.priorityKey,
                        ),
                      // Priority
                      if (ctrl.priorityValue?.value != null)
                        AttributeWidget(
                          name: 'priority',
                          value: ctrl.priorityValue?.value,
                          callback: (newValue) => ctrl.setAttribute('priority', newValue),
                          waitKey: ctrl.waitKey,
                          dueKey: ctrl.dueKey,
                          untilKey: ctrl.untilKey,
                          priorityKey: ctrl.priorityKey,
                        ),
                      // Project - ALWAYS SHOW
                      AttributeWidget(
                        name: 'project',
                        value: ctrl.projectValue?.value,
                        callback: (newValue) => ctrl.setAttribute('project', newValue),
                        waitKey: ctrl.waitKey,
                        dueKey: ctrl.dueKey,
                        untilKey: ctrl.untilKey,
                        priorityKey: ctrl.priorityKey,
                      ),
                      // --- Manual Insertion ---
                      const SizedBox(height: 12),
                      CategoryWidget(
                        name: 'category',
                        value: ctrl.categoryValue?.value,
                        callback: (newValue) => ctrl.setAttribute('category', newValue),
                        isEditable: !isReadOnly,
                      ),
                      // ------------------------
                      // Tags
                      if (ctrl.tagsValue?.value != null && ctrl.tagsValue?.value?.isNotEmpty == true)
                        AttributeWidget(
                          name: 'tags',
                          value: ctrl.tagsValue?.value,
                          callback: (newValue) => ctrl.setAttribute('tags', newValue),
                          waitKey: ctrl.waitKey,
                          dueKey: ctrl.dueKey,
                          untilKey: ctrl.untilKey,
                          priorityKey: ctrl.priorityKey,
                        ),
                      // Urgency
                      AttributeWidget(
                        name: 'urgency',
                        value: ctrl.urgencyValue.value,
                        callback: (newValue) => ctrl.setAttribute('urgency', newValue),
                        waitKey: ctrl.waitKey,
                        dueKey: ctrl.dueKey,
                        untilKey: ctrl.untilKey,
                        priorityKey: ctrl.priorityKey,
                      ),
                    ],
                  );
                },
              )),
          floatingActionButton: controller.modify.changes.isEmpty
              ? const SizedBox.shrink()
              : FloatingActionButton(
                  backgroundColor: tColors.primaryTextColor,
                  foregroundColor: tColors.secondaryBackgroundColor,
                  splashColor: tColors.primaryTextColor,
                  heroTag: "btn1",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          scrollable: true,
                          title: Text(
                            '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.reviewChanges}:',
                            style: TextStyle(
                              color: tColors.primaryTextColor,
                            ),
                          ),
                          content: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              controller.modify.changes.entries
                                  .map((entry) => '${entry.key}:\n'
                                      '  ${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.oldChanges}: ${entry.value['old']}\n'
                                      '  ${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.newChanges}: ${entry.value['new']}')
                                  .toList()
                                  .join('\n'),
                              style: TextStyle(
                                color: tColors.primaryTextColor,
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(
                                SentenceManager(
                                        currentLanguage:
                                            AppSettings.selectedLanguage)
                                    .sentences
                                    .cancel,
                                style: TextStyle(
                                  color: tColors.primaryTextColor,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                controller.saveChanges();
                              },
                              child: Text(
                                SentenceManager(
                                        currentLanguage:
                                            AppSettings.selectedLanguage)
                                    .sentences
                                    .submit,
                                style: TextStyle(
                                  color: tColors.primaryBackgroundColor,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Icon(Icons.save),
                )),
    );
  }
}

class AttributeWidget extends StatelessWidget {
  const AttributeWidget({
    required this.name,
    required this.value,
    required this.callback,
    required this.waitKey,
    required this.dueKey,
    required this.priorityKey,
    required this.untilKey,
    super.key,
  });

  final String name;
  final dynamic value;
  final void Function(dynamic) callback;
  final GlobalKey waitKey;
  final GlobalKey dueKey;
  final GlobalKey untilKey;
  final GlobalKey priorityKey;

  @override
  Widget build(BuildContext context) {
    var localValue = (value is DateTime)
        ? DateFormat.yMEd().add_jms().format(value.toLocal())
        : ((value is BuiltList) ? (value).toBuilder() : value);
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    // Get the controller to check if the task is read-only
    final DetailRouteController controller = Get.find<DetailRouteController>();

    // Always allow status to be edited, but respect read-only for other attributes
    final bool isEditable = !controller.isReadOnly.value || name == 'status';

    switch (name) {
      case 'description':
        return DescriptionWidget(
          name: name,
          value: localValue,
          callback: callback,
          isEditable: isEditable,
        );
      case 'status':
        return StatusWidget(
          name: name,
          value: localValue,
          callback: callback,
        );
      case 'start':
        return StartWidget(
          name: name,
          value: localValue,
          callback: callback,
          isEditable: isEditable,
        );
      case 'due':
        return DateTimeWidget(
          name: name,
          value: localValue,
          callback: callback,
          globalKey: dueKey,
          isEditable: isEditable,
        );
      case 'wait':
        return DateTimeWidget(
          name: name,
          value: localValue,
          callback: callback,
          globalKey: waitKey,
          isEditable: isEditable,
        );
      case 'until':
        return DateTimeWidget(
          name: name,
          value: localValue,
          callback: callback,
          globalKey: untilKey,
          isEditable: isEditable,
        );
      case 'priority':
        return PriorityWidget(
          name: name,
          value: localValue,
          callback: callback,
          globalKey: priorityKey,
          isEditable: isEditable,
        );
      case 'project':
        return ProjectWidget(
          name: name,
          value: localValue,
          callback: callback,
          isEditable: isEditable,
        );
      case 'tags':
        return TagsWidget(
          name: name,
          value: localValue,
          callback: callback,
          isEditable: isEditable,
        );
      case 'category':
        return CategoryWidget(
          name: name,
          value: localValue,
          callback: callback,
          isEditable: isEditable,
        );
      default:
        final Color? textColor =
            (isEditable && !['entry', 'modified', 'urgency'].contains(name))
                ? tColors.primaryTextColor
                : tColors.primaryDisabledTextColor;

        return Card(
          color: tColors.secondaryBackgroundColor,
          child: ListTile(
            textColor: tColors.primaryTextColor,
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    '$name:'.padRight(13),
                    style: TextStyle(
                      fontFamily: FontFamily.poppins,
                      fontWeight: TaskWarriorFonts.bold,
                      fontSize: TaskWarriorFonts.fontSizeMedium,
                      color: textColor,
                    ),
                  ),
                  Text(
                    localValue?.toString() ??
                        SentenceManager(
                                currentLanguage: AppSettings.selectedLanguage)
                            .sentences
                            .notSelected,
                    style: TextStyle(
                      fontFamily: FontFamily.poppins,
                      fontSize: TaskWarriorFonts.fontSizeMedium,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}
