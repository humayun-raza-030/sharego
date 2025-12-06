import 'package:flutter/material.dart';

import '../../core/app_theme.dart';

class CtaCard extends StatelessWidget {
  const CtaCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const Spacer(),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.title, this.subtitle, this.onTap});
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white)),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(subtitle!,
                    style: const TextStyle(color: Colors.white70)),
              )
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action, this.onAction});
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        if (action != null)
          TextButton(onPressed: onAction, child: Text(action!)),
      ],
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill(this.text, {super.key, this.tone, this.icon});
  final String text;
  final StatusTone? tone;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    final lower = text.toLowerCase();
    Color resolved = AppTheme.teal.withValues(alpha: 0.12);
    Color border = AppTheme.teal.withValues(alpha: 0.5);
    Color label = AppTheme.textPrimary;
    switch (tone ?? _inferTone(lower)) {
      case StatusTone.success:
        resolved = AppTheme.success.withValues(alpha: 0.12);
        border = AppTheme.success.withValues(alpha: 0.6);
        label = AppTheme.success;
        break;
      case StatusTone.warning:
        resolved = AppTheme.amber.withValues(alpha: 0.18);
        border = AppTheme.amber.withValues(alpha: 0.8);
        label = AppTheme.textPrimary;
        break;
      case StatusTone.danger:
        resolved = AppTheme.danger.withValues(alpha: 0.12);
        border = AppTheme.danger.withValues(alpha: 0.6);
        label = AppTheme.danger;
        break;
      case StatusTone.info:
        resolved = AppTheme.teal.withValues(alpha: 0.12);
        border = AppTheme.teal.withValues(alpha: 0.5);
        label = AppTheme.teal;
        break;
      case StatusTone.neutral:
        resolved = Colors.grey.shade100;
        border = Colors.grey.shade300;
        label = AppTheme.textPrimary;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: resolved,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: label),
            const SizedBox(width: 4),
          ],
          Text(text,
              style: TextStyle(fontWeight: FontWeight.w700, color: label)),
        ],
      ),
    );
  }

  StatusTone _inferTone(String lower) {
    if (lower.contains('closed') ||
        lower.contains('delivered') ||
        lower.contains('accepted')) {
      return StatusTone.success;
    }
    if (lower.contains('hold') ||
        lower.contains('pending') ||
        lower.contains('picked')) {
      return StatusTone.info;
    }
    if (lower.contains('refunded') ||
        lower.contains('cancel') ||
        lower.contains('decline') ||
        lower.contains('flag')) {
      return StatusTone.danger;
    }
    return StatusTone.neutral;
  }
}

enum StatusTone { success, warning, danger, info, neutral }

class DisclaimerBanner extends StatelessWidget {
  const DisclaimerBanner({
    super.key,
    this.text =
        'Marketplace transactions are peer-to-peer. ShareGo does not provide delivery, courier, or payment services. Verify the other party and follow local laws.',
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.amber.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.amber.withValues(alpha: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppTheme.textPrimary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key, this.onRetry});
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: EdgeInsets.only(
        left: 16,
        right: 8,
        top: 8,
        bottom: 8 + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off, color: Colors.white),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Offline mode: some actions are queued until you reconnect.',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(foregroundColor: AppTheme.amber),
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }
}

class SkeletonBox extends StatefulWidget {
  const SkeletonBox(
      {super.key,
      this.height = 16,
      this.width = double.infinity,
      this.radius = 8});
  final double height;
  final double width;
  final double radius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1200))
    ..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = 0.6 + (_controller.value * 0.3);
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: t),
            borderRadius: BorderRadius.circular(widget.radius),
          ),
        );
      },
    );
  }
}

class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.items = 3, this.itemHeight = 72});
  final int items;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        items,
        (_) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SkeletonBox(height: itemHeight, radius: 12),
        ),
      ),
    );
  }
}
