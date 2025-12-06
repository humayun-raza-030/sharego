import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/mock_data.dart';

class TravelerDetailScreen extends StatelessWidget {
  const TravelerDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final trip = MockData.trips
        .firstWhere((e) => e['id'] == id, orElse: () => MockData.trips.first);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black87),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E2EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: const Color(0xFFFD9272),
                          child: const Icon(Icons.person,
                              color: Colors.white, size: 30),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trip['traveler']?.toString() ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 14, color: Color(0xFFFFC107)),
                                  const SizedBox(width: 4),
                                  Text(
                                    trip['rating']?.toString() ?? '4.6',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '(${trip['reviews'] ?? '1344 reviews'})',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.bookmark_border,
                            color: Colors.black45, size: 24),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _DetailRow(
                      label: 'From:',
                      value: trip['fromAirport']?.toString() ??
                          'Allama Iqbal International Airport, Lahore',
                    ),
                    _DetailRow(
                      label: 'To:',
                      value: trip['toAirport']?.toString() ??
                          'King Khalid International Airport, Riyadh',
                    ),
                    _DetailRow(
                      label: 'Date:',
                      value: trip['date']?.toString() ?? '10:00 AM, 27/10/2025',
                    ),
                    _DetailRow(
                      label: 'Capacity:',
                      value: '${trip['capacity']} kg',
                    ),
                    _DetailRow(
                      label: 'Rate per kg:',
                      value: 'Rs. ${trip['rate']}',
                    ),
                    _DetailRow(
                      label: 'User\'s Budget:',
                      value: 'Rs. ${trip['userBudget']}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Center(
                child: Text(
                  'Reviews',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFE0E2EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xFF6DB8FF),
                          child:
                              Icon(Icons.person, color: Colors.white, size: 20),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Satisfied Experience!',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: List.generate(
                        5,
                        (index) => const Icon(Icons.star,
                            size: 14, color: Color(0xFFFFC107)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Fantastic way to make my flight profitable! I listed my trip from LHR to Dubai, got a request almost instantly, and the whole process was smooth. The escrow system gave me peace of mind and the delivery OTP made the handover super secure. Earned enough for my airport lounge...',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFF2E78F0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => context.push('/book/details'),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
