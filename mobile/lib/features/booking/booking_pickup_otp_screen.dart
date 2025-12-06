import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PickupOtpScreen extends StatelessWidget {
  const PickupOtpScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pickup OTP'),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 48, color: Color(0xFF2E78F0)),
            const SizedBox(height: 12),
            Text(
              'Share this OTP only at pickup',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'This code confirms pickup with the traveler. Do not share over chat.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E2EB)),
              ),
              child: Column(
                children: const [
                  Text(
                    '482193',
                    style: TextStyle(
                      fontSize: 32,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'One-time code • Expires after delivery step',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.go('/booking/$id/timeline'),
                    child: const Text('Back to timeline'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E78F0),
                    ),
                    onPressed: () => context.push('/audit/report/new'),
                    child: const Text('Report issue'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
