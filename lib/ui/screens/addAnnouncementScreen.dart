import 'package:eschool_saas_staff/cubits/academics/classesCubit.dart';
import 'package:eschool_saas_staff/cubits/announcement/sendGeneralAnnouncementCubit.dart';
import 'package:eschool_saas_staff/data/models/classSection.dart';
import 'package:eschool_saas_staff/ui/screens/teacherAcademics/widgets/customFileContainer.dart';
import 'package:eschool_saas_staff/ui/widgets/customAppbar.dart';
import 'package:eschool_saas_staff/ui/widgets/customCircularProgressIndicator.dart';
import 'package:eschool_saas_staff/ui/widgets/customDropdownSelectionButton.dart';
import 'package:eschool_saas_staff/ui/widgets/customRoundedButton.dart';
import 'package:eschool_saas_staff/ui/widgets/customTextContainer.dart';
import 'package:eschool_saas_staff/ui/widgets/customTextFieldContainer.dart';
import 'package:eschool_saas_staff/ui/widgets/errorContainer.dart';
import 'package:eschool_saas_staff/ui/widgets/multiSelectionValueBottomsheet.dart';
import 'package:eschool_saas_staff/ui/widgets/uploadImageOrFileButton.dart';
import 'package:eschool_saas_staff/utils/constants.dart';
import 'package:eschool_saas_staff/utils/labelKeys.dart';
import 'package:eschool_saas_staff/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

class AddAnnouncementScreen extends StatefulWidget {
  const AddAnnouncementScreen({super.key});

