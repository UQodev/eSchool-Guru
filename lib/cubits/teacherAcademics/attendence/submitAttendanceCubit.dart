import 'package:eschool_saas_staff/data/repositories/attendanceRepository.dart';
import 'package:eschool_saas_staff/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SubmitAttendanceState {}

class SubmitAttendanceInitial extends SubmitAttendanceState {}

class SubmitAttendanceInProgress extends SubmitAttendanceState {}

class SubmitAttendanceSuccess extends SubmitAttendanceState {}

class SubmitAttendanceFailure extends SubmitAttendanceState {
  final String errorMessage;

  SubmitAttendanceFailure(this.errorMessage);
}

class SubmitAttendanceCubit extends Cubit<SubmitAttendanceState> {
  final AttendanceRepository _teacherRepository = AttendanceRepository();

  SubmitAttendanceCubit() : super(SubmitAttendanceInitial());

  Future<void> submitAttendance({
    required DateTime dateTime,
    required int classSectionId,
    required List<({StudentAttendanceStatus status, int studentId})>
        attendanceReport,
  }) async {
    emit(SubmitAttendanceInProgress());
    try {
      await _teacherRepository.submitAttendance(
        classSectionId: classSectionId,
        date: "${dateTime.year}-${dateTime.month}-${dateTime.day}",
        attendance: attendanceReport
            .map(
              (attendanceReport) => {
                "student_id": attendanceReport.studentId,
                "type": _mapAttendanceStatusToType(attendanceReport.status),
              },
            )
            .toList(),
      );
      emit(SubmitAttendanceSuccess());
    } catch (e) {
      print("Error during attendance submission: $e");
      emit(SubmitAttendanceFailure(e.toString()));
    }
  }

  int _mapAttendanceStatusToType(StudentAttendanceStatus status) {
    switch (status) {
      case StudentAttendanceStatus.present:
        return 1;
      case StudentAttendanceStatus.absent:
        return 0;
      case StudentAttendanceStatus.sick:
        return 2;
      case StudentAttendanceStatus.permission:
        return 3;
      case StudentAttendanceStatus.alpa:
        return 4;
      default:
        return 0; // Default ke absent jika status tidak dikenali
    }
  }
}
