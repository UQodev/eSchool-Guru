import 'package:eschool_saas_staff/data/models/classSection.dart';
import 'package:eschool_saas_staff/data/models/classTimetableSlot.dart';
import 'package:eschool_saas_staff/data/models/medium.dart';
import 'package:eschool_saas_staff/data/models/role.dart';
import 'package:eschool_saas_staff/data/models/sessionYear.dart';
import 'package:eschool_saas_staff/data/models/teacherSubject.dart';
import 'package:eschool_saas_staff/utils/api.dart';

class AcademicRepository {
  Future<({List<ClassSection> classes, List<ClassSection> primaryClasses})>
      getClasses() async {
    try {
      final result = await Api.get(url: Api.getClasses);

      return (
        classes: ((result['other'] ?? []) as List)
            .map((classDetails) =>
                ClassSection.fromJson(Map.from(classDetails ?? {})))
            .toList(),
        primaryClasses: ((result['class_teacher'] ?? []) as List)
            .map((classDetails) => ClassSection.fromJson(
                Map.from(classDetails?['class_section'] ?? {})))
            .toList()
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<ClassSection>> getClassesWithTeacherDetails() async {
    try {
      final result =
          await Api.post(url: Api.getClassesWithTeacherDetails, body: {});
      return ((result['data'] ?? []) as List)
          .map((classDetails) =>
              ClassSection.fromJson(Map.from(classDetails ?? {})))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<SessionYear>> getSessionYears() async {
    try {
      final result = await Api.get(url: Api.getSessionYears);
      return ((result['data'] ?? []) as List)
          .map((sessionYear) =>
              SessionYear.fromJson(Map.from(sessionYear ?? {})))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<Medium>> getMediums() async {
    try {
      final result = await Api.get(url: Api.getMediums);
      return ((result['data'] ?? []) as List)
          .map((medium) => Medium.fromJson(Map.from(medium ?? {})))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<TeacherSubject>> getClassSectionSubjects(
      {required int classSectionId}) async {
    try {
      final result = await Api.get(
          url: Api.getSubjects,
          queryParameters: {"class_section_id": classSectionId});
      return ((result['data'] ?? []) as List)
          .map((teacherSubject) =>
              TeacherSubject.fromJson(Map.from(teacherSubject ?? {})))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<ClassTimeTableSlot>> getClassTimetable(
      {required int classSectionId}) async {
    try {
      final result = await Api.get(
          url: Api.getClassTimetable,
          queryParameters: {"class_section_id": classSectionId});
      return ((result['data'] ?? []) as List)
          .map((classTimetableSlot) =>
              ClassTimeTableSlot.fromJson(Map.from(classTimetableSlot ?? {})))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<Role>> getRoles() async {
    try {
      final result = await Api.get(
        url: Api.getRoles,
      );
      return ((result['data'] ?? []) as List)
          .map((role) => Role.fromJson(Map.from(role ?? {})))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
