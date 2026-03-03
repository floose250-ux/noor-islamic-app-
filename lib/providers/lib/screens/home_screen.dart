import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_times_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prayerProvider = Provider.of<PrayerTimesProvider>(context);
    final nextPrayer = prayerProvider.nextPrayer;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark 
                    ? [const Color(0xFF1A5F4A), const Color(0xFF0D3328)]
                    : [const Color(0xFF1A5F4A), const Color(0xFF2E8B6E)],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getIslamicDate(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('EEEE، d MMMM', 'ar').format(DateTime.now()),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings_outlined, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    
                    if (prayerProvider.isLoading)
                      const Center(child: CircularProgressIndicator(color: Colors.white))
                    else if (prayerProvider.error != null)
                      Text(
                        prayerProvider.error!,
                        style: const TextStyle(color: Colors.white),
                      )
                    else if (nextPrayer != null)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'الصلاة القادمة: ${nextPrayer['name']}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              nextPrayer['remaining'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.location_on, color: Color(0xFFD4A574), size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  prayerProvider.cityName,
                                  style: const TextStyle(
                                    color: Color(0xFFD4A574),
                                    fontSize: 14,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 600.ms),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionTitle('آية اليوم'),
                const SizedBox(height: 12),
                _buildAyahCard(isDark),
                const SizedBox(height: 24),
                _buildSectionTitle('الوصول السريع'),
                const SizedBox(height: 12),
                _buildQuickAccessGrid(context, isDark),
                const SizedBox(height: 24),
                _buildSectionTitle('أذكار سريعة'),
                const SizedBox(height: 12),
                _buildQuickAthkar(context, isDark),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _getIslamicDate() => '١٤ رمضان ١٤٤٥ هـ';

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFFD4A574),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildAyahCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: isDark
            ? [const Color(0xFF2D2D2D), const Color(0xFF1A1A1A)]
            : [Colors.white, const Color(0xFFF8F9FA)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'وَأَقِمِ الصَّلَاةَ لِدُلُوكِ الشَّمْسِ إِلَىٰ غَسَقِ اللَّيْلِ وَقُرْآنَ الْفَجْرِ ۖ إِنَّ قُرْآنَ الْفَجْرِ كَانَ مَشْهُودًا',
            style: TextStyle(
              fontSize: 20,
              height: 1.8,
              fontFamily: 'Amiri',
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 12),
          const Text(
            'الإسراء: ٧٨',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFFD4A574),
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildQuickAccessGrid(BuildContext context, bool isDark) {
    final items = [
      {'icon': Icons.menu_book, 'label': 'القرآن', 'color': const Color(0xFF1A5F4A)},
      {'icon': Icons.access_time, 'label': 'المواقيت', 'color': const Color(0xFFD4A574)},
      {'icon': Icons.favorite, 'label': 'الأذكار', 'color': const Color(0xFFE74C3C)},
      {'icon': Icons.explore, 'label': 'القبلة', 'color': const Color(0xFF3498DB)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: (item['color'] as Color).withOpacity(isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                item['icon'] as IconData,
                color: item['color'] as Color,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item['label'] as String,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : const Color(0xFF2C3E50),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickAthkar(BuildContext context, bool isDark) {
    final athkar = [
      {'text': 'سبحان الله', 'count': 33, 'color': const Color(0xFF1A5F4A)},
      {'text': 'الحمد لله', 'count': 33, 'color': const Color(0xFFD4A574)},
      {'text': 'الله أكبر', 'count': 33, 'color': const Color(0xFF3498DB)},
      {'text': 'لا إله إلا الله', 'count': 1, 'color': const Color(0xFF9B59B6)},
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: athkar.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final zikr = athkar[index];
          return Container(
            width: 140,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  zikr['text'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Amiri',
                    color: zikr['color'] as Color,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: (zikr['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${zikr['count']} مرة',
                    style: TextStyle(
                      fontSize: 12,
                      color: zikr['color'] as Color,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

