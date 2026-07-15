import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/transport_contact_model.dart';
import '../providers/transport_provider.dart';

/// Phase 5: Emergency Transport & Volunteers screen.
/// Shows ambulances, autos, drivers, and ASHA volunteers with one-tap calling.
class TransportScreen extends ConsumerStatefulWidget {
  const TransportScreen({super.key});

  @override
  ConsumerState<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends ConsumerState<TransportScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(transportProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transportProvider);
    final notifier = ref.read(transportProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Transport'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _OfflineBadge(),
          ),
        ],
      ),
      body: Column(
        children: [
          _FilterBar(
            activeFilter: state.activeFilter,
            onFilter: notifier.setFilter,
          ),
          if (state.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (state.error != null)
            Expanded(child: _ErrorView(message: state.error!, onRetry: notifier.load))
          else if (state.filtered.isEmpty)
            const Expanded(child: _EmptyView())
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                itemCount: state.filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _ContactCard(contact: state.filtered[index]);
                },
              ),
            ),
        ],
      ),
    );
  }
}

// ── Filter Bar ─────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  final String? activeFilter;
  final void Function(String?) onFilter;

  const _FilterBar({required this.activeFilter, required this.onFilter});

  static const _filters = [
    ('All', null, Icons.list_rounded),
    ('Ambulance', 'ambulance', Icons.emergency_rounded),
    ('Auto', 'auto', Icons.electric_rickshaw_rounded),
    ('Driver', 'driver', Icons.directions_car_rounded),
    ('Volunteer', 'volunteer', Icons.volunteer_activism_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: _filters.map((f) {
            final (label, value, icon) = f;
            final isSelected = activeFilter == value;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(label),
                avatar: Icon(icon, size: 16),
                selected: isSelected,
                onSelected: (_) => onFilter(isSelected ? null : value),
                selectedColor: AppColors.primary.withValues(alpha: 0.18),
                checkmarkColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : null,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ── Contact Card ───────────────────────────────────────────────────────────

class _ContactCard extends StatelessWidget {
  final TransportContact contact;
  const _ContactCard({required this.contact});

  Future<void> _call(BuildContext context) async {
    final uri = Uri(scheme: 'tel', path: contact.phone);
    if (!await launchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not call ${contact.phone}')),
        );
      }
    }
  }

  Color get _typeColor {
    return switch (contact.type) {
      'ambulance' => AppColors.severityCritical,
      'auto'      => AppColors.secondary,
      'driver'    => AppColors.primary,
      'volunteer' => AppColors.severityLow,
      _           => AppColors.primary,
    };
  }

  IconData get _typeIcon {
    return switch (contact.type) {
      'ambulance' => Icons.emergency_rounded,
      'auto'      => Icons.electric_rickshaw_rounded,
      'driver'    => Icons.directions_car_rounded,
      'volunteer' => Icons.volunteer_activism_rounded,
      _           => Icons.person_rounded,
    };
  }

  String get _typeLabel {
    return switch (contact.type) {
      'ambulance' => 'Ambulance',
      'auto'      => 'Auto',
      'driver'    => 'Driver',
      'volunteer' => 'Volunteer',
      _           => contact.type,
    };
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _typeColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_typeIcon, color: _typeColor, size: 26),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          contact.name,
                          style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      if (contact.is24x7)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.severityLow.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '24×7',
                            style: tt.labelSmall?.copyWith(
                              color: AppColors.severityLow,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _Pill(label: _typeLabel, color: _typeColor),
                      if (contact.vehicleType != null) ...[
                        const SizedBox(width: 6),
                        _Pill(label: contact.vehicleType!, color: AppColors.primary),
                      ],
                    ],
                  ),
                  if (contact.area != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: cs.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(contact.area!, style: tt.bodySmall),
                      ],
                    ),
                  ],
                  if (contact.notes != null && contact.notes!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      contact.notes!,
                      style: tt.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _call(context),
                      icon: const Icon(Icons.call_rounded, size: 18),
                      label: Text(contact.phone),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _typeColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pill chip ──────────────────────────────────────────────────────────────

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  const _Pill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Offline badge ──────────────────────────────────────────────────────────

class _OfflineBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.severityLow.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.offline_pin_rounded, size: 12, color: AppColors.severityLow),
          SizedBox(width: 4),
          Text('Offline', style: TextStyle(color: AppColors.severityLow, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

// ── Error view ─────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.severityCritical),
            const SizedBox(height: 12),
            Text('Error loading transport data', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty view ─────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.directions_car_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'No contacts found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'Try changing the filter above.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
