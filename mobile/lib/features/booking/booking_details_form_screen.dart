import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookingDetailsFormScreen extends StatelessWidget {
  const BookingDetailsFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final senderNameCtrl = TextEditingController();
    final senderEmailCtrl = TextEditingController();
    final senderPhoneCtrl = TextEditingController();
    final itemNameCtrl = TextEditingController();
    final itemWeightCtrl = TextEditingController();
    final itemDescCtrl = TextEditingController();
    final itemPriceCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Full Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 18),

              // Sender Info card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E2EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Sender Info / Buyer Contact',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _LabelField(
                      label: 'Name:',
                      controller: senderNameCtrl,
                    ),
                    _LabelField(
                      label: 'Email:',
                      controller: senderEmailCtrl,
                    ),
                    _LabelField(
                      label: 'Phone:',
                      controller: senderPhoneCtrl,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Item Info card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E2EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Item Info',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _LabelField(
                      label: 'Name:',
                      controller: itemNameCtrl,
                    ),
                    _LabelField(
                      label: 'Weight:',
                      controller: itemWeightCtrl,
                    ),
                    _LabelField(
                      label: 'Description:',
                      controller: itemDescCtrl,
                      maxLines: 3,
                    ),
                    _LabelField(
                      label: 'Item Price:',
                      controller: itemPriceCtrl,
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
                    backgroundColor: const Color(0xFF2E78F0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => context.go('/book/review'),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabelField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;

  const _LabelField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
