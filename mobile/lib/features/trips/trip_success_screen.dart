import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TripSuccessScreen extends StatelessWidget {
  const TripSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF1FF),
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.check_circle, size: 72, color: Color(0xFF2E78F0)),
              ),
              const SizedBox(height: 16),
              Text(
                'Trip Published',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                'Your trip is live. Travelers can now book against your capacity.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E2EB)),
                ),
                child: Column(
                  children: const [
                    _Row(label: 'Trip ID', value: 'TRIP-001'),
                    SizedBox(height: 8),
                    _Row(label: 'Route', value: 'LHE → RUH'),
                    SizedBox(height: 8),
                    _Row(label: 'Capacity', value: '6 kg • Rs. 1,500/kg'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go('/'),
                      child: const Text('Back to Home'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.go('/trip/trip1'),
                      child: const Text('View Trip'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => context.go('/trip/manage'),
                child: const Text('Manage my trips'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w700)),
        Text(value, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
