// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

class TaskReminder {
  String? duration;
  int? interval;
  List<String>? reminderType;
  bool? disabled;
  TaskReminder({
    this.duration,
    this.interval,
    this.reminderType,
    this.disabled,
  });

  TaskReminder copyWith({
    String? duration,
    int? interval,
    List<String>? reminderType,
    bool? disabled,
  }) {
    return TaskReminder(
      duration: duration ?? this.duration,
      interval: interval ?? this.interval,
      reminderType: reminderType ?? this.reminderType,
      disabled: disabled ?? this.disabled,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'duration': duration,
      'interval': interval,
      'reminderType': reminderType,
      'disabled': disabled,
    };
  }

  factory TaskReminder.fromMap(Map<String, dynamic> map) {
    return TaskReminder(
      duration: map['duration'] != null ? map['duration'] as String : null,
      interval: map['interval'] != null ? map['interval'] as int : null,
      reminderType: map['reminderType'] != null
          ? List<String>.from((map['reminderType'] as List<dynamic>))
          : null,
      disabled: map['disabled'] != null ? map['disabled'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskReminder.fromJson(String source) =>
      TaskReminder.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaskReminder(duration: $duration, interval: $interval, reminderType: $reminderType, disabled: $disabled)';
  }

  @override
  bool operator ==(covariant TaskReminder other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.duration == duration &&
        other.interval == interval &&
        listEquals(other.reminderType, reminderType) &&
        other.disabled == disabled;
  }

  @override
  int get hashCode {
    return duration.hashCode ^
        interval.hashCode ^
        reminderType.hashCode ^
        disabled.hashCode;
  }
}
