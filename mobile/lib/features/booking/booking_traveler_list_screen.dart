import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/mock_data.dart';

class TravelerListScreen extends StatelessWidget {
  const TravelerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final trips = MockData.trips;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Select Traveler',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        itemCount: trips.length,
        itemBuilder: (context, i) {
          final t = trips[i];
          return _TravelerCard(
            name: t['traveler']?.toString() ?? 'Traveler',
            rating: t['rating']?.toString() ?? '4.6',
            reviews: t['reviews']?.toString() ?? '102 reviews',
            route: t['route']?.toString() ?? '',
            capacity: t['capacity']?.toString() ?? '6 kg',
            rate: t['rate']?.toString() ?? '1500',
            badgeColor: () {
              final c = t['color'];
              if (c is int) return Color(c);
              if (c is String) return Color(int.tryParse(c) ?? 0xFF2E78F0);
              return const Color(0xFF2E78F0);
            }(),
            onTap: () => context.push('/book/traveler/${t['id']}'),
          );
        },
      ),
    );
  }
}

class _TravelerCard extends StatelessWidget {
  const _TravelerCard({
    required this.name,
    required this.rating,
    required this.reviews,
    required this.route,
    required this.capacity,
    required this.rate,
    required this.badgeColor,
    required this.onTap,
  });

  final String name;
  final String rating;
  final String reviews;
  final String route;
  final String capacity;
  final String rate;
  final Color badgeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E2EB)),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.flight_takeoff,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      route,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 14, color: Color(0xFFFFC107)),
                        const SizedBox(width: 4),
                        Text(
                          rating,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black87),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '($reviews)',
                          style: const TextStyle(
                              fontSize: 11, color: Colors.black45),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _Pill(text: 'Capacity $capacity'),
                        const SizedBox(width: 6),
                        _Pill(text: 'Rate Rs. $rate/kg'),
                      ],
                    )
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black38),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E2EB)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, color: Colors.black87),
      ),
    );
  }
}
