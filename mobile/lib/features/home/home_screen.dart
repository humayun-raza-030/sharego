import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _HomeDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'ai-chat-fab',
        onPressed: () => context.push('/ai'),
        icon: const Icon(Icons.chat_bubble_outline),
        label: const Text('Ask AI'),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => context.push('/profile'),
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF0E7C7B),
                child: const Icon(Icons.person, color: Colors.white),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.location_on,
                              color: Color(0xFF0E7C7B), size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Lahore, Pakistan',
                            style:
                                TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Welcome back',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Mr. Hassan',
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 54,
                    child: Image.asset(
                      'assets/sharego_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF84AEFD), Color(0xFFEDCB6F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Secure escrow for travelers',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Book, hand over with OTP, and let ShareGo hold funds until delivery.',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.shield_moon,
                        color: Colors.white, size: 40),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Quick actions',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                childAspectRatio: 1.15,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _ActionCard(
                    title: 'Book Services',
                    subtitle: 'Find travelers and place booking',
                    icon: Icons.calendar_month,
                    color: const Color(0xFF84AEFD),
                    onTap: () => context.push('/book/dates'),
                  ),
                  _ActionCard(
                    title: 'Travelling',
                    subtitle: 'List your trip & manage',
                    icon: Icons.flight_takeoff,
                    color: const Color(0xFF5A8DF5),
                    onTap: () => context.push('/trip/new/flight'),
                  ),
                  _ActionCard(
                    title: 'Marketplace',
                    subtitle: 'Peer-to-peer listings',
                    icon: Icons.store_mall_directory,
                    color: const Color(0xFF8ED1C4),
                    onTap: () => context.push('/market'),
                  ),
                  _ActionCard(
                    title: 'Audit Center',
                    subtitle: 'Report an issue',
                    icon: Icons.report_gmailerrorred,
                    color: const Color(0xFFFFB347),
                    onTap: () => context.push('/audit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.black87, size: 22),
            ),
            const Spacer(),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () => context.push('/profile'),
            ),
            ListTile(
              leading: const Icon(Icons.flight_takeoff_outlined),
              title: const Text('My Trips'),
              onTap: () => context.push('/trip/manage'),
            ),
            ListTile(
              leading: const Icon(Icons.book_online_outlined),
              title: const Text('My Booking'),
              onTap: () => context.push('/booking/BKG-12345/timeline'),
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Terms & Conditions'),
              onTap: () => context.push('/profile'),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              onTap: () => context.push('/profile'),
            ),
          ],
        ),
      ),
    );
  }
}
