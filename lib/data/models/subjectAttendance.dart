import 'package:eschool_saas_staff/data/models/attendanceStudent.dart';
// import 'package:eschool_saas_staff/data/models/studentAttendance.dart';

class SubjectAttendance {
  final int? id;
  final int? classSectionId;
  final int? sessionYearId;
  final String? date;
  final int? schoolId;
  final int? timetableId;
  final int? jumlahJp;
  final String? materi;
  final String? lampiran;
  final String? createdAt;
  final String? updatedAt;
  final String? rollNumber;
  final List<AttendanceStudent>? attendanceStudent;

  SubjectAttendance({
    this.id,
    this.classSectionId,
    this.sessionYearId,
    this.date,
    this.schoolId,
    this.timetableId,
    this.jumlahJp,
    this.materi,
    this.lampiran,
    this.createdAt,
    this.updatedAt,
    this.rollNumber,
    this.attendanceStudent,
  });

  SubjectAttendance copyWith({
    int? id,
    int? classSectionId,
    int? sessionYearId,
    String? date,
    int? schoolId,
    int? timetableId,
    int? jumlahJp,
    String? materi,
    String? lampiran,
    String? createdAt,
    String? updatedAt,
    String? rollNumber,
    List<AttendanceStudent>? attendanceStudent,
  }) {
    return SubjectAttendance(
      id: id ?? this.id,
      classSectionId: classSectionId ?? this.classSectionId,
      sessionYearId: sessionYearId ?? this.sessionYearId,
      date: date ?? this.date,
      schoolId: schoolId ?? this.schoolId,
      timetableId: timetableId ?? this.timetableId,
      jumlahJp: jumlahJp ?? this.jumlahJp,
      materi: materi ?? this.materi,
      lampiran: lampiran ?? this.lampiran,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rollNumber: rollNumber ?? this.rollNumber,
      attendanceStudent: attendanceStudent ?? this.attendanceStudent,
    );
  }

  factory SubjectAttendance.fromJson(Map<String, dynamic> json) {
    return SubjectAttendance(
      id: json['id'] as int?,
      classSectionId: json['class_section_id'] as int?,
      sessionYearId: json['session_year_id'] as int?,
      date: json['date'] as String?,
      schoolId: json['school_id'] as int?,
      timetableId: json['timetable_id'] as int?,
      jumlahJp: json['jumlah_jp'] as int?,
      materi: json['materi'] as String?,
      lampiran: json['lampiran'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      rollNumber: json['roll_number'] as String?,
      attendanceStudent: (json['attendance_student'] as List<dynamic>?)
          ?.map((e) => AttendanceStudent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'class_section_id': classSectionId,
        'session_year_id': sessionYearId,
        'date': date,
        'school_id': schoolId,
        'timetable_id': timetableId,
        'jumlah_jp': jumlahJp,
        'materi': materi,
        'lampiran': lampiran,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'roll_number': rollNumber,
        'attendance_student':
            attendanceStudent?.map((e) => e.toJson()).toList(),
      };
}
