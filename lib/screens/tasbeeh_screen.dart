import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> {
  int count = 0;
  int target = 33;
  String selectedZikr = 'سبحان الله';
  
  final List<String> azkar = [
    'سبحان الله',
    'الحمد لله',
    'الله أكبر',
    'لا إله إلا الله',
  ];

  void _increment() {
    HapticFeedback.lightImpact();
    setState(() => count++);
  }

  void _reset() => setState(() => count = 0);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = count / target;

    return Scaffold(
      appBar: AppBar(title: const Text('السبحة الإلكترونية')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 250,
                    height: 250,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: progress > 1 ? 1 : progress,
                          strokeWidth: 10,
                          backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1A5F4A)),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                selectedZikr,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Amiri',
                                  color: isDark ? Colors.white : const Color(0xFF2C3E50),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$count',
                                style: const TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                  color: Color(0xFF1A5F4A),
                                ),
                              ),
                              Text(
                                'من $target',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  FloatingActionButton.large(
                    onPressed: _increment,
                    backgroundColor: const Color(0xFF1A5F4A),
                    child: const Icon(Icons.add, size: 40),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Wrap(
                  spacing: 8,
                  children: azkar.map((z) {
                    final isSelected = z == selectedZikr;
                    return ChoiceChip(
                      label: Text(z, style: const TextStyle(fontFamily: 'Cairo')),
                      selected: isSelected,
                      onSelected: (_) => setState(() {
                        selectedZikr = z;
                        count = 0;
                      }),
                      selectedColor: const Color(0xFF1A5F4A),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : null,
                        fontFamily: 'Cairo',
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة', style: TextStyle(fontFamily: 'Cairo')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

