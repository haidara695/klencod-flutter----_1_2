
import 'package:flutter/material.dart';

import '../models/bell_period.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List<BellPeriod> _periods = BellPeriod.defaults();

  String _time(TimeOfDay value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _editPeriod({BellPeriod? old, int? index}) async {
    final nameController =
        TextEditingController(text: old?.name ?? '');

    final classController = TextEditingController(
      text: old?.className ?? 'جميع الصفوف',
    );

    TimeOfDay start =
        old?.start ?? const TimeOfDay(hour: 7, minute: 30);

    TimeOfDay end =
        old?.end ?? const TimeOfDay(hour: 8, minute: 10);

    final result = await showDialog<BellPeriod>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, refresh) => AlertDialog(
          title: Text(old == null ? 'إضافة فترة' : 'تعديل الفترة'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الحصة أو الفسحة',
                  ),
                ),
                TextField(
                  controller: classController,
                  decoration: const InputDecoration(
                    labelText: 'الصف والشعبة',
                  ),
                ),
                ListTile(
                  title: const Text('وقت البداية'),
                  subtitle: Text(_time(start)),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: start,
                    );
                    if (picked != null) {
                      refresh(() => start = picked);
                    }
                  },
                ),
                ListTile(
                  title: const Text('وقت النهاية'),
                  subtitle: Text(_time(end)),
                  trailing: const Icon(Icons.access_time_filled),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: end,
                    );
                    if (picked != null) {
                      refresh(() => end = picked);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                final startMinutes = start.hour * 60 + start.minute;
                final endMinutes = end.hour * 60 + end.minute;

                if (name.isEmpty || endMinutes <= startMinutes) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'تحقق من الاسم ووقت البداية والنهاية',
                      ),
                    ),
                  );
                  return;
                }

                Navigator.pop(
                  dialogContext,
                  BellPeriod(
                    id: old?.id ??
                        DateTime.now().microsecondsSinceEpoch.toString(),
                    name: name,
                    className: classController.text.trim().isEmpty
                        ? 'جميع الصفوف'
                        : classController.text.trim(),
                    start: start,
                    end: end,
                  ),
                );
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );

    nameController.dispose();
    classController.dispose();

    if (result == null || !mounted) return;

    setState(() {
      if (index == null) {
        _periods.add(result);
      } else {
        _periods[index] = result;
      }

      _periods.sort(
        (a, b) => a.startMinutes.compareTo(b.startMinutes),
      );
    });
  }

  void _deletePeriod(int index) {
    setState(() => _periods.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editPeriod(),
        icon: const Icon(Icons.add),
        label: const Text('إضافة فترة'),
      ),
      body: _periods.isEmpty
          ? const Center(child: Text('لا توجد حصص في الجدول'))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
              itemCount: _periods.length,
              itemBuilder: (context, index) {
                final period = _periods[index];

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFE0EBFF),
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                      period.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${period.className}\n'
                      '${_time(period.start)} - ${_time(period.end)}',
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editPeriod(old: period, index: index);
                        } else if (value == 'delete') {
                          _deletePeriod(index);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('تعديل'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('حذف'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}