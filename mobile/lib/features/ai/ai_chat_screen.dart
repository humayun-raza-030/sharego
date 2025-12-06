import 'package:flutter/material.dart';

import '../../core/mock_data.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final List<Map<String, String>> messages = [
    {'from': 'AI', 'text': 'Hi! I can answer ShareGo questions.'},
  ];

  void _send(String text) {
    setState(() {
      messages.add({'from': 'You', 'text': text});
      final reply = MockData.aiResponses[text] ?? 'This is a demo answer using local mock data.';
      messages.add({'from': 'AI', 'text': reply});
    });
  }

  @override
  Widget build(BuildContext context) {
    final chips = MockData.aiResponses.keys.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('AI Chat Bot')),
      body: Column(
        children: [
          Wrap(
            spacing: 8,
            children: chips.map((c) => ActionChip(label: Text(c), onPressed: () => _send(c))).toList(),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final m = messages[i];
                final me = m['from'] == 'You';
                return Align(
                  alignment: me ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: me ? Colors.teal.shade50 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('${m['from']}: ${m['text']}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
