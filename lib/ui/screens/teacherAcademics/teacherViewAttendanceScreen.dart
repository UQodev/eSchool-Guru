import 'package:eschool_saas_staff/cubits/academics/classesCubit.dart';
import 'package:eschool_saas_staff/cubits/teacherAcademics/attendence/attendanceCubit.dart';
import 'package:eschool_saas_staff/data/models/classSection.dart';
import 'package:eschool_saas_staff/ui/screens/teacherAcademics/widgets/holidayAttendanceContainer.dart';
import 'package:eschool_saas_staff/ui/styles/themeExtensions/customColorsExtension.dart';
import 'package:eschool_saas_staff/ui/widgets/appbarFilterBackgroundContainer.dart';
import 'package:eschool_saas_staff/ui/widgets/customAppbar.dart';
import 'package:eschool_saas_staff/ui/widgets/customCircularProgressIndicator.dart';
import 'package:eschool_saas_staff/ui/widgets/customTextContainer.dart';
import 'package:eschool_saas_staff/ui/widgets/errorContainer.dart';
import 'package:eschool_saas_staff/ui/widgets/filterButton.dart';
import 'package:eschool_saas_staff/ui/widgets/filterSelectionBottomsheet.dart';
import 'package:eschool_saas_staff/ui/widgets/studentAttendanceContainer.dart';
import 'package:eschool_saas_staff/utils/constants.dart';
import 'package:eschool_saas_staff/utils/labelKeys.dart';
import 'package:eschool_saas_staff/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class TeacherViewAttendanceScreen extends StatefulWidget {
  static Widget getRouteInstance() {
    //final arguments = Get.arguments as Map<String,dynamic>;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AttendanceCubit(),
        ),
        BlocProvider(
          create: (context) => ClassesCubit(),
        ),
      ],
      child: const TeacherViewAttendanceScreen(),
    );
  }

  static Map<String, dynamic> buildArguments() {
    return {};
  }

  const TeacherViewAttendanceScreen({super.key});

  @override
  State<TeacherViewAttendanceScreen> createState() =>
      _TeacherViewAttendanceScreenState();
}

