import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

enum EventType {
  exam,
  assignment,
  academicActivity;

  String get displayName {
    switch (this) {
      case EventType.exam:
        return 'Examen';
      case EventType.assignment:
        return 'Entrega Proyecto';
      case EventType.academicActivity:
        return 'Deberes';
    }
  }

  String get shortTag {
    switch (this) {
      case EventType.exam:
        return 'EXAMEN';
      case EventType.assignment:
        return 'ENTREGA PROYECTO';
      case EventType.academicActivity:
        return 'DEBERES';
    }
  }

  Color get color {
    switch (this) {
      case EventType.exam:
        return AppColors.exam;
      case EventType.assignment:
        return AppColors.assignment;
      case EventType.academicActivity:
        return AppColors.activity;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case EventType.exam:
        return AppColors.examLight;
      case EventType.assignment:
        return AppColors.assignmentLight;
      case EventType.academicActivity:
        return AppColors.activityLight;
    }
  }

  IconData get iconData {
    switch (this) {
      case EventType.exam:
        return Icons.edit_calendar_rounded;
      case EventType.assignment:
        return Icons.folder_zip_rounded;
      case EventType.academicActivity:
        return Icons.assignment_turned_in_rounded;
    }
  }
}

class AcademicEventModel {
  final String id;
  final String subjectId;
  final String title;
  final EventType type;
  final String description;
  final DateTime dueAt;
  final bool hasDueTime;
  final int targetPomodoros;
  final int completedPomodoros;
  final bool isCompleted;
  final int academicWeight; // Ponderación opcional en nota (ej. 30%)
  final bool isPriority;

  AcademicEventModel({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.type,
    this.description = '',
    required this.dueAt,
    this.hasDueTime = true,
    this.targetPomodoros = 4,
    this.completedPomodoros = 0,
    this.isCompleted = false,
    this.academicWeight = 0,
    this.isPriority = false,
  });

  double get progress {
    if (targetPomodoros <= 0) return 0.0;
    final val = completedPomodoros / targetPomodoros;
    return val > 1.0 ? 1.0 : val;
  }

  int get progressPercent => (progress * 100).round();

  AcademicEventModel copyWith({
    String? id,
    String? subjectId,
    String? title,
    EventType? type,
    String? description,
    DateTime? dueAt,
    bool? hasDueTime,
    int? targetPomodoros,
    int? completedPomodoros,
    bool? isCompleted,
    int? academicWeight,
    bool? isPriority,
  }) {
    return AcademicEventModel(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      title: title ?? this.title,
      type: type ?? this.type,
      description: description ?? this.description,
      dueAt: dueAt ?? this.dueAt,
      hasDueTime: hasDueTime ?? this.hasDueTime,
      targetPomodoros: targetPomodoros ?? this.targetPomodoros,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
      isCompleted: isCompleted ?? this.isCompleted,
      academicWeight: academicWeight ?? this.academicWeight,
      isPriority: isPriority ?? this.isPriority,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'subjectId': subjectId,
    'title': title,
    'type': type.name,
    'description': description,
    'dueAt': dueAt.toIso8601String(),
    'hasDueTime': hasDueTime,
    'targetPomodoros': targetPomodoros,
    'completedPomodoros': completedPomodoros,
    'isCompleted': isCompleted,
    'academicWeight': academicWeight,
    'isPriority': isPriority,
  };

  factory AcademicEventModel.fromJson(Map<String, dynamic> json) =>
      AcademicEventModel(
        id: json['id'] as String,
        subjectId: json['subjectId'] as String,
        title: json['title'] as String,
        type: EventType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => EventType.exam,
        ),
        description: json['description'] as String? ?? '',
        dueAt: DateTime.parse(json['dueAt'] as String),
        hasDueTime: json['hasDueTime'] as bool? ?? true,
        targetPomodoros: json['targetPomodoros'] as int? ?? 4,
        completedPomodoros: json['completedPomodoros'] as int? ?? 0,
        isCompleted: json['isCompleted'] as bool? ?? false,
        academicWeight: json['academicWeight'] as int? ?? 0,
        isPriority: json['isPriority'] as bool? ?? false,
      );
}
