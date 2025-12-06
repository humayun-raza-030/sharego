import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/mock_data.dart';
import '../common/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockData.user;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 30, child: Icon(Icons.person)),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(user['name']?.toString() ?? ''),
                  Text('Rating ${user['rating']}'),
                  StatusPill('KYC ${user['kycStatus']}'),
                ]),
              ],
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              onTap: () => context.push('/profile/edit'),
            ),
            ListTile(
              leading: const Icon(Icons.verified_user),
              title: const Text('KYC Status'),
              onTap: () => context.push('/profile/kyc'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => context.push('/profile/settings'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => context.push('/profile/logout'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: 'Name')),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(labelText: 'Phone')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => context.pop(), child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}

class KycScreen extends StatelessWidget {
  const KycScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KYC Upload')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StatusPill('Pending'),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  Container(height: 150, color: Colors.grey.shade200, child: const Center(child: Text('CNIC / Passport Upload'))),
                  const SizedBox(height: 12),
                  Container(height: 150, color: Colors.grey.shade200, child: const Center(child: Text('Selfie Upload'))),
                ],
              ),
            ),
            ElevatedButton(onPressed: () => context.pop(), child: const Text('Submit')),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(value: true, onChanged: (_) {}, title: const Text('Notifications')),
          ListTile(
            title: const Text('Language'),
            subtitle: const Text('English / Urdu'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Theme'),
            subtitle: const Text('Light'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logout')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Are you sure you want to logout?'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () => context.go('/auth/login'), child: const Text('Yes, logout')),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: () => context.pop(), child: const Text('Cancel')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
