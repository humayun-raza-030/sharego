import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TripEditScreen extends StatefulWidget {
  const TripEditScreen({super.key, required this.id, this.trip});
  final String id;
  final Map<String, dynamic>? trip;

  @override
  State<TripEditScreen> createState() => _TripEditScreenState();
}

class _TripEditScreenState extends State<TripEditScreen> {
  late final TextEditingController routeCtrl;
  late final TextEditingController timeCtrl;
  late final TextEditingController fromCtrl;
  late final TextEditingController toCtrl;
  late final TextEditingController capacityCtrl;
  late final TextEditingController rateCtrl;

  @override
  void initState() {
    super.initState();
    final trip = widget.trip ?? _findTrip(widget.id);
    routeCtrl = TextEditingController(text: trip['route']?.toString() ?? '');
    timeCtrl = TextEditingController(text: trip['time']?.toString() ?? '');
    fromCtrl =
        TextEditingController(text: trip['fromAirport']?.toString() ?? '');
    toCtrl = TextEditingController(text: trip['toAirport']?.toString() ?? '');
    capacityCtrl =
        TextEditingController(text: trip['capacity']?.toString() ?? '');
    rateCtrl = TextEditingController(text: trip['rate']?.toString() ?? '');
  }

  Map<String, dynamic> _findTrip(String id) {
    // Trip data should be passed via router extra; fallback to empty.
    return {'id': id};
  }

  @override
  void dispose() {
    routeCtrl.dispose();
    timeCtrl.dispose();
    fromCtrl.dispose();
    toCtrl.dispose();
    capacityCtrl.dispose();
    rateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit ${widget.id}'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _LabeledField(label: 'Route', controller: routeCtrl),
          const SizedBox(height: 12),
          _LabeledField(label: 'Date & Time', controller: timeCtrl),
          const SizedBox(height: 12),
          _LabeledField(
            label: 'From airport',
            controller: fromCtrl,
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          _LabeledField(
            label: 'To airport',
            controller: toCtrl,
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _LabeledField(label: 'Capacity', controller: capacityCtrl),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _LabeledField(label: 'Rate', controller: rateCtrl),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save changes',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _save() {
    final updated = {
      'id': widget.id,
      'route': routeCtrl.text,
      'time': timeCtrl.text,
      'fromAirport': fromCtrl.text,
      'toAirport': toCtrl.text,
      'capacity': capacityCtrl.text,
      'rate': rateCtrl.text,
    };
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trip details saved')),
    );
    context.pop(updated);
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
  });
  final String label;
  final TextEditingController controller;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
      ],
    );
  }
}
