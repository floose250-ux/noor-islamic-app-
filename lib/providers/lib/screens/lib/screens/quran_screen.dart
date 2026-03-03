import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  List<dynamic> surahs = [];
  List<dynamic> filteredSurahs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadQuran();
  }

  Future<void> loadQuran() async {
    try {
      final String response = await rootBundle.loadString('assets/data/quran.json');
      final data = await json.decode(response);
      setState(() {
        surahs = data['surahs'];
        filteredSurahs = surahs;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void filterSurahs(String query) {
    setState(() {
      filteredSurahs = surahs.where((s) => 
        s['name'].toString().contains(query) ||
        s['number'].toString().contains(query)
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('القرآن الكريم'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: filterSurahs,
              decoration: InputDecoration(
                hintText: 'ابحث في السور...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: filteredSurahs.length,
            itemBuilder: (context, index) {
              final surah = filteredSurahs[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF1A5F4A).withOpacity(0.1),
                  child: Text(
                    '${surah['number']}',
                    style: const TextStyle(color: Color(0xFF1A5F4A)),
                  ),
                ),
                title: Text(
                  surah['name'],
                  style: const TextStyle(fontFamily: 'Amiri', fontSize: 20),
                ),
                subtitle: Text(
                  '${surah['verses']} آية • ${surah['type']}',
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _openSurah(surah),
              );
            },
          ),
    );
  }

  void _openSurah(Map<String, dynamic> surah) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurahDetailScreen(surah: surah),
      ),
    );
  }
}

class SurahDetailScreen extends StatelessWidget {
  final Map<String, dynamic> surah;

  const SurahDetailScreen({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('سورة ${surah['name']}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (surah['number'] != 9)
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 24,
                    color: Color(0xFF1A5F4A),
                  ),
                ),
              ),
            Text(
              surah['text'] ?? 'جاري تحميل النص...',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 24,
                height: 2.5,
                color: isDark ? Colors.white : const Color(0xFF2C3E50),
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}

