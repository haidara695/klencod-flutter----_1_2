
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoBell = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
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
              'تفعيل أو إيقاف الخيار من هذه الواجهة',
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'معلومات مهمة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'قد يتوقف الرنين عند إغلاق التطبيق أو تقييد '
                  'عمله في الخلفية. يحتاج الرنين الموثوق أثناء '
                  'إغلاق الشاشة إلى تكامل إضافي مع نظام Android '
                  'واختبار الصلاحيات على الجهاز.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('المطوّر'),
            subtitle: Text('أ. محمد حيدرة — 785068859'),
          ),
        ),
      ],
    );
  }
}