  static Widget getRouteInstance() {
    //final arguments = Get.arguments as Map<String,dynamic>;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SendGeneralAnnouncementCubit(),
        ),
        BlocProvider(
          create: (context) => ClassesCubit(),
        ),
      ],
      child: const AddAnnouncementScreen(),
    );
  }

  static Map<String, dynamic> buildArguments() {
    return {};
  }

  @override
  State<AddAnnouncementScreen> createState() => _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  List<ClassSection> _selectedClassSections = [];
  bool _selectAllClasses = false;

  late final TextEditingController _titleTextEditingController =
      TextEditingController();
  late final TextEditingController _descriptionTextEditingController =
      TextEditingController();

  final List<PlatformFile> _pickedFiles = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<ClassesCubit>().getClasses();
    });
  }

  @override
  void dispose() {
    _titleTextEditingController.dispose();
    _descriptionTextEditingController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    final result = await Utils.openFilePicker(context: context);
    if (result != null) {
      _pickedFiles.addAll(result.files);
      setState(() {});
    }
  }

  void _toggleSelectAllClasses(bool? value) {
    setState(() {
      _selectAllClasses = value ?? false;
      if (_selectAllClasses) {
        _selectedClassSections = context.read<ClassesCubit>().getAllClasses();
      } else {
        _selectedClassSections.clear();
      }
    });
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<ClassesCubit, ClassesState>(
      builder: (context, state) {
        if (state is! ClassesFetchSuccess) {
          return const SizedBox();
        }
        return Align(
            alignment: Alignment.bottomCenter,
            child: BlocConsumer<SendGeneralAnnouncementCubit,
                SendGeneralAnnouncementState>(
              listener: (context, sendGeneralAnnouncementState) {
                if (sendGeneralAnnouncementState
                    is SendGeneralAnnouncementSuccess) {
                  Utils.showSnackBar(
                      message: announcementSentSuccessfullyKey,
                      context: context);
                  _titleTextEditingController.clear();
                  _descriptionTextEditingController.clear();
                  _selectedClassSections.clear();
                  _pickedFiles.clear();
                  setState(() {});
                } else if (sendGeneralAnnouncementState
                    is SendGeneralAnnouncementFailure) {
                  Utils.showSnackBar(
                      message: sendGeneralAnnouncementState.errorMessage,
                      context: context);
                }
              },
              builder: (context, sendGeneralAnnouncementState) {
                return PopScope(
                  canPop: sendGeneralAnnouncementState
                      is! SendGeneralAnnouncementInProgress,
                  child: Container(
                    padding: EdgeInsets.all(appContentHorizontalPadding),
                    decoration: BoxDecoration(boxShadow: const [
                      BoxShadow(
                          color: Colors.black12, blurRadius: 1, spreadRadius: 1)
                    ], color: Theme.of(context).colorScheme.surface),
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    child: CustomRoundedButton(
                      height: 40,
                      widthPercentage: 1.0,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      buttonTitle: submitKey,
                      showBorder: false,
                      child: sendGeneralAnnouncementState
                              is SendGeneralAnnouncementInProgress
                          ? const CustomCircularProgressIndicator()
                          : null,
                      onTap: () {
                        if (sendGeneralAnnouncementState
                            is SendGeneralAnnouncementInProgress) {
                          return;
                        }

                        if (_titleTextEditingController.text.trim().isEmpty) {
                          Utils.showSnackBar(
                              message: pleaseEnterTitleKey, context: context);
                          return;
                        }

                        if (_selectedClassSections.isEmpty) {
                          Utils.showSnackBar(
                              message: pleaseSelectAtLeastOneClassKey,
                              context: context);
                          return;
                        }

                        context
                            .read<SendGeneralAnnouncementCubit>()
                            .sendGeneralAnnouncement(
                                description: _descriptionTextEditingController
                                    .text
                                    .trim(),
                                filePaths: _pickedFiles
                                    .map((e) => e.path ?? "")
                                    .toList(),
                                title: _titleTextEditingController.text.trim(),
                                classSectionIds: _selectedClassSections
                                    .map((e) => e.id ?? 0)
                                    .toList());
                      },
                    ),
                  ),
                );
              },
            ));
      },
    );
  }

  Widget _buildClassSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomSelectionDropdownSelectionButton(
                onTap: () {
                  Utils.showBottomSheet(
                    child: MultiSelectionValueBottomsheet<ClassSection>(
                      values: context.read<ClassesCubit>().getAllClasses(),
                      selectedValues: List.from(_selectedClassSections),
                      titleKey: classKey,
                    ),
                    context: context,
                  ).then((value) {
                    if (value != null) {
                      final classes = List<ClassSection>.from(value as List);
                      setState(() {
                        _selectedClassSections =
                            List<ClassSection>.from(classes);
                        _selectAllClasses = _selectedClassSections.length ==
                            context.read<ClassesCubit>().getAllClasses().length;
                      });
                    }
                  });
                },
                titleKey: classSectionKey,
              ),
            ),
            const SizedBox(width: 5),
            Row(
              children: [
                Checkbox(
                  value: _selectAllClasses,
                  onChanged: _toggleSelectAllClasses,
                ),
                Text(
                  'Pilih Semua',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 15),
        Wrap(
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          spacing: 10,
          runSpacing: 10,
          children: _selectedClassSections
              .map(
                (classSection) => Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextContainer(
                        textKey: classSection.fullName ?? "-",
                      ),
                      const SizedBox(width: 7.5),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _selectedClassSections.remove(classSection);
                            _selectAllClasses = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent),
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 17.50,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
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
                return Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: 100,
                      left: appContentHorizontalPadding,
                      right: appContentHorizontalPadding,
                      top: Utils.appContentTopScrollPadding(context: context) +
                          20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFieldContainer(
                          textEditingController: _titleTextEditingController,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          hintTextKey: titleKey,
                        ),
                        CustomTextFieldContainer(
                          textEditingController:
                              _descriptionTextEditingController,
                          maxLines: 5,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          hintTextKey: descriptionKey,
                        ),
                        _buildClassSelectionSection(),
                        const SizedBox(height: 25),
                        UploadImageOrFileButton(
                          uploadFile: true,
                          includeImageFileOnlyAllowedNote: true,
                          onTap: () {
                            _pickFiles();
                          },
                        ),
                        ...List.generate(_pickedFiles.length, (index) => index)
                            .map(
                          (index) => Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: CustomFileContainer(
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              onDelete: () {
                                _pickedFiles.removeAt(index);
                                setState(() {});
                              },
                              title: _pickedFiles[index].name,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is ClassesFetchFailure) {
                return Center(
                  child: ErrorContainer(
                    errorMessage: state.errorMessage,
                    onTapRetry: () {
                      context.read<ClassesCubit>().getClasses();
                    },
                  ),
                );
              }

              return Center(
                child: CustomCircularProgressIndicator(
                  indicatorColor: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
          _buildSubmitButton(),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppbar(
              titleKey: addAnnouncementKey,
              onBackButtonTap: () {
                if (context.read<SendGeneralAnnouncementCubit>().state
                    is SendGeneralAnnouncementInProgress) {
                  return;
                }
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }
}
