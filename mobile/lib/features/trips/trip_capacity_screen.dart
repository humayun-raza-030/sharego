import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TripCapacityScreen extends StatelessWidget {
  const TripCapacityScreen({super.key});

  InputDecoration _input(String label, {String? hint}) => InputDecoration(
        labelText: label,
        hintText: hint,
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E2EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2E78F0), width: 1.4),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.white,
        title: const Text('Trip details'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        children: [
          _Card(
            title: 'Luggage / Capacity',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Available capacity (kg)',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: _input('Capacity', hint: '10'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _Card(
            title: 'Pricing',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fees per kg (PKR)',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: _input('Fees per kg', hint: '1500'),
                ),
                const SizedBox(height: 12),
                Text('Budget / expected earning (PKR)',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: _input('Budget', hint: '50000'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _Card(
            title: 'Traveler information',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(decoration: _input('Name', hint: 'Ali Raza')),
                const SizedBox(height: 10),
                TextField(
                    decoration: _input('Email', hint: 'ali@example.com'),
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 10),
                TextField(
                    decoration: _input('Phone', hint: '+92 300 1234567'),
                    keyboardType: TextInputType.phone),
                const SizedBox(height: 10),
                TextField(
                    decoration: _input('CNIC', hint: '35202-xxxxxxx-x'),
                    keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                          decoration: _input('Exp Month', hint: '07'),
                          keyboardType: TextInputType.number),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                          decoration: _input('Exp Year', hint: '2028'),
                          keyboardType: TextInputType.number),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'If previously added, fields preload and stay editable.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => context.push('/trip/new/summary'),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E2EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
