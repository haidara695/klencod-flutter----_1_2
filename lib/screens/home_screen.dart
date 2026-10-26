
import 'dart:async';

import 'package:flutter/material.dart';

import '../models/bell_period.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;
  DateTime _now = DateTime.now();
  bool _autoBell = false;

  final List<BellPeriod> _periods = BellPeriod.defaults();

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (!mounted) return;

        setState(() {
          _now = DateTime.now();
        });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _two(int value) =>
      value.toString().padLeft(2, '0');

  String _clock(DateTime value) =>
      '${_two(value.hour)}:${_two(value.minute)}:${_two(value.second)}';

  String _time(TimeOfDay value) =>
      '${_two(value.hour)}:${_two(value.minute)}';

  @override
  Widget build(BuildContext context) {
    final minute = _now.hour * 60 + _now.minute;

    BellPeriod? current;

    for (final period in _periods) {
      if (minute >= period.startMinutes &&
          minute < period.endMinutes) {
        current = period;
        break;
      }
    }

    final upcoming = _periods
        .where((p) => p.startMinutes > minute)
        .toList()
      ..sort(
        (a, b) => a.startMinutes.compareTo(b.startMinutes),
      );

    final next = upcoming.isEmpty ? null : upcoming.first;

    DateTime? target;

    if (current != null) {
      target = DateTime(
        _now.year,
        _now.month,
        _now.day,
        current.end.hour,
        current.end.minute,
      );
    } else if (next != null) {
      target = DateTime(
        _now.year,
        _now.month,
        _now.day,
        next.start.hour,
        next.start.minute,
      );
    }

    final seconds = target == null
        ? 0
        : target.difference(_now).inSeconds.clamp(0, 86400);

    final countdown =
        '${_two(seconds ~/ 3600)}:'
        '${_two((seconds % 3600) ~/ 60)}:'
        '${_two(seconds % 60)}';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF173D7A),
                Color(0xFF2867B2),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'الوقت الحالي',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _clock(_now),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _info(
                'الحصة الحالية',
                current?.name ?? 'لا توجد حصة الآن',
                current?.className ?? 'خارج وقت الحصص',
              ),
              const SizedBox(height: 12),
              _info(
                'الحصة القادمة',
                next?.name ?? 'انتهى الجدول',
                next == null
                    ? 'لا توجد حصص لاحقة اليوم'
                    : _time(next.start),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.hourglass_bottom,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'الوقت المتبقي',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Text(
                    countdown,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: SwitchListTile(
            value: _autoBell,
            onChanged: (value) {
              setState(() => _autoBell = value);
            },
            secondary: const Icon(
              Icons.notifications_active_outlined,
            ),
            title: const Text(
              'الجرس التلقائي',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              'سيتم ربطه بخدمة الصوت في النسخة المتكاملة',
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'تطوير وبرمجة: أ. محمد حيدرة',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        const SizedBox(height: 5),
        const Center(
          child: Text(
            'للتواصل: 785068859',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _info(
    String title,
    String value,
    String subtitle,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}