
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/bell_period.dart';

class AppData {
  final List<BellPeriod> periods;
  final bool autoBell;
  final String? soundPath;

  const AppData({
    required this.periods,
    required this.autoBell,
    required this.soundPath,
  });
}

class StorageService {
  static const String _periodsKey = 'school_bell_periods_v2';
  static const String _autoKey = 'school_bell_auto_v2';
  static const String _soundKey = 'school_bell_sound_v2';

  Future<AppData> load() async {
    final prefs = await SharedPreferences.getInstance();

    List<BellPeriod> periods = BellPeriod.defaults();
    final raw = prefs.getString(_periodsKey);

    if (raw != null) {
      try {
        final decoded = jsonDecode(raw) as List<dynamic>;

        periods = decoded.map((item) {
          return BellPeriod.fromJson(
            Map<String, dynamic>.from(item as Map),
          );
        }).toList();
      } catch (_) {
        periods = BellPeriod.defaults();
      }
    }

    periods.sort(
      (a, b) => a.startMinutes.compareTo(b.startMinutes),
    );

    return AppData(
      periods: periods,
      autoBell: prefs.getBool(_autoKey) ?? false,
      soundPath: prefs.getString(_soundKey),
    );
  }

  Future<void> save({
    required List<BellPeriod> periods,
    required bool autoBell,
    required String? soundPath,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _periodsKey,
      jsonEncode(periods.map((p) => p.toJson()).toList()),
    );

    await prefs.setBool(_autoKey, autoBell);

    if (soundPath == null || soundPath.isEmpty) {
      await prefs.remove(_soundKey);
    } else {
      await prefs.setString(_soundKey, soundPath);
    }
  }
}