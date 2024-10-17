import 'package:eschool_saas_staff/data/models/student.dart';

class User {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? image;
  final String? fullName;
  final String? schoolNames;
  final String? role;
  final Student? student;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.image,
    this.fullName,
    this.schoolNames,
    this.role,
    this.student,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      image: json['image'] as String?,
      fullName: json['full_name'] as String?,
      schoolNames: json['school_names'] as String?,
      role: json['role'] as String?,
      student: json['student'] == null
          ? null
          : Student.fromJson(json['student'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'image': image,
        'full_name': fullName,
        'school_names': schoolNames,
        'role': role,
        'student': student?.toJson(),
      };
}
