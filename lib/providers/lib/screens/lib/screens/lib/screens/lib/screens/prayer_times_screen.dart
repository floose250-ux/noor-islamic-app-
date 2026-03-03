import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_times_provider.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prayerProvider = Provider.of<PrayerTimesProvider>(context);
    final prayers = prayerProvider.allPrayersToday;

    return Scaffold(
      appBar: AppBar(
        title: const Text('مواقيت الصلاة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => prayerProvider.getCurrentLocation(),
          ),
        ],
      ),
      body: prayerProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : prayerProvider.error != null
          ? Center(child: Text(prayerProvider.error!))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: prayers.length,
              itemBuilder: (context, index) {
                final prayer = prayers[index];
                final isNext = prayerProvider.nextPrayer?['name'] == prayer['name'];
                
                return Card(
                  color: isNext ? const Color(0xFF1A5F4A) : null,
                  child: ListTile(
                    leading: Icon(prayer['icon'] as IconData),
                    title: Text(
                      prayer['name'] as String,
                      style: TextStyle(
                        color: isNext ? Colors.white : null,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      prayerProvider.formatTime(prayer['time'] as DateTime?),
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Cairo',
                        color: isNext ? Colors.white : const Color(0xFFD4A574),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

