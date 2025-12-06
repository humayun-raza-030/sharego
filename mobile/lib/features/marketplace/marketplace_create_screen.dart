import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListingCreateScreen extends StatefulWidget {
  const ListingCreateScreen({super.key});

  @override
  State<ListingCreateScreen> createState() => _ListingCreateScreenState();
}

class _ListingCreateScreenState extends State<ListingCreateScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _conditionCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text('List product'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const _StepBadge(text: '1/3 Photos'),
          _PhotoPickerRow(),
          const SizedBox(height: 18),
          const _StepBadge(text: '2/3 Details'),
          _SectionCard(
            title: 'Listing info',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Field('Title', controller: _titleCtrl),
                _Field('Description', controller: _descCtrl, maxLines: 3),
                Row(
                  children: [
                    Expanded(
                        child: _Field('Price (PKR)', controller: _priceCtrl)),
                    const SizedBox(width: 10),
                    Expanded(
                        child:
                            _Field('Condition', controller: _conditionCtrl)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _SectionCard(
            title: 'Category & location',
            child: Column(
              children: [
                _Field('Category', controller: _categoryCtrl),
                _Field('Location', controller: _locationCtrl),
              ],
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E78F0),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => context.push('/market/new/review'),
              child: const Text(
                'Review listing',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E2EB)),
        boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field(this.label, {required this.controller, this.maxLines = 1});
  final String label;
  final TextEditingController controller;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: Colors.black87)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE0E2EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF2E78F0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepBadge extends StatelessWidget {
  const _StepBadge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF2E78F0).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E78F0),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoPickerRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        4,
        (i) => Expanded(
          child: Container(
            height: 86,
            margin: EdgeInsets.only(right: i == 3 ? 0 : 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E2EB)),
              color: const Color(0xFFF7F8FC),
            ),
            child: const Icon(Icons.image, color: Colors.black45),
          ),
        ),
      ),
    );
  }
}
