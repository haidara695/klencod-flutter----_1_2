
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SoundScreen extends StatefulWidget {
  const SoundScreen({super.key});

  @override
  State<SoundScreen> createState() => _SoundScreenState();
}

class _SoundScreenState extends State<SoundScreen> {
  final AudioPlayer _player = AudioPlayer();

  String? _soundPath;
  bool _playing = false;

  Future<void> _chooseSound() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return;

    final path = result.files.single.path;

    if (path == null) {
      _showMessage('تعذّر الوصول إلى الملف الصوتي');
      return;
    }

    setState(() {
      _soundPath = path;
      _playing = false;
    });
  }

  Future<void> _playSound() async {
    if (_soundPath == null) {
      _showMessage('اختر ملفًا صوتيًا أولًا');
      return;
    }

    try {
      await _player.stop();
      await _player.play(DeviceFileSource(_soundPath!));

      if (mounted) {
        setState(() => _playing = true);
      }
    } catch (_) {
      _showMessage('تعذّر تشغيل الملف. جرّب ملفًا آخر.');
    }
  }

  Future<void> _stopSound() async {
    await _player.stop();

    if (mounted) {
      setState(() => _playing = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileName = _soundPath?.split('/').last;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF173D7A),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Column(
            children: [
              Icon(
                Icons.music_note,
                color: Colors.white,
                size: 54,
              ),
              SizedBox(height: 10),
              Text(
                'صوت الجرس المدرسي',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'اختر نغمة من ملفات جهازك',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(
              Icons.audio_file,
              color: Color(0xFF173D7A),
              size: 34,
            ),
            title: const Text('الصوت المحدد'),
            subtitle: Text(fileName ?? 'لم يتم اختيار صوت بعد'),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _chooseSound,
          icon: const Icon(Icons.folder_open),
          label: const Text('اختيار صوت من الجهاز'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _playing ? _stopSound : _playSound,
          icon: Icon(_playing ? Icons.stop : Icons.play_arrow),
          label: Text(
            _playing ? 'إيقاف المعاينة' : 'تشغيل الصوت للتجربة',
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'تنبيه: هذه الواجهة تختبر اختيار الصوت وتشغيله. '
          'سنربط الصوت المختار بجدول الجرس في مرحلة الربط النهائية.',
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}