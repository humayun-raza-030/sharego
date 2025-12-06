import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/mock_data.dart';
import '../common/widgets.dart';

class OfferThreadScreen extends StatelessWidget {
  const OfferThreadScreen({super.key, required this.listingId});
  final String listingId;

  @override
  Widget build(BuildContext context) {
    final offers =
        MockData.offers.where((o) => o['listingId'] == listingId).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text('Offers • $listingId'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: DisclaimerBanner(),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              itemCount: offers.length,
              itemBuilder: (context, i) {
                final o = offers[i];
                final status = o['status']?.toString() ?? '';
                final isSeller = (o['role']?.toString() ?? '') == 'seller';
                return Align(
                  alignment:
                      isSeller ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSeller
                          ? const Color(0xFF2E78F0).withValues(alpha: 0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E2EB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            StatusPill(
                              status,
                              tone: status.contains('accept')
                                  ? StatusTone.success
                                  : StatusTone.info,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              o['time']?.toString() ?? '',
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.black54),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          o['amount']?.toString() ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          o['message']?.toString() ?? '',
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          o['by']?.toString() ?? '',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _Composer(listingId: listingId),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.listingId});
  final String listingId;

  @override
  Widget build(BuildContext context) {
    final messageCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Offer amount (PKR)',
                      isDense: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 120,
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E78F0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Send'),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: messageCtrl,
              decoration: InputDecoration(
                hintText: 'Message',
                isDense: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.push('/audit/report/new'),
                child: const Text('Report issue'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
