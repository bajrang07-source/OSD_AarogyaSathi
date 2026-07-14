import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/first_aid_topic_model.dart';
import '../providers/first_aid_provider.dart';

/// Phase 2: Fully offline, DB-backed First Aid screen with:
/// - Real-time search (client-side, no network)
/// - Detail view with step-by-step instructions
/// - Favourites (stored locally in SQLite)
class FirstAidScreen extends ConsumerStatefulWidget {
  const FirstAidScreen({super.key});

  @override
  ConsumerState<FirstAidScreen> createState() => _FirstAidScreenState();
}

class _FirstAidScreenState extends ConsumerState<FirstAidScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Load topics from DB on mount
    Future.microtask(() => ref.read(firstAidProvider.notifier).loadTopics());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(firstAidProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('First Aid Guide'),
        backgroundColor: AppColors.severityCritical,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: [
            const Tab(text: 'All Topics'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.favorite_rounded, size: 16),
                  const SizedBox(width: 6),
                  Text(
                      'Saved (${state.favourites.length})'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Search bar ───────────────────────────────────────────────────
          _SearchBar(
            controller: _searchController,
            onChanged: (q) =>
                ref.read(firstAidProvider.notifier).setQuery(q),
          ),

          // ── Tab views ────────────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _TopicList(
                  topics: state.topics,
                  isLoading: state.isLoading,
                  query: state.query,
                  favouriteIds:
                      state.favourites.map((f) => f.id ?? 0).toSet(),
                  onFavourite: (id) =>
                      ref.read(firstAidProvider.notifier).toggleFavourite(id),
                ),
                _TopicList(
                  topics: state.favourites,
                  isLoading: false,
                  query: '',
                  emptyMessage: 'No saved topics yet.\nTap ♥ on any topic to save it.',
                  favouriteIds:
                      state.favourites.map((f) => f.id ?? 0).toSet(),
                  onFavourite: (id) =>
                      ref.read(firstAidProvider.notifier).toggleFavourite(id),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.severityCritical,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: 'Search conditions (e.g., snake bite)…',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          prefixIcon:
              const Icon(Icons.search_rounded, color: Colors.white70),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon:
                      const Icon(Icons.close_rounded, color: Colors.white70),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white.withOpacity(0.15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
          ),
        ),
      ),
    );
  }
}

// ── Topic list ────────────────────────────────────────────────────────────────

class _TopicList extends StatelessWidget {
  final List<FirstAidTopic> topics;
  final bool isLoading;
  final String query;
  final String emptyMessage;
  final Set<int> favouriteIds;
  final ValueChanged<int> onFavourite;

  const _TopicList({
    required this.topics,
    required this.isLoading,
    required this.query,
    this.emptyMessage = 'No results found. Try a different keyword.',
    required this.favouriteIds,
    required this.onFavourite,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.severityCritical),
      );
    }

    if (topics.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded,
                size: 48, color: cs.onSurface.withOpacity(0.3)),
            const SizedBox(height: 12),
            Text(
              emptyMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: cs.onSurface.withOpacity(0.5), height: 1.5),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: topics.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final topic = topics[index];
        return _TopicCard(
          topic: topic,
          isFavourite: favouriteIds.contains(topic.id ?? 0),
          onFavourite: () => onFavourite(topic.id ?? 0),
          onTap: () => _openDetail(context, topic,
              favouriteIds.contains(topic.id ?? 0), onFavourite),
        );
      },
    );
  }

  void _openDetail(BuildContext context, FirstAidTopic topic,
      bool isFavourite, ValueChanged<int> onFav) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FirstAidDetailScreen(
          topic: topic,
          isFavourite: isFavourite,
          onToggleFavourite: () => onFav(topic.id ?? 0),
        ),
      ),
    );
  }
}

// ── Topic card ────────────────────────────────────────────────────────────────

class _TopicCard extends StatelessWidget {
  final FirstAidTopic topic;
  final bool isFavourite;
  final VoidCallback onFavourite;
  final VoidCallback onTap;

  const _TopicCard({
    required this.topic,
    required this.isFavourite,
    required this.onFavourite,
    required this.onTap,
  });

  Color get _severityColor {
    switch (topic.severity) {
      case 'Critical':
        return AppColors.severityCritical;
      case 'High':
        return AppColors.severityHigh;
      case 'Moderate':
        return AppColors.severityModerate;
      default:
        return AppColors.severityLow;
    }
  }

