import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_theme.dart';
import '../../core/providers.dart';
import '../common/widgets.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  List<Map<String, dynamic>> _threads = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final service = ref.read(chatServiceProvider);
      final result = await service.listThreads();
      if (mounted) setState(() { _threads = result; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Chats'), elevation: 0),
      body: _loading
          ? const Padding(padding: EdgeInsets.all(16), child: SkeletonList(items: 5, itemHeight: 60))
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ErrorBanner(_error!),
                      const SizedBox(height: 8),
                      ElevatedButton(onPressed: _load, child: const Text('Retry')),
                    ],
                  ),
                )
              : _threads.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 64, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(height: 12),
                          Text('No conversations yet', style: theme.textTheme.titleMedium),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.separated(
                        itemCount: _threads.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final t = _threads[i];
                          final peerId = t['peer_id'];
                          final lastMsg = t['last_message']?.toString() ?? '';
                          final unread = t['unread_count'] as int? ?? 0;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppTheme.primary.withValues(alpha: 0.15),
                              child: Text(
                                'U$peerId',
                                style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                            ),
                            title: Text('User #$peerId', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                            subtitle: Text(
                              lastMsg,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall,
                            ),
                            trailing: unread > 0
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primary,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text('$unread', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                                  )
                                : Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
                            onTap: () => context.push('/chat/$peerId'),
                          );
                        },
                      ),
                    ),
    );
  }
}

class ChatThreadScreen extends ConsumerStatefulWidget {
  const ChatThreadScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends ConsumerState<ChatThreadScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  bool _loading = true;
  bool _sending = false;
  String? _error;
  int? _myUserId;
  int? _bookingId;
  bool _hasBookingContext = false;

  int get _peerId => int.tryParse(widget.id) ?? 0;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      // Extract booking_id from route extra if navigating from booking context
      final extra = GoRouterState.of(context).extra;
      if (extra is Map<String, dynamic>) {
        _bookingId = extra['booking_id'] as int?;
        if (_bookingId != null) _hasBookingContext = true;
      }
      _loadProfile();
      _loadMessages();
    }
  }

  Future<void> _loadProfile() async {
    try {
      final profileService = ref.read(profileServiceProvider);
      final me = await profileService.getMe();
      if (mounted) setState(() => _myUserId = me['id'] as int?);
    } catch (_) {}
  }

  Future<void> _loadMessages() async {
    setState(() { _loading = true; _error = null; });
    try {
      final service = ref.read(chatServiceProvider);
      final result = await service.listMessages(_peerId);
      if (mounted) {
        // Detect booking context from messages if not already set
        if (!_hasBookingContext) {
          for (final m in result) {
            if (m['booking_id'] != null) {
              _hasBookingContext = true;
              _bookingId ??= m['booking_id'] as int?;
              break;
            }
          }
        }
        setState(() { _messages = result; _loading = false; });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() => _sending = true);
    try {
      final service = ref.read(chatServiceProvider);
      final msg = await service.sendMessage(receiverId: _peerId, content: text, bookingId: _bookingId);
      if (mounted) {
        setState(() {
          _messages.add(msg);
          _sending = false;
        });
        _msgCtrl.clear();
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with User #${widget.id}'),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadMessages),
        ],
      ),
      body: Column(
        children: [
          if (_hasBookingContext)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              color: Colors.amber.shade50,
              child: Row(
                children: [
                  Icon(Icons.visibility, size: 16, color: Colors.amber.shade800),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This conversation is linked to a booking and may be reviewed by admin for dispute resolution.',
                      style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ErrorBanner(_error!),
                            const SizedBox(height: 8),
                            ElevatedButton(onPressed: _loadMessages, child: const Text('Retry')),
                          ],
                        ),
                      )
                    : _messages.isEmpty
                        ? Center(child: Text('No messages yet. Say hello!', style: theme.textTheme.bodyMedium))
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(12),
                            itemCount: _messages.length,
                            itemBuilder: (context, i) {
                              final m = _messages[i];
                              final fromMe = m['sender_id'] == _myUserId;
                              return Align(
                                alignment: fromMe ? Alignment.centerRight : Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 3),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                                  decoration: BoxDecoration(
                                    color: fromMe ? AppTheme.primary.withValues(alpha: 0.1) : theme.colorScheme.surface,
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(14),
                                      topRight: const Radius.circular(14),
                                      bottomLeft: Radius.circular(fromMe ? 14 : 4),
                                      bottomRight: Radius.circular(fromMe ? 4 : 14),
                                    ),
                                    border: fromMe ? null : Border.all(color: theme.dividerColor),
                                  ),
                                  child: Text(
                                    m['content']?.toString() ?? '',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              );
                            },
                          ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(top: BorderSide(color: theme.dividerColor)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgCtrl,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerLow,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _sending
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                      : IconButton(
                          onPressed: _send,
                          icon: const Icon(Icons.send, color: AppTheme.primary),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
