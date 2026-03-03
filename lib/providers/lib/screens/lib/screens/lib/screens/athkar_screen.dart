import 'package:flutter/material.dart';

class AthkarScreen extends StatelessWidget {
  const AthkarScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'title': 'أذكار الصباح', 'icon': Icons.wb_sunny, 'color': Color(0xFFF39C12)},
    {'title': 'أذكار المساء', 'icon': Icons.nights_stay, 'color': Color(0xFF2C3E50)},
    {'title': 'أذكار النوم', 'icon': Icons.bedtime, 'color': Color(0xFF9B59B6)},
    {'title': 'أذكار بعد الصلاة', 'icon': Icons.mosque, 'color': Color(0xFF1A5F4A)},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('الأذكار والأدعية')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.3,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Card(
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(cat['icon'] as IconData, color: cat['color'] as Color, size: 40),
                  const SizedBox(height: 12),
                  Text(
                    cat['title'] as String,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF2C3E50),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

