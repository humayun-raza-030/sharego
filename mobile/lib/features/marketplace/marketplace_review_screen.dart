import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListingReviewScreen extends StatelessWidget {
  const ListingReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Review listing'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          children: [
            _SummaryCard(
              title: 'Apple MacBook Pro',
              price: 'PKR 150,000',
              location: 'Lahore',
              condition: 'Used',
            ),
            const SizedBox(height: 14),
            const _SummaryCard(
              title: 'Safety',
              subtitle:
                  'Marketplace is peer-to-peer. ShareGo does not handle delivery or payments.',
              showDivider: false,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E78F0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => context.go('/market/new/success'),
                child: const Text(
                  'Post listing',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    this.subtitle,
    this.price,
    this.location,
    this.condition,
    this.showDivider = true,
  });

  final String title;
  final String? subtitle;
  final String? price;
  final String? location;
  final String? condition;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E2EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          if (price != null || location != null || condition != null) ...[
            const SizedBox(height: 6),
            Text(price ?? '',
                style: const TextStyle(
                    color: Color(0xFF2E78F0),
                    fontWeight: FontWeight.w700,
                    fontSize: 14)),
            if (location != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(location!,
                    style: const TextStyle(
                        fontSize: 13, color: Colors.black54)),
              ),
            if (condition != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text('Condition: $condition',
                    style: const TextStyle(fontSize: 13)),
              ),
          ],
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
          if (showDivider) ...[
            const SizedBox(height: 10),
            const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}
