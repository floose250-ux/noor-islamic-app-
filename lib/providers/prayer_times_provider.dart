import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class PrayerTimesProvider extends ChangeNotifier {
  PrayerTimes? _prayerTimes;
  String _cityName = 'جاري تحديد الموقع...';
  bool _isLoading = true;
  String? _error;

  DateTime? get fajr => _prayerTimes?.fajr;
  DateTime? get sunrise => _prayerTimes?.sunrise;
  DateTime? get dhuhr => _prayerTimes?.dhuhr;
  DateTime? get asr => _prayerTimes?.asr;
  DateTime? get maghrib => _prayerTimes?.maghrib;
  DateTime? get isha => _prayerTimes?.isha;

  String get cityName => _cityName;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Map<String, dynamic>? get nextPrayer {
    if (_prayerTimes == null) return null;
    
    final now = DateTime.now();
    final prayers = [
      {'name': 'الفجر', 'time': fajr!, 'icon': Icons.wb_twilight},
      {'name': 'الشروق', 'time': sunrise!, 'icon': Icons.wb_sunny},
      {'name': 'الظهر', 'time': dhuhr!, 'icon': Icons.sunny},
      {'name': 'العصر', 'time': asr!, 'icon': Icons.wb_sunny_outlined},
      {'name': 'المغرب', 'time': maghrib!, 'icon': Icons.wb_twilight_rounded},
      {'name': 'العشاء', 'time': isha!, 'icon': Icons.nights_stay},
    ];

    for (var prayer in prayers) {
      if ((prayer['time'] as DateTime).isAfter(now)) {
        final difference = (prayer['time'] as DateTime).difference(now);
        return {
          'name': prayer['name'],
          'time': prayer['time'],
          'icon': prayer['icon'],
          'remaining': _formatDuration(difference),
        };
      }
    }

    final tomorrowFajr = fajr!.add(const Duration(days: 1));
    final difference = tomorrowFajr.difference(now);
    return {
      'name': 'الفجر',
      'time': tomorrowFajr,
      'icon': Icons.wb_twilight,
      'remaining': _formatDuration(difference),
    };
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  PrayerTimesProvider() {
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _error = 'خدمة الموقع معطلة';
        _isLoading = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _error = 'تم رفض الصلاحية';
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition();
      _calculatePrayerTimes(position.latitude, position.longitude);

    } catch (e) {
      _error = 'خطأ: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void _calculatePrayerTimes(double lat, double lng) {
    final coordinates = Coordinates(lat, lng);
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;
    
    final date = DateComponents.from(DateTime.now());
    _prayerTimes = PrayerTimes(coordinates, date, params);
    
    _cityName = 'الموقع الحالي';
    _isLoading = false;
    notifyListeners();
  }

  String formatTime(DateTime? time) {
    if (time == null) return '--:--';
    return DateFormat('HH:mm').format(time);
  }

  List<Map<String, dynamic>> get allPrayersToday {
    if (_prayerTimes == null) return [];
    
    return [
      {'name': 'الفجر', 'time': fajr, 'icon': Icons.wb_twilight},
      {'name': 'الشروق', 'time': sunrise, 'icon': Icons.wb_sunny},
      {'name': 'الظهر', 'time': dhuhr, 'icon': Icons.sunny},
      {'name': 'العصر', 'time': asr, 'icon': Icons.wb_sunny_outlined},
      {'name': 'المغرب', 'time': maghrib, 'icon': Icons.wb_twilight_rounded},
      {'name': 'العشاء', 'time': isha, 'icon': Icons.nights_stay},
    ];
  }
}
