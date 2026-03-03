import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'dart:math' as math;

class QiblahScreen extends StatefulWidget {
  const QiblahScreen({super.key});

  @override
  State<QiblahScreen> createState() => _QiblahScreenState();
}

class _QiblahScreenState extends State<QiblahScreen> {
  Stream<QiblahDirection>? _stream;

  @override
  void initState() {
    super.initState();
    _stream = FlutterQiblah.qiblahStream;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('اتجاه القبلة')),
      body: StreamBuilder<QiblahDirection>(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final qiblah = snapshot.data!;
          final angle = qiblah.qiblah * (math.pi / 180) * -1;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${qiblah.qiblah.toStringAsFixed(1)}°',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 40),
              Transform.rotate(
                angle: angle,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1A5F4A),
                      width: 4,
                    ),
                  ),
                  child: const Icon(
                    Icons.navigation,
                    size: 80,
                    color: Color(0xFFD4A574),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'أمسك الجهاز أفقياً',
                style: TextStyle(fontFamily: 'Cairo', color: Colors.grey),
              ),
            ],
          );
        },
      ),
    );
  }
}

