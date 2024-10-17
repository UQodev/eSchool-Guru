import 'package:eschool_saas_staff/data/models/user.dart';

class AttendanceStudent {
  final int? id;
  final int? subjectAttendanceId;
  final int? studentId;
  final int? type;
  final String? note;
  final String? createdAt;
  final String? updatedAt;
  final User? user;

  AttendanceStudent({
    this.id,
    this.subjectAttendanceId,
    this.studentId,
    this.type,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory AttendanceStudent.fromJson(Map<String, dynamic> json) {
    return AttendanceStudent(
      id: json['id'] as int?,
      subjectAttendanceId: json['subject_attendance_id'] as int?,
      studentId: json['student_id'] as int?,
      type: json['type'] as int?,
      note: json['note'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject_attendance_id': subjectAttendanceId,
        'student_id': studentId,
        'type': type,
        'note': note,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'user': user?.toJson(),
      };
}
