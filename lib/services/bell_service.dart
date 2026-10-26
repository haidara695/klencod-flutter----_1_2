
import 'package:audioplayers/audioplayers.dart';

import '../models/bell_period.dart';

class BellService {
  final AudioPlayer _player = AudioPlayer();

  String? _lastRingKey;

  void reset() {
    _lastRingKey = null;
  }

  Future<void> test(String? soundPath) async {
    await ring(soundPath);
  }

  void check(
    List<BellPeriod> periods,
    DateTime now,
    String? soundPath,
  ) {
    if (now.second != 0) return;

    final key =
        '${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}';

    if (_lastRingKey == key) return;

    final shouldRing = periods.any((period) {
      final startsNow =
          period.start.hour == now.hour &&
          period.start.minute == now.minute;

      final endsNow =
          period.end.hour == now.hour &&
          period.end.minute == now.minute;

      return startsNow || endsNow;
    });

    if (shouldRing) {
      _lastRingKey = key;
      ring(soundPath);
    }
  }

  Future<void> ring(String? soundPath) async {
    try {
      await _player.stop();

      if (soundPath != null && soundPath.isNotEmpty) {
        await _player.play(
          DeviceFileSource(soundPath),
        );
      } else {
        // نغمة احتياطية من النظام إذا لم يُحدَّد ملف.
        await _player.play(
          const UrlSource(
            'https://actions.google.com/sounds/v1/alarms/beep_short.ogg',
          ),
        );
      }
    } catch (_) {
      // نتجنب إغلاق التطبيق إذا تعذّر تشغيل الصوت.
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}