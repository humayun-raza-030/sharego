import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/mock_data.dart';
import '../common/widgets.dart';

class AuditCenterScreen extends StatelessWidget {
  const AuditCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final issues = MockData.issues;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Audit & Issue Center'),
          bottom: const TabBar(tabs: [
            Tab(text: 'Open'),
            Tab(text: 'Pending'),
            Tab(text: 'Resolved'),
          ]),
          actions: [
            TextButton(
              onPressed: () => context.push('/audit/report/new'),
              child: const Text('Report', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
        body: TabBarView(
          children: List.generate(3, (i) {
            final filtered = issues.where((iss) {
              if (i == 0) return iss['status'] == 'Open';
              if (i == 1) return iss['status'] == 'Pending';
              return iss['status'] == 'Resolved';
            }).toList();
            return ListView(
              children: [
                ...filtered.map((e) => Card(
                      child: ListTile(
                        title: Text(e['title']?.toString() ?? ''),
                        subtitle: Text('${e['type']} • Ref ${e['ref']}'),
                        trailing: StatusPill(e['status']?.toString() ?? ''),
                        onTap: () => context.push('/audit/${e['id']}'),
                      ),
                    )),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class IssueDetailScreen extends StatelessWidget {
  const IssueDetailScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    final issue = MockData.issues
        .firstWhere((e) => e['id'] == id, orElse: () => MockData.issues.first);
    final timeline = issue['timeline'] as List;
    return Scaffold(
      appBar: AppBar(title: Text(issue['title']?.toString() ?? 'Issue')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusPill(issue['status']?.toString() ?? ''),
            const SizedBox(height: 8),
            Text('Type: ${issue['type']} • Reporter: ${issue['reportedBy']}'),
            Text('Reference: ${issue['ref']}'),
            const SizedBox(height: 12),
            const Text('Timeline'),
            ...timeline.map<Widget>((t) => ListTile(
                  leading: const Icon(Icons.bolt),
                  title: Text(t['title']?.toString() ?? ''),
                  trailing: Text(t['time']?.toString() ?? ''),
                )),
            const SizedBox(height: 12),
            Text('Notes: ${issue['notes']}'),
            const Spacer(),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () =>
                        context.push('/audit/${issue['id']}/add-evidence'),
                    child: const Text('Add Evidence')),
                const SizedBox(width: 8),
                OutlinedButton(
                    onPressed: () => context.push('/chat/CHAT-1'),
                    child: const Text('Contact Support')),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ReportIssueScreen extends StatelessWidget {
  const ReportIssueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report an Issue')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: 'Category'),
              items: const [
                DropdownMenuItem(
                    value: 'OTP', child: Text('Wrong OTP entered')),
                // GPS mismatch removed per requirements
                DropdownMenuItem(
                    value: 'Marketplace', child: Text('Marketplace issue')),
                DropdownMenuItem(
                    value: 'Abuse', child: Text('User harassment')),
              ],
              onChanged: (_) {},
            ),
            const SizedBox(height: 8),
            const TextField(
                maxLines: 4,
                decoration: InputDecoration(labelText: 'Description')),
            const SizedBox(height: 8),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E78F0),
                ),
                onPressed: () => context.go('/audit'),
                child: const Text('Submit')),
          ],
        ),
      ),
    );
  }
}

class AddEvidenceScreen extends StatelessWidget {
  const AddEvidenceScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Evidence')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: 'Note')),
            const SizedBox(height: 8),
            Container(
              height: 180,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: const Center(child: Text('Upload mock media')),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: () => context.go('/audit/$id'),
                child: const Text('Attach')),
          ],
        ),
      ),
    );
  }
}

class AdminAuditPanelScreen extends StatelessWidget {
  const AdminAuditPanelScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final issues = MockData.issues;
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Audit Panel')),
      body: ListView(
        children: issues
            .map((e) => Card(
                  child: ListTile(
                    title: Text(e['title']?.toString() ?? ''),
                    subtitle:
                        Text('Reporter: ${e['reportedBy']} • ${e['status']}'),
                    trailing: TextButton(
                        onPressed: () {}, child: const Text('Resolve')),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
