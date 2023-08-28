import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  static SharedPreferences? _prefs;

  static Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Methods from the first class

  static Future<void> saveBedTimeValues(
    int initHour,
    int initMinute,
    int endHour,
    int endMinute,
    bool isDisableRange,
  ) async {
    await _initPrefs();
    _prefs!.setInt('init_hour', initHour);
    _prefs!.setInt('init_minute', initMinute);
    _prefs!.setInt('end_hour', endHour);
    _prefs!.setInt('end_minute', endMinute);
    _prefs!.setBool('is_disable_range', isDisableRange);
  }

  static Future<Map<String, dynamic>> getBedTimeValues() async {
    await _initPrefs();
    int initHour = _prefs!.getInt('init_hour') ?? 0;
    int initMinute = _prefs!.getInt('init_minute') ?? 0;
    int endHour = _prefs!.getInt('end_hour') ?? 8;
    int endMinute = _prefs!.getInt('end_minute') ?? 0;
    bool isDisableRange = _prefs!.getBool('is_disable_range') ?? false;

    return {
      'initHour': initHour,
      'initMinute': initMinute,
      'endHour': endHour,
      'endMinute': endMinute,
      'isDisableRange': isDisableRange,
    };
  }

  // Methods from the second class

  static const String sleepGoalKey = 'sleep_goal';

  static Future<DateTime> getSleepGoal() async {
    await _initPrefs();
    final savedTimeInMillis =
        _prefs!.getInt(sleepGoalKey) ?? DateTime.now().millisecondsSinceEpoch;
    return DateTime.fromMillisecondsSinceEpoch(savedTimeInMillis);
  }

  static Future<void> setSleepGoal(DateTime selectedTime) async {
    await _initPrefs();
    _prefs!.setInt(sleepGoalKey, selectedTime.millisecondsSinceEpoch);
  }

  static const String wakeUpAlarmKey = 'wake_up_alarm';
  static const String bedTimeAlarmKey = 'bed_time_alarm';

  static Future<bool> getWakeUpAlarmEnabled() async {
    await _initPrefs();
    return _prefs!.getBool(wakeUpAlarmKey) ?? false;
  }

  static Future<void> setWakeUpAlarmEnabled(bool isEnabled) async {
    await _initPrefs();
    _prefs!.setBool(wakeUpAlarmKey, isEnabled);
  }

  static Future<bool> getBedTimeAlarmEnabled() async {
    await _initPrefs();
    return _prefs!.getBool(bedTimeAlarmKey) ?? false;
  }

  static Future<void> setBedTimeAlarmEnabled(bool isEnabled) async {
    await _initPrefs();
    _prefs!.setBool(bedTimeAlarmKey, isEnabled);
  }

  //new method for isRingtonePlayingKey
  static const String isRingtonePlayingKey = 'is_ringtone_playing';

  static Future<bool> getIsRingtonePlaying() async {
    await _initPrefs();
    return _prefs!.getBool(isRingtonePlayingKey) ?? false;
  }

  static Future<void> setIsRingtonePlaying(bool isPlaying) async {
    await _initPrefs();
    _prefs!.setBool(isRingtonePlayingKey, isPlaying);
  }
}