  IconData get _severityIcon {
    switch (topic.severity) {
      case 'Critical':
        return Icons.emergency_rounded;
      case 'High':
        return Icons.warning_rounded;
      case 'Moderate':
        return Icons.info_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = _severityColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outline.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_severityIcon, color: color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            topic.condition,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        _SeverityBadge(
                            label: topic.severity, color: color),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${topic.steps.length} steps  •  ${topic.warnings.length} warnings',
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withOpacity(0.55),
                      ),
                    ),
                    if (topic.searchKeywords != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        topic.searchKeywords!
                            .split(' ')
                            .take(4)
                            .map((k) => '#$k')
                            .join('  '),
                        style: TextStyle(
                          fontSize: 11,
                          color: cs.onSurface.withOpacity(0.38),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(
                  isFavourite
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                  color: isFavourite
                      ? AppColors.severityCritical
                      : cs.onSurface.withOpacity(0.3),
                  size: 22,
                ),
                onPressed: onFavourite,
                tooltip: isFavourite ? 'Remove favourite' : 'Save',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Detail screen ─────────────────────────────────────────────────────────────

class FirstAidDetailScreen extends StatefulWidget {
  final FirstAidTopic topic;
  final bool isFavourite;
  final VoidCallback onToggleFavourite;

  const FirstAidDetailScreen({
    super.key,
    required this.topic,
    required this.isFavourite,
    required this.onToggleFavourite,
  });

  @override
  State<FirstAidDetailScreen> createState() => _FirstAidDetailScreenState();
}

class _FirstAidDetailScreenState extends State<FirstAidDetailScreen> {
  late bool _isFav;

  @override
  void initState() {
    super.initState();
    _isFav = widget.isFavourite;
  }

  Color get _severityColor {
    switch (widget.topic.severity) {
      case 'Critical':
        return AppColors.severityCritical;
      case 'High':
        return AppColors.severityHigh;
      case 'Moderate':
        return AppColors.severityModerate;
      default:
        return AppColors.severityLow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topic = widget.topic;
    final color = _severityColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(topic.condition),
        backgroundColor: color,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              _isFav
                  ? Icons.favorite_rounded
                  : Icons.favorite_outline_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() => _isFav = !_isFav);
              widget.onToggleFavourite();
            },
            tooltip: _isFav ? 'Remove favourite' : 'Save',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Severity badge ──────────────────────────────────────────
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${topic.severity} Priority',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${topic.steps.length} steps',
                  style: TextStyle(
                    color: cs.onSurface.withOpacity(0.5),
                    fontSize: 13,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Disclaimer ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.severityModerate.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.severityModerate.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppColors.severityModerate, size: 18),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'This is first-aid guidance only — not a medical diagnosis. Always consult a doctor.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.severityModerate,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Steps ───────────────────────────────────────────────────
            _SectionHeader(
              icon: Icons.format_list_numbered_rounded,
              title: 'Step-by-Step Instructions',
              color: color,
            ),
            const SizedBox(height: 12),
            ...topic.steps.asMap().entries.map((e) {
              return _StepCard(
                  number: e.key + 1, step: e.value, color: color);
            }),

            if (topic.warnings.isNotEmpty) ...[
              const SizedBox(height: 24),

              // ── Warnings ───────────────────────────────────────────────
              _SectionHeader(
                icon: Icons.warning_amber_rounded,
                title: 'Important Warnings',
                color: AppColors.severityHigh,
              ),
              const SizedBox(height: 12),
              ...topic.warnings.map((w) => _WarningCard(warning: w)),
            ],

            const SizedBox(height: 24),

            // ── Emergency reminder ───────────────────────────────────────
            if (topic.severity == 'Critical' ||
                topic.severity == 'High')
              _EmergencyCallCard(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionHeader(
      {required this.icon, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  final int number;
  final String step;
  final Color color;

  const _StepCard(
      {required this.number, required this.step, required this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              step,
              style: TextStyle(
                fontSize: 14,
                color: cs.onSurface.withOpacity(0.85),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  final String warning;

  const _WarningCard({required this.warning});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.severityHigh.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: AppColors.severityHigh.withOpacity(0.3)),
      ),
      child: Text(
        warning,
        style: TextStyle(
          fontSize: 13,
          color: AppColors.severityHigh,
          height: 1.5,
        ),
      ),
    );
  }
}

class _EmergencyCallCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.severityCritical,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.severityCritical.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.emergency_rounded, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          const Text(
            'Seek Emergency Help',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'This condition may be life-threatening.\nCall 108 (ambulance) or 112 (emergency).',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse('tel:108');
                    if (await canLaunchUrl(uri)) launchUrl(uri);
                  },
                  icon: const Icon(Icons.phone_rounded,
                      color: Colors.white, size: 18),
                  label: const Text('Call 108',
                      style: TextStyle(color: Colors.white)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse('tel:112');
                    if (await canLaunchUrl(uri)) launchUrl(uri);
                  },
                  icon: const Icon(Icons.sos_rounded,
                      color: Colors.white, size: 18),
                  label: const Text('Call 112',
                      style: TextStyle(color: Colors.white)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Severity badge ────────────────────────────────────────────────────────────

class _SeverityBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _SeverityBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
