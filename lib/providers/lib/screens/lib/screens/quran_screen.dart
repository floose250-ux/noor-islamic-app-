import 'package:flutter/material.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  final List<Map<String, dynamic>> surahs = const [
    {'number': 1, 'name': 'الفاتحة', 'verses': 7, 'type': 'مكية'},
    {'number': 2, 'name': 'البقرة', 'verses': 286, 'type': 'مدنية'},
    {'number': 3, 'name': 'آل عمران', 'verses': 200, 'type': 'مدنية'},
    {'number': 4, 'name': 'النساء', 'verses': 176, 'type': 'مدنية'},
    {'number': 5, 'name': 'المائدة', 'verses': 120, 'type': 'مدنية'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('القرآن الكريم')),
      body: ListView.builder(
        itemCount: surahs.length,
        itemBuilder: (context, index) {
          final surah = surahs[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF1A5F4A).withOpacity(0.1),
              child: Text('${surah['number']}', style: const TextStyle(color: Color(0xFF1A5F4A))),
            ),
            title: Text(surah['name'], style: const TextStyle(fontFamily: 'Amiri', fontSize: 20)),
            subtitle: Text('${surah['verses']} آية • ${surah['type']}', style: const TextStyle(fontFamily: 'Cairo')),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          );
        },
      ),
    );
  }
}
