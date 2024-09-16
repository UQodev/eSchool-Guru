import 'package:eschool_saas_staff/data/models/studentDetails.dart';
import 'package:eschool_saas_staff/data/repositories/studentRepository.dart';
import 'package:eschool_saas_staff/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class StudentsByClassSectionState {}

class StudentsByClassSectionInitial extends StudentsByClassSectionState {}

class StudentsByClassSectionFetchInProgress
    extends StudentsByClassSectionState {}

class StudentsByClassSectionFetchSuccess extends StudentsByClassSectionState {
  final List<StudentDetails> studentDetailsList;

  StudentsByClassSectionFetchSuccess({required this.studentDetailsList});
}

class StudentsByClassSectionFetchFailure extends StudentsByClassSectionState {
  final String errorMessage;

  StudentsByClassSectionFetchFailure(this.errorMessage);
}

class StudentsByClassSectionCubit extends Cubit<StudentsByClassSectionState> {
  final StudentRepository _studentRepository = StudentRepository();

  StudentsByClassSectionCubit() : super(StudentsByClassSectionInitial());

  void updateState(StudentsByClassSectionState updatedState) {
    emit(updatedState);
  }

  Future<void> fetchStudents({
    required int classSectionId,
    int? classSubjectId,
    int? examId,
    StudentListStatus? status,
  }) async {
    emit(StudentsByClassSectionFetchInProgress());
    try {
      emit(
        StudentsByClassSectionFetchSuccess(
          studentDetailsList:
              await _studentRepository.getStudentsByClassSectionAndSubject(
            classSectionId: classSectionId,
            status: status,
            classSubjectId: classSubjectId,
            examId: examId,
          ),
        ),
      );
    } catch (e) {
      emit(StudentsByClassSectionFetchFailure(e.toString()));
    }
  }

  List<StudentDetails> getStudents() {
    return (state is StudentsByClassSectionFetchSuccess)
        ? (state as StudentsByClassSectionFetchSuccess).studentDetailsList
        : [];
  }
}
