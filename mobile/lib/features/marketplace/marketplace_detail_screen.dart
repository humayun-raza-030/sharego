import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/mock_data.dart';
import '../common/widgets.dart';

class ListingDetailScreen extends StatelessWidget {
  const ListingDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final listing = MockData.listings.firstWhere(
      (e) => e['id'] == id,
      orElse: () => MockData.listings.first,
    );
    final images = _extractImages(listing);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(listing['title']?.toString() ?? ''),
        actions: [
          IconButton(
            onPressed: () => context.push('/audit/report/new'),
            icon: const Icon(Icons.report_problem_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        children: [
          _ImageGrid(images: images),
          const SizedBox(height: 12),
          Text(
            listing['title']?.toString() ?? '',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            listing['desc']?.toString() ?? 'No description',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                listing['price']?.toString() ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2E78F0),
                ),
              ),
              StatusPill(
                listing['status']?.toString() ?? 'ACTIVE',
                tone: StatusTone.info,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.place_outlined, size: 18, color: Colors.black54),
              const SizedBox(width: 4),
              Text(
                listing['location']?.toString() ?? '',
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const DisclaimerBanner(),
          const SizedBox(height: 16),
          _SellerCard(
            name: listing['seller']?.toString() ?? 'Seller',
            rating: listing['rating']?.toString() ?? '4.6',
            offers: listing['offers']?.toString() ?? '12 offers',
          ),
          const SizedBox(height: 16),
          _InfoRow(
            label: 'Category',
            value: listing['category']?.toString() ?? 'General',
          ),
          _InfoRow(
            label: 'Condition',
            value: listing['condition']?.toString() ?? 'Used',
          ),
          _InfoRow(
            label: 'Last offer',
            value: listing['lastOffer']?.toString() ?? '--',
          ),
          const SizedBox(height: 20),
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
                  onPressed: () => context.push('/market/$id/meetup'),
                  child: const Text(
                    'Create meetup',
                    style: TextStyle(color: Color(0xFF2E78F0)),
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
                  onPressed: () => context.push('/market/$id/offer-thread'),
                  child: const Text('Send offer'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => context.push('/market/$id/mark-sold'),
            child: const Text('Mark sold'),
          )
        ],
      ),
    );
  }
}

class _ImageGrid extends StatelessWidget {
  const _ImageGrid({required this.images});
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, i) {
        final path = images[i];
        final isNetwork = path.startsWith('http');
        final heroTag = '$path-$i';
        return GestureDetector(
          onTap: () => showDialog(
            context: context,
            builder: (_) => Dialog(
              insetPadding: const EdgeInsets.all(12),
              backgroundColor: Colors.black,
              child: InteractiveViewer(
                child: Hero(
                  tag: heroTag,
                  child: isNetwork
                      ? Image.network(path, fit: BoxFit.contain)
                      : Image.asset(path, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFF7F8FC),
              border: Border.all(color: const Color(0xFFE0E2EB)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Hero(
                tag: heroTag,
                child: isNetwork
                    ? Image.network(path, fit: BoxFit.cover)
                    : Image.asset(path, fit: BoxFit.cover),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SellerCard extends StatelessWidget {
  const _SellerCard({
    required this.name,
    required this.rating,
    required this.offers,
  });

  final String name;
  final String rating;
  final String offers;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E2EB)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: Color(0xFF2E78F0),
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Color(0xFFFFC107)),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      offers,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: Colors.black87)),
          Text(value, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}

List<String> _extractImages(Map listing) {
  final imgs = listing['images'];
  if (imgs is List && imgs.isNotEmpty) {
    return imgs.map((e) => e.toString()).toList();
  }
  return const [
    'assets/1 mc.png',
    'assets/2 mc.png',
    'assets/3 mc.png',
    'assets/4 mc.png',
  ];
}
