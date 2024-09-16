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
  final StudentDetails studentDetails;
  final Function(StudentAttendanceStatus status)? onChangeAttendance;

  const StudentAttendanceItemContainer({
    super.key,
    required this.studentDetails,
    this.showStatusPicker = false,
    required this.isPresent,
    this.onChangeAttendance,
  });

  @override
  State<StudentAttendanceItemContainer> createState() =>
      _StudentAttendanceItemContainerState();
}

class _StudentAttendanceItemContainerState
    extends State<StudentAttendanceItemContainer> {
  late StudentAttendanceStatus selectedValue;
  String? selectedAbsenceReason;

  @override
  void initState() {
    super.initState();

    if (widget.showStatusPicker) {
      // Saat menambahkan kehadiran, default semua siswa ke "Hadir"
      selectedValue = StudentAttendanceStatus.present;
      selectedAbsenceReason = null;
    } else {
      // Saat melihat kehadiran yang sudah ada, gunakan nilai yang ada
      selectedValue = widget.isPresent
          ? StudentAttendanceStatus.present
          : StudentAttendanceStatus.absent;
      selectedAbsenceReason = null;
    }

    // Jika siswa "Tidak Hadir" dan sedang menambahkan kehadiran, atur alasan default ke "Sakit"
    if (widget.showStatusPicker &&
        selectedValue == StudentAttendanceStatus.absent) {
      selectedAbsenceReason = 'Sakit';
    }
  }

  _buildStatusPicker(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: selectedValue == StudentAttendanceStatus.absent
            ? Theme.of(context)
                .extension<CustomColors>()!
                .totalStudentOverviewBackgroundColor!
                .withOpacity(0.1)
            : Theme.of(context)
                .extension<CustomColors>()!
                .totalStaffOverviewBackgroundColor!
                .withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<StudentAttendanceStatus>(
        isExpanded: true,
        items: [
          DropdownMenuItem(
            value: StudentAttendanceStatus.present,
            child: Text(
              Utils.getTranslatedLabel(presentKey),
              style: TextStyle(
                color: Theme.of(context)
                    .extension<CustomColors>()!
                    .totalStaffOverviewBackgroundColor!,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          DropdownMenuItem(
            value: StudentAttendanceStatus.absent,
            child: Text(
              Utils.getTranslatedLabel(absentKey),
              style: TextStyle(
                color: Theme.of(context)
                    .extension<CustomColors>()!
                    .totalStudentOverviewBackgroundColor!,
                fontSize: 15,
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
              if (selectedValue == StudentAttendanceStatus.present) {
                selectedAbsenceReason = null;
              } else if (widget.showStatusPicker &&
                  selectedValue == StudentAttendanceStatus.absent) {
                selectedAbsenceReason =
                    'Sakit'; // Default ke 'Sakit' saat "Tidak Hadir"
              }
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
      padding: EdgeInsets.symmetric(
          horizontal: appContentHorizontalPadding, vertical: 10),
      decoration: BoxDecoration(
        border: Border(left: border, bottom: border, right: border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: CustomTextContainer(
                  textKey:
                      widget.studentDetails.student?.rollNumber?.toString() ??
                          "-",
                ),
              ),
              Expanded(
                flex: 7,
                child: CustomTextContainer(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textKey: widget.studentDetails.fullName ?? "",
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (widget.showStatusPicker)
                Expanded(
                  flex: 3,
                  child: _buildStatusPicker(context),
                )
              else
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: widget.isPresent
                          ? Theme.of(context)
                              .extension<CustomColors>()!
                              .totalStaffOverviewBackgroundColor!
                              .withOpacity(0.1)
                          : Theme.of(context)
                              .extension<CustomColors>()!
                              .totalStudentOverviewBackgroundColor!
                              .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: CustomTextContainer(
                      textKey: widget.isPresent ? "Hadir" : "Absen",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        color: widget.isPresent
                            ? Theme.of(context)
                                .extension<CustomColors>()!
                                .totalStaffOverviewBackgroundColor
                            : Theme.of(context)
                                .extension<CustomColors>()!
                                .totalStudentOverviewBackgroundColor!,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Tampilkan opsi alasan jika siswa absen
          if (selectedValue == StudentAttendanceStatus.absent)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Radio<String>(
                      value: 'Sakit',
                      groupValue: selectedAbsenceReason,
                      onChanged: (value) {
                        setState(() {
                          selectedAbsenceReason = value;
                        });
                      },
                    ),
                    const Text('Sakit'),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Izin',
                      groupValue: selectedAbsenceReason,
                      onChanged: (value) {
                        setState(() {
                          selectedAbsenceReason = value;
                        });
                      },
                    ),
                    const Text('Izin'),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Alpha',
                      groupValue: selectedAbsenceReason,
                      onChanged: (value) {
                        setState(() {
                          selectedAbsenceReason = value;
                        });
                      },
                    ),
                    const Text('Alpha'),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
