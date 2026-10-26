
import 'package:flutter/material.dart';

class BellPeriod {
  final String id;
  String name;
  String className;
  TimeOfDay start;
  TimeOfDay end;

  BellPeriod({
    required this.id,
    required this.name,
    required this.className,
    required this.start,
    required this.end,
  });

  int get startMinutes => start.hour * 60 + start.minute;

  int get endMinutes => end.hour * 60 + end.minute;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'className': className,
      'startHour': start.hour,
      'startMinute': start.minute,
      'endHour': end.hour,
      'endMinute': end.minute,
    };
  }

  factory BellPeriod.fromJson(Map<String, dynamic> json) {
    return BellPeriod(
      id: json['id'] as String? ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      name: json['name'] as String? ?? 'حصة جديدة',
      className: json['className'] as String? ?? 'جميع الصفوف',
      start: TimeOfDay(
        hour: json['startHour'] as int? ?? 7,
        minute: json['startMinute'] as int? ?? 30,
      ),
      end: TimeOfDay(
        hour: json['endHour'] as int? ?? 8,
        minute: json['endMinute'] as int? ?? 10,
      ),
    );
  }

  static List<BellPeriod> defaults() {
    return [
      BellPeriod(
        id: 'p1',
        name: 'الحصة الأولى',
        className: 'الصف الخامس أ',
        start: const TimeOfDay(hour: 7, minute: 30),
        end: const TimeOfDay(hour: 8, minute: 10),
      ),
      BellPeriod(
        id: 'p2',
        name: 'الحصة الثانية',
        className: 'الصف الخامس أ',
        start: const TimeOfDay(hour: 8, minute: 10),
        end: const TimeOfDay(hour: 8, minute: 50),
      ),
      BellPeriod(
        id: 'p3',
        name: 'الحصة الثالثة',
        className: 'الصف الخامس أ',
        start: const TimeOfDay(hour: 8, minute: 50),
        end: const TimeOfDay(hour: 9, minute: 30),
      ),
      BellPeriod(
        id: 'break',
        name: 'الفسحة',
        className: 'جميع الصفوف',
        start: const TimeOfDay(hour: 9, minute: 30),
        end: const TimeOfDay(hour: 9, minute: 50),
      ),
      BellPeriod(
        id: 'p4',
        name: 'الحصة الرابعة',
        className: 'الصف الخامس أ',
        start: const TimeOfDay(hour: 9, minute: 50),
        end: const TimeOfDay(hour: 10, minute: 30),
      ),
      BellPeriod(
        id: 'p5',
        name: 'الحصة الخامسة',
        className: 'الصف الخامس أ',
        start: const TimeOfDay(hour: 10, minute: 30),
        end: const TimeOfDay(hour: 11, minute: 10),
      ),
      BellPeriod(
        id: 'p6',
        name: 'الحصة السادسة',
        className: 'الصف الخامس أ',
        start: const TimeOfDay(hour: 11, minute: 10),
        end: const TimeOfDay(hour: 11, minute: 50),
      ),
    ];
  }
}