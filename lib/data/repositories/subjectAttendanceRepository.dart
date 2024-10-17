import 'package:eschool_saas_staff/data/models/attendanceStudent.dart';
import 'package:eschool_saas_staff/data/models/holiday.dart';
import 'package:eschool_saas_staff/utils/api.dart';

class SubjectAttendanceRepository {
  Future<
      ({
        List<AttendanceStudent> attendance,
        bool isHoliday,
        Holiday holidayDetails
      })> getAttendance({
    required int classSectionId,
    required int? type,
    required String date,
    required int timetableId,
    // required int jumlahJp,
  }) async {
    try {
      final result = await Api.get(
        url: Api.getSubjectAttendance,
        useAuthToken: true,
        queryParameters: {
          "class_section_id": classSectionId,
          "date": date,
          "timetable_id": timetableId,
          // "jumlah_jp": jumlahJp,
          if (type != null) "type": type
        },
      );

      return (
        attendance: (result['data'] as List)
            .map(
              (attendanceReport) =>
                  AttendanceStudent.fromJson(attendanceReport),
            )
            .toList(),
        isHoliday: result['is_holiday'] as bool,
        holidayDetails: Holiday.fromJson(
          Map.from(result['holiday'] == null
              ? {}
              : (result['holiday'] as List).firstOrNull ?? {}),
        )
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> submitSubjectAttendance({
    required int classSectionId,
    required String date,
    required int timetableId,
    required int jumlahJp,
    required List<Map<String, dynamic>> attendance,
  }) async {
    try {
      await Api.post(
        url: Api.submitAttendance,
        useAuthToken: true,
        body: {
          "attendance": attendance,
          "class_section_id": classSectionId,
          "timetable_id": timetableId,
          "date": date,
          "jumlah_jp": jumlahJp
        },
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
