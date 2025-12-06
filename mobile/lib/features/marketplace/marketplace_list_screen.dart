import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/mock_data.dart';
import '../common/widgets.dart';

class MarketplaceListScreen extends StatelessWidget {
  const MarketplaceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listings = MockData.listings;
    final isOffline = MockData.offline;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Marketplace'),
        actions: [
          IconButton(
            onPressed: () => context.push('/market/new'),
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Post listing',
          ),
        ],
      ),
      body: Column(
        children: [
          if (isOffline) const OfflineBanner(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: _SearchBar(),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 6),
            child: DisclaimerBanner(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  _FilterChip(label: 'All'),
                  SizedBox(width: 8),
                  _FilterChip(label: 'Electronics'),
                  SizedBox(width: 8),
                  _FilterChip(label: 'Fashion'),
                  SizedBox(width: 8),
                  _FilterChip(label: 'Home'),
                ],
              ),
            ),
          ),
          Expanded(
            child: listings.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: SkeletonList(items: 3, itemHeight: 120),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                    itemCount: listings.length,
                    itemBuilder: (context, i) {
                      final l = listings[i];
                      final status = l['status']?.toString() ?? 'ACTIVE';
                      return _ListingCard(
                        title: l['title']?.toString() ?? '',
                        price: l['price']?.toString() ?? 'PKR --',
                        location: l['location']?.toString() ?? '',
                        status: status,
                        lastOffer: l['lastOffer']?.toString() ?? '--',
                        thumbnail: _firstImage(l),
                        onTap: () => context.push('/market/${l['id']}'),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF2E78F0),
        onPressed: () => context.push('/market/new'),
        icon: const Icon(Icons.camera_alt_outlined),
        label: const Text('Create listing'),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search items, categories, locations',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: const Color(0xFFF7F8FC),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E2EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E2EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E78F0)),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: label == 'All',
      onSelected: (_) {},
      selectedColor: const Color(0xFF2E78F0).withValues(alpha: 0.12),
      checkmarkColor: const Color(0xFF2E78F0),
      shape: StadiumBorder(
        side: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  const _ListingCard({
    required this.title,
    required this.price,
    required this.location,
    required this.status,
    required this.lastOffer,
    required this.thumbnail,
    required this.onTap,
  });

  final String title;
  final String price;
  final String location;
  final String status;
  final String lastOffer;
  final String thumbnail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE0E2EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 86,
              height: 86,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFF7F8FC),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _ThumbImage(path: thumbnail),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12, top: 12, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E78F0),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        StatusPill(
                          status,
                          tone: status == 'SOLD'
                              ? StatusTone.success
                              : StatusTone.info,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Last offer $lastOffer',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThumbImage extends StatelessWidget {
  const _ThumbImage({required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    final isNetwork = path.startsWith('http');
    final imageWidget = isNetwork
        ? Image.network(path, fit: BoxFit.cover)
        : Image.asset(path, fit: BoxFit.cover);
    return Stack(
      fit: StackFit.expand,
      children: [
        imageWidget,
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E2EB)),
            ),
          ),
        ),
      ],
    );
  }
}

String _firstImage(Map listing) {
  final imgs = listing['images'];
  if (imgs is List && imgs.isNotEmpty) {
    final first = imgs.first.toString();
    if (first.isNotEmpty) return first;
  }
  return _fallbackImages().first;
}

List<String> _fallbackImages() => const [
      'assets/1 ps5.png', // PS5
      'assets/1 mc.png',
    ];
