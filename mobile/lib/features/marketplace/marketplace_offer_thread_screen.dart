import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_theme.dart';
import '../../core/providers.dart';
import '../common/widgets.dart';

class OfferThreadScreen extends ConsumerStatefulWidget {
  const OfferThreadScreen({super.key, required this.listingId});
  final String listingId;

  @override
  ConsumerState<OfferThreadScreen> createState() => _OfferThreadScreenState();
}

class _OfferThreadScreenState extends ConsumerState<OfferThreadScreen> {
  List<Map<String, dynamic>> _offers = [];
  bool _loading = true;
  String? _error;

  final _amountCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _fetchOffers();
  }

  Future<void> _fetchOffers() async {
    try {
      final service = ref.read(marketplaceServiceProvider);
      final data = await service.listOffers(int.parse(widget.listingId));
      if (mounted) setState(() { _offers = data; _loading = false; });
    } catch (e) {
      if (mounted) {
        String msg = e.toString().replaceFirst('Exception: ', '');
        if (e is DioException && e.response?.data is Map) {
          msg = e.response!.data['detail']?.toString() ?? msg;
        }
        setState(() { _error = msg; _loading = false; });
      }
    }
  }

  Future<void> _sendOffer() async {
    final amountStr = _amountCtrl.text.trim();
    final amount = double.tryParse(amountStr);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount')),
      );
      return;
    }

    setState(() => _sending = true);
    try {
      final service = ref.read(marketplaceServiceProvider);
      final msg = _messageCtrl.text.trim();
      await service.sendOffer(
        listingId: int.parse(widget.listingId),
        amount: amount,
        message: msg.isNotEmpty ? msg : null,
      );
      _amountCtrl.clear();
      _messageCtrl.clear();
      // Refresh the list after sending.
      setState(() { _loading = true; _sending = false; });
      await _fetchOffers();
    } catch (e) {
      if (mounted) {
        setState(() => _sending = false);
        String msg = e.toString().replaceFirst('Exception: ', '');
        if (e is DioException && e.response?.data is Map) {
          msg = e.response!.data['detail']?.toString() ?? msg;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text('Offers • ${widget.listingId}'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: DisclaimerBanner(),
          ),
          Expanded(child: _buildBody()),
          _buildComposer(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: SkeletonList(items: 3, itemHeight: 80),
      );
    }
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ErrorBanner(_error!),
            const SizedBox(height: 12),
            TextButton(onPressed: () { setState(() { _loading = true; _error = null; }); _fetchOffers(); }, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (_offers.isEmpty) {
      return const EmptyState(
        icon: Icons.local_offer_outlined,
        title: 'No offers yet',
        subtitle: 'Be the first to send an offer!',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      itemCount: _offers.length,
      itemBuilder: (context, i) {
        final o = _offers[i];
        final status = o['status']?.toString() ?? '';
        final isMine = o['is_mine'] == true;
        final amount = o['amount'] ?? o['offer_amount'];
        final amountStr = amount != null ? 'PKR $amount' : '';
        final message = o['message']?.toString() ?? '';
        final byName = o['buyer_name']?.toString() ?? o['by']?.toString() ?? '';
        final createdAt = timeAgo(o['created_at']?.toString());

        return Align(
          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isMine ? AppTheme.primary.withValues(alpha: 0.1) : Colors.white,
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
                      tone: status.toLowerCase().contains('accept') ? StatusTone.success : StatusTone.info,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(createdAt, style: const TextStyle(fontSize: 11, color: Colors.black54), overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(amountStr, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(message, style: const TextStyle(fontSize: 13)),
                ],
                const SizedBox(height: 2),
                Text(byName, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildComposer() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Offer amount (PKR)',
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 120,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _sending ? null : _sendOffer,
                    child: _sending
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Send'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _messageCtrl,
              decoration: InputDecoration(
                hintText: 'Message (optional)',
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.push('/audit/report/new'),
                child: const Text('Report issue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