class _TeacherViewAttendanceScreenState
    extends State<TeacherViewAttendanceScreen> {
  bool? isPresentStatusOnly;
  DateTime _selectedDateTime = DateTime.now();
  ClassSection? _selectedClassSection;
  StudentAttendanceStatus? selectedStatus;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context.read<ClassesCubit>().getClasses();
    });
    super.initState();
  }

  void getAttendance({StudentAttendanceStatus? selectedStatus}) {
    context.read<AttendanceCubit>().fetchAttendance(
        date: _selectedDateTime,
        classSectionId: _selectedClassSection?.id ?? 0,
        type: isPresentStatusOnly == null
            ? (selectedStatus == null
                ? null
                : selectedStatus == StudentAttendanceStatus.present
                    ? 1
                    : selectedStatus == StudentAttendanceStatus.sick
                        ? 2
                        : selectedStatus == StudentAttendanceStatus.permission
                            ? 3
                            : selectedStatus == StudentAttendanceStatus.alpa
                                ? 4
                                : 0) // Default for absent
            : isPresentStatusOnly!
                ? 1
                : 0 // For absent (includes Sick, Permission, and Alpa)
        );
  }

  Widget _buildTotalTitleContainer(
      {required String value,
      required String title,
      required Color backgroundColor}) {
    return Container(
      height: 75,
      padding: EdgeInsets.symmetric(
          horizontal: appContentHorizontalPadding, vertical: 12.5),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextContainer(
            textKey: value,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
          ),
          CustomTextContainer(
            textKey: title,
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsContainer() {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
            top: Utils.appContentTopScrollPadding(context: context) + 145),
        child: BlocBuilder<AttendanceCubit, AttendanceState>(
          builder: (context, state) {
            if (state is AttendanceFetchSuccess) {
              if (state.isHoliday) {
                return HolidayAttendanceContainer(
                  holiday: state.holidayDetails,
                );
              }
              final isWeekend = _selectedDateTime.weekday == DateTime.sunday;

              if (state.attendance.isEmpty) {
                // Jika hari Minggu, tampilkan pesan "Tidak ada Kehadiran hari ini"
                if (isWeekend) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top:
                            Utils.appContentTopScrollPadding(context: context) +
                                110,
                      ),
                      child: CustomTextContainer(
                        textKey: Utils.getTranslatedLabel(noAttendanceKey),
                      ),
                    ),
                  );
                }

                // Jika hari biasa, tampilkan pesan "Belum ada Kehadiran"
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: Utils.appContentTopScrollPadding(context: context) +
                          110,
                    ),
                    child: CustomTextContainer(
                      textKey: Utils.getTranslatedLabel(noAttendanceYetKey),
                    ),
                  ),
                );
              }
              return Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: _buildTotalTitleContainer(
                          backgroundColor: Theme.of(context)
                              .extension<CustomColors>()!
                              .totalStaffOverviewBackgroundColor!
                              .withOpacity(0.3),
                          title: presentKey,
                          value: state.attendance
                              .where((element) => element.isPresent())
                              .length
                              .toString(),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: _buildTotalTitleContainer(
                          backgroundColor: Theme.of(context)
                              .extension<CustomColors>()!
                              .totalStudentOverviewBackgroundColor!
                              .withOpacity(0.3),
                          title: absentKey,
                          value: state.attendance
                              .where((element) => !element.isPresent())
                              .length
                              .toString(),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: _buildTotalTitleContainer(
                          backgroundColor: Theme.of(context)
                              .extension<CustomColors>()!
                              .sickBackgroundColor!
                              .withOpacity(0.3),
                          title: sickKey,
                          value: state.attendance
                              .where((element) => element.isSick())
                              .length
                              .toString(),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: _buildTotalTitleContainer(
                          backgroundColor: Theme.of(context)
                              .extension<CustomColors>()!
                              .permissionBackgroundColor!
                              .withOpacity(0.3),
                          title: permissionKey,
                          value: state.attendance
                              .where((element) => element.isPermission())
                              .length
                              .toString(),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: _buildTotalTitleContainer(
                          backgroundColor: Theme.of(context)
                              .extension<CustomColors>()!
                              .totalStudentOverviewBackgroundColor!
                              .withOpacity(0.3),
                          title: alpaKey,
                          value: state.attendance
                              .where((element) => element.isAlpa())
                              .length
                              .toString(),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  StudentAttendanceContainer(
                    studentAttendances: state.attendance,
                    isForAddAttendance: false,
                  ),
                ],
              );
            } else if (state is AttendanceFetchFailure) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: topPaddingOfErrorAndLoadingContainer),
                  child: ErrorContainer(
                    errorMessage: state.errorMessage,
                    onTapRetry: () {
                      getAttendance();
                    },
                  ),
                ),
              );
            } else {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: topPaddingOfErrorAndLoadingContainer),
                  child: CustomCircularProgressIndicator(
                    indicatorColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildAppbarAndFilters() {
    return Align(
      alignment: Alignment.topCenter,
      child: BlocConsumer<ClassesCubit, ClassesState>(
        listener: (context, state) {
          if (state is ClassesFetchSuccess) {
            if (_selectedClassSection == null &&
                state.primaryClasses.isNotEmpty) {
              _selectedClassSection = state.primaryClasses.first;
              setState(() {});
              getAttendance();
            }
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              const CustomAppbar(titleKey: viewAttendanceKey),
              AppbarFilterBackgroundContainer(
                height: 130,
                child: LayoutBuilder(builder: (context, boxConstraints) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FilterButton(
                                onTap: () {
                                  if (state is ClassesFetchSuccess &&
                                      state.primaryClasses.isNotEmpty) {
                                    Utils.showBottomSheet(
                                        child: FilterSelectionBottomsheet<
                                            ClassSection>(
                                          onSelection: (value) {
                                            Get.back();
                                            if (_selectedClassSection !=
                                                value) {
                                              _selectedClassSection = value;
                                              setState(() {});
                                              getAttendance();
                                            }
                                          },
                                          selectedValue: _selectedClassSection!,
                                          titleKey: classKey,
                                          values: state.primaryClasses,
                                        ),
                                        context: context);
                                  }
                                },
                                titleKey: _selectedClassSection?.id == null
                                    ? classKey
                                    : (_selectedClassSection?.fullName ?? ""),
                                width: boxConstraints.maxWidth * (0.48)),
                            FilterButton(
                                onTap: () {
                                  Utils.showBottomSheet(
                                      child: FilterSelectionBottomsheet<String>(
                                        onSelection: (value) {
                                          Get.back();
                                          bool refreshPage = false;
                                          if (value == allKey &&
                                              isPresentStatusOnly != null) {
                                            // Handle case for "Semua"
                                            isPresentStatusOnly = null;
                                            selectedStatus =
                                                null; // Reset status
                                            refreshPage = true;
                                          } else if (value == presentKey &&
                                              isPresentStatusOnly != true) {
                                            // Handle case for "Hadir"
                                            isPresentStatusOnly = true;
                                            selectedStatus =
                                                null; // Reset status for present
                                            refreshPage = true;
                                          } else if (value == absentKey &&
                                              isPresentStatusOnly != false) {
                                            // Handle case for "Tidak Hadir"
                                            isPresentStatusOnly = false;
                                            selectedStatus =
                                                null; // Absence combines sick, permission, and alpa
                                            refreshPage = true;
                                          } else if (value == sickKey &&
                                              selectedStatus !=
                                                  StudentAttendanceStatus
                                                      .sick) {
                                            // Handle case for "Sakit"
                                            isPresentStatusOnly =
                                                false; // Absence status includes sick
                                            selectedStatus =
                                                StudentAttendanceStatus.sick;
                                            refreshPage = true;
                                          } else if (value == permissionKey &&
                                              selectedStatus !=
                                                  StudentAttendanceStatus
                                                      .permission) {
                                            // Handle case for "Izin"
                                            isPresentStatusOnly =
                                                false; // Absence status includes permission
                                            selectedStatus =
                                                StudentAttendanceStatus
                                                    .permission;
                                            refreshPage = true;
                                          } else if (value == alpaKey &&
                                              selectedStatus !=
                                                  StudentAttendanceStatus
                                                      .alpa) {
                                            // Handle case for "Alpa"
                                            isPresentStatusOnly =
                                                false; // Absence status includes alpa
                                            selectedStatus =
                                                StudentAttendanceStatus.alpa;
                                            refreshPage = true;
                                          }
                                          if (refreshPage) {
                                            setState(() {});
                                            getAttendance();
                                          }
                                        },
                                        selectedValue: isPresentStatusOnly ==
                                                null
                                            ? allKey
                                            : isPresentStatusOnly!
                                                ? presentKey
                                                : selectedStatus ==
                                                        StudentAttendanceStatus
                                                            .sick
                                                    ? sickKey
                                                    : selectedStatus ==
                                                            StudentAttendanceStatus
                                                                .permission
                                                        ? permissionKey
                                                        : selectedStatus ==
                                                                StudentAttendanceStatus
                                                                    .alpa
                                                            ? alpaKey
                                                            : absentKey, // Default to "Tidak Hadir"
                                        titleKey: statusKey,
                                        values: const [
                                          allKey,
                                          presentKey,
                                          absentKey,
                                          // sickKey,
                                          // permissionKey,
                                          // alpaKey,
                                        ],
                                      ),
                                      context: context);
                                },
                                titleKey: isPresentStatusOnly == null
                                    ? allKey
                                    : isPresentStatusOnly!
                                        ? presentKey
                                        : selectedStatus ==
                                                StudentAttendanceStatus.sick
                                            ? sickKey
                                            : selectedStatus ==
                                                    StudentAttendanceStatus
                                                        .permission
                                                ? permissionKey
                                                : selectedStatus ==
                                                        StudentAttendanceStatus
                                                            .alpa
                                                    ? alpaKey
                                                    : absentKey,
                                width: boxConstraints.maxWidth * (0.48)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 40,
                        child: FilterButton(
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                                context: context,
                                currentDate: _selectedDateTime,
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 30)),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 30)));

                            if (selectedDate != null) {
                              _selectedDateTime = selectedDate;
                              setState(() {});
                              getAttendance();
                            }
                          },
                          titleKey: Utils.formatDate(_selectedDateTime),
                          width: boxConstraints.maxWidth,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<ClassesCubit, ClassesState>(
            builder: (context, state) {
              if (state is ClassesFetchSuccess) {
                return _buildStudentsContainer();
              }
              if (state is ClassesFetchFailure) {
                return Center(
                    child: ErrorContainer(
                  errorMessage: state.errorMessage,
                  onTapRetry: () {
                    context.read<ClassesCubit>().getClasses();
                  },
                ));
              }
              return Center(
                child: CustomCircularProgressIndicator(
                  indicatorColor: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
          _buildAppbarAndFilters(),
        ],
      ),
    );
  }
}
