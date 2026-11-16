class StudentProfileModel {
  final String displayName;
  final String degreeName;
  final String academicPeriod;
  final String semester;
  final String? avatarPath;

  StudentProfileModel({
    this.displayName = 'Estudiante',
    this.degreeName = '',
    this.academicPeriod = '',
    this.semester = '',
    this.avatarPath,
  });

  String get initials {
    final parts = displayName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'HS';
  }

  StudentProfileModel copyWith({
    String? displayName,
    String? degreeName,
    String? academicPeriod,
    String? semester,
    String? avatarPath,
  }) {
    return StudentProfileModel(
      displayName: displayName ?? this.displayName,
      degreeName: degreeName ?? this.degreeName,
      academicPeriod: academicPeriod ?? this.academicPeriod,
      semester: semester ?? this.semester,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }

  Map<String, dynamic> toJson() => {
    'displayName': displayName,
    'degreeName': degreeName,
    'academicPeriod': academicPeriod,
    'semester': semester,
    'avatarPath': avatarPath,
  };

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) =>
      StudentProfileModel(
        displayName: json['displayName'] as String? ?? 'Alejandro Gómez',
        degreeName: json['degreeName'] as String? ?? 'Grado en Ing. Informática',
        academicPeriod: json['academicPeriod'] as String? ?? '2024-II',
        semester: json['semester'] as String? ?? '4° Semestre',
        avatarPath: json['avatarPath'] as String?,
      );
}
