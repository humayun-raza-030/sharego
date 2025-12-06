import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: Text('Trip $id', style: const TextStyle(color: Colors.black87)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: _card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Lahore -> Riyadh',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '27/10/2025 | Saudia SV 735',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Capacity: 6 kg | Rate: PKR 1500 per kg',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Bookings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: _card,
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('BKG-12345',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                    subtitle: const Text('Status: HOLD',
                        style: TextStyle(fontSize: 12, color: Colors.black54)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        context.push('/booking/BKG-12345/timeline'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('BKG-67890',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                    subtitle: const Text('Status: PICKED_UP',
                        style: TextStyle(fontSize: 12, color: Colors.black54)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        context.push('/booking/BKG-67890/timeline'),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF2E78F0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Pause Trip',
                      style: TextStyle(
                        color: Color(0xFF2E78F0),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E78F0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () =>
                        context.push('/audit/report/new'),
                    child: const Text(
                      'Report Issue',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

const _card = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(12)),
  border: Border.fromBorderSide(BorderSide(color: Color(0xFFE0E2EB))),
);
