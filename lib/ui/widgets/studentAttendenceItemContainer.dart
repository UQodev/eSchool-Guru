import 'package:eschool_saas_staff/data/models/studentDetails.dart';
import 'package:eschool_saas_staff/ui/styles/themeExtensions/customColorsExtension.dart';
import 'package:eschool_saas_staff/ui/widgets/customTextContainer.dart';
import 'package:eschool_saas_staff/utils/constants.dart';
import 'package:eschool_saas_staff/utils/labelKeys.dart';
import 'package:eschool_saas_staff/utils/utils.dart';
import 'package:flutter/material.dart';

class StudentAttendanceItemContainer extends StatefulWidget {
  final bool showStatusPicker;
  final bool isPresent;
  final bool isSick;
  final bool isPermission;
  final bool isAlpa;
  final StudentDetails studentDetails;
  final Function(StudentAttendanceStatus status)? onChangeAttendance;
  const StudentAttendanceItemContainer({
    super.key,
    required this.studentDetails,
    this.showStatusPicker = false,
    required this.isPresent,
    required this.isSick,
    required this.isPermission,
    required this.isAlpa,
    this.onChangeAttendance,
  });

  @override
  State<StudentAttendanceItemContainer> createState() =>
      _StudentAttendanceItemContainerState();
}

class _StudentAttendanceItemContainerState
    extends State<StudentAttendanceItemContainer> {
  late StudentAttendanceStatus selectedValue = widget.isPresent
      ? StudentAttendanceStatus.present
      : widget.isSick
          ? StudentAttendanceStatus.sick
          : widget.isPermission
              ? StudentAttendanceStatus.permission
              : widget.isAlpa
                  ? StudentAttendanceStatus.alpa
                  : StudentAttendanceStatus.absent;

  _buildStatusPicker(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: selectedValue == StudentAttendanceStatus.alpa
            ? Theme.of(context)
                .extension<CustomColors>()!
                .totalStudentOverviewBackgroundColor!
                .withOpacity(0.1)
            : selectedValue == StudentAttendanceStatus.sick
                ? Theme.of(context)
                    .extension<CustomColors>()!
                    .sickBackgroundColor!
                    .withOpacity(0.1)
                : selectedValue == StudentAttendanceStatus.permission
                    ? Theme.of(context)
                        .extension<CustomColors>()!
                        .permissionBackgroundColor!
                        .withOpacity(0.1)
                    : Theme.of(context)
                        .extension<CustomColors>()!
                        .totalStaffOverviewBackgroundColor!
                        .withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<StudentAttendanceStatus>(
        items: [
          DropdownMenuItem(
            value: StudentAttendanceStatus.present,
            child: Text(
              Utils.getTranslatedLabel(presentKey),
              style: TextStyle(
                color: Theme.of(context)
                    .extension<CustomColors>()!
                    .totalStaffOverviewBackgroundColor!,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          DropdownMenuItem(
            value: StudentAttendanceStatus.sick,
            child: Text(
              Utils.getTranslatedLabel(sickKey),
              style: TextStyle(
                color: Theme.of(context)
                    .extension<CustomColors>()!
                    .sickBackgroundColor!,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          DropdownMenuItem(
            value: StudentAttendanceStatus.permission,
            child: Text(
              Utils.getTranslatedLabel(permissionKey),
              style: TextStyle(
                color: Theme.of(context)
                    .extension<CustomColors>()!
                    .permissionBackgroundColor!,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          DropdownMenuItem(
            value: StudentAttendanceStatus.alpa,
            child: Text(
              Utils.getTranslatedLabel(alpaKey),
              style: TextStyle(
                color: Theme.of(context)
                    .extension<CustomColors>()!
                    .totalStudentOverviewBackgroundColor!,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        value: selectedValue,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              selectedValue = value;
            });
            if (widget.onChangeAttendance != null) {
              widget.onChangeAttendance!(selectedValue);
            }
          }
        },
        underline: const SizedBox(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(color: Theme.of(context).colorScheme.tertiary);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 65,
      padding: EdgeInsets.symmetric(
          horizontal: appContentHorizontalPadding, vertical: 10),
      decoration: BoxDecoration(
          border: Border(left: border, bottom: border, right: border)),
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return Row(
          children: [
            SizedBox(
              width: boxConstraints.maxWidth * (0.175),
              child: CustomTextContainer(
                  textKey:
                      widget.studentDetails.student?.rollNumber?.toString() ??
                          "-"),
            ),
            Expanded(
              child: CustomTextContainer(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textKey: (widget.studentDetails.fullName ?? ""),
                style: const TextStyle(
                    fontSize: 15.0, fontWeight: FontWeight.w600),
              ),
            ),
            if (widget.showStatusPicker) ...[
              _buildStatusPicker(context),
            ] else ...[
              Container(
                height: 50,
                width: 70,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: widget.isPresent
                        ? Theme.of(context)
                            .extension<CustomColors>()!
                            .totalStaffOverviewBackgroundColor!
                            .withOpacity(0.1)
                        : widget.isSick
                            ? Theme.of(context)
                                .extension<CustomColors>()!
                                .sickBackgroundColor!
                                .withOpacity(0.1)
                            : widget.isPermission
                                ? Theme.of(context)
                                    .extension<CustomColors>()!
                                    .permissionBackgroundColor!
                                    .withOpacity(0.1)
                                : widget.isAlpa
                                    ? Theme.of(context)
                                        .extension<CustomColors>()!
                                        .totalStudentOverviewBackgroundColor!
                                        .withOpacity(0.1)
                                    : Theme.of(context)
                                        .extension<CustomColors>()!
                                        .totalStudentOverviewBackgroundColor!
                                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5)),
                child: CustomTextContainer(
                  textKey: widget.isPresent
                      ? "Hadir"
                      : widget.isSick
                          ? "Sakit"
                          : widget.isPermission
                              ? "Izin"
                              : widget.isAlpa
                                  ? "Alpa"
                                  : "-",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    color: widget.isPresent
                        ? Theme.of(context)
                            .extension<CustomColors>()!
                            .totalStaffOverviewBackgroundColor
                        : widget.isSick
                            ? Theme.of(context)
                                .extension<CustomColors>()!
                                .sickBackgroundColor!
                            : widget.isPermission
                                ? Theme.of(context)
                                    .extension<CustomColors>()!
                                    .permissionBackgroundColor!
                                : widget.isAlpa
                                    ? Theme.of(context)
                                        .extension<CustomColors>()!
                                        .totalStudentOverviewBackgroundColor!
                                    : Theme.of(context)
                                        .extension<CustomColors>()!
                                        .totalStudentOverviewBackgroundColor!,
                  ),
                ),
              ),
            ],
          ],
        );
      }),
    );
  }
}
