import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TripFlightScreen extends StatefulWidget {
  const TripFlightScreen({super.key});

  @override
  State<TripFlightScreen> createState() => _TripFlightScreenState();
}

class _TripFlightScreenState extends State<TripFlightScreen> {
  final _countries = const ['Pakistan', 'UAE', 'Saudi Arabia'];
  final _airlines = const ['Saudia', 'PIA', 'Emirates'];
  final _airportsFrom = const ['LHE', 'KHI', 'ISB'];
  final _airportsTo = const ['RUH', 'DXB', 'JED'];

  String _country = 'Pakistan';
  String _airline = 'Saudia';
  String _fromCode = 'LHE';
  String _toCode = 'RUH';
  DateTime _flightDate = DateTime.now();

  final _ticketCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateLabel = DateFormat('EEE, dd MMM yyyy').format(_flightDate);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.white,
        title: const Text('Trip setup'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionCard(
              title: 'Route & airline',
              children: [
                _FieldLabel('Country'),
                Row(
                  children: [
                    Expanded(
                      child: _Drop(
                        value: _country,
                        items: _countries,
                        onChanged: (v) =>
                            setState(() => _country = v ?? _country),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _Drop(
                        value: _airline,
                        items: _airlines,
                        onChanged: (v) =>
                            setState(() => _airline = v ?? _airline),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _FieldLabel('Airports'),
                Row(
                  children: [
                    Expanded(
                      child: _Drop(
                        value: _fromCode,
                        items: _airportsFrom,
                        onChanged: (v) =>
                            setState(() => _fromCode = v ?? _fromCode),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.arrow_forward, color: Colors.black54),
                    ),
                    Expanded(
                      child: _Drop(
                        value: _toCode,
                        items: _airportsTo,
                        onChanged: (v) =>
                            setState(() => _toCode = v ?? _toCode),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Flight information',
              children: [
                _FieldLabel('E-ticket URL'),
                TextField(
                  controller: _ticketCtrl,
                  decoration: _input('https://airline.com/ticket'),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 14),
                _FieldLabel('Date of flight'),
                Card(
                  color: const Color(0xFFF7F8FC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Color(0xFFE0E2EB)),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    title: Text(
                      dateLabel,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    subtitle: const Text('Select a date within next 12 months'),
                    trailing: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 140),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(120, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          final now = DateTime.now();
                          final picked = await showDatePicker(
                            context: context,
                            initialDate:
                                _flightDate.isBefore(now) ? now : _flightDate,
                            firstDate: now,
                            lastDate: now.add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setState(() => _flightDate = picked);
                          }
                        },
                        child: const Text('Select'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => context.push('/trip/new/capacity'),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _input(String hint) => InputDecoration(
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
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
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
          Center(
            child: Text(
              title,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87),
      ),
    );
  }
}

class _Drop extends StatelessWidget {
  const _Drop({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E2EB)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
