
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 20),
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Color(0xFF173D7A),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active,
              color: Colors.white,
              size: 54,
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Center(
          child: Text(
            'الجرس المدرسي V2',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            'تنظيم الحصص ومواعيد الجرس المدرسي',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ),
        const SizedBox(height: 28),
        const Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.person_outline),
                title: Text('اسم المطوّر'),
                subtitle: Text('أ. محمد حيدرة'),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.phone_outlined),
                title: Text('رقم التواصل'),
                subtitle: Text('785068859'),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.code),
                title: Text('لغة البرمجة'),
                subtitle: Text('Flutter / Dart'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Text(
            'جميع الحقوق محفوظة للمطوّر',
            style: TextStyle(color: Colors.black45),
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            'By قروب الذكاء الاصطناعي والتعليم',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black45),
          ),
        ),
      ],
    );
  }
}