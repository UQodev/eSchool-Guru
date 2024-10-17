import 'package:eschool_saas_staff/data/models/attendanceStudent.dart';
import 'package:eschool_saas_staff/data/models/holiday.dart';
import 'package:eschool_saas_staff/data/repositories/subjectAttendanceRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SubjectAttendanceState {}

class SubjectAttendanceInitial extends SubjectAttendanceState {}

class SubjectAttendanceFetchInProgress extends SubjectAttendanceState {}

class SubjectAttendanceFetchSuccess extends SubjectAttendanceState {
  final List<AttendanceStudent> attendance;
  final bool isHoliday;
  final Holiday holidayDetails;

  SubjectAttendanceFetchSuccess({
    required this.attendance,
    required this.isHoliday,
    required this.holidayDetails,
  });
}

class SubjectAttendanceFetchFailure extends SubjectAttendanceState {
  final String errorMessage;

  SubjectAttendanceFetchFailure(this.errorMessage);
}

class SubjectAttendanceCubit extends Cubit<SubjectAttendanceState> {
  final SubjectAttendanceRepository _subjectAttendanceRepository =
      SubjectAttendanceRepository();

  SubjectAttendanceCubit() : super(SubjectAttendanceInitial());

  Future<void> fetchSubjectAttendance({
    required int classSectionId,
    required DateTime date,
    required int? type,
    required int timetableId,
    // required int jumlahJp,
  }) async {
    emit(SubjectAttendanceFetchInProgress());
    try {
      final result = await _subjectAttendanceRepository.getAttendance(
        classSectionId: classSectionId,
        type: type,
        date: "${date.year}-${date.month}-${date.day}",
        timetableId: timetableId,
        // jumlahJp: jumlahJp
      );

      emit(SubjectAttendanceFetchSuccess(
          attendance: result.attendance,
          isHoliday: result.isHoliday,
          holidayDetails: result.holidayDetails));
    } catch (e) {
      emit(SubjectAttendanceFetchFailure(e.toString()));
    }
  }
}
