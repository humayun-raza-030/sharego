import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/mock_data.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = MockData.chats;
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, i) {
          final c = chats[i];
          return ListTile(
            title: Text(c['title']?.toString() ?? ''),
            subtitle: Text((c['messages'] as List).last['text']?.toString() ?? ''),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/chat/${c['id']}'),
          );
        },
      ),
    );
  }
}

class ChatThreadScreen extends StatefulWidget {
  const ChatThreadScreen({super.key, required this.id});
  final String id;

  @override
  State<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends State<ChatThreadScreen> {
  final msgCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chat = MockData.chats.firstWhere((c) => c['id'] == widget.id, orElse: () => MockData.chats.first);
    final messages = List<Map<String, dynamic>>.from(chat['messages'] as List);
    return Scaffold(
      appBar: AppBar(title: Text(chat['title']?.toString() ?? 'Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final m = messages[i];
                final fromMe = m['from'] == 'You';
                return Align(
                  alignment: fromMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: fromMe ? Colors.teal.shade50 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m['from'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(m['text'] ?? ''),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msgCtrl,
                    decoration: const InputDecoration(hintText: 'Type your message here'),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      messages.add({'from': 'You', 'text': msgCtrl.text, 'time': 'now'});
                      msgCtrl.clear();
                    });
                  },
                  icon: const Icon(Icons.send),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
