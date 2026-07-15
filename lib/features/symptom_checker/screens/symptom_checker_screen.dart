import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/triage_result_model.dart';
import '../../../services/ai/triage_engine.dart';
import '../../../services/ai/ai_service.dart';
import '../../../services/tts_stt/tts_stt_service.dart';
import '../providers/symptom_checker_provider.dart';

/// Phase 3: Rule-based offline Symptom Checker.
class SymptomCheckerScreen extends ConsumerStatefulWidget {
  const SymptomCheckerScreen({super.key});

  @override
  ConsumerState<SymptomCheckerScreen> createState() =>
      _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends ConsumerState<SymptomCheckerScreen> {
  bool _isListening = false;
  String _partialText = '';

  Future<void> _startVoiceInput() async {
    final tts = TtsSttService.instance;
    final ai = AiService.instance;

    setState(() {
      _isListening = true;
      _partialText = 'Listening...';
    });

    final text = await tts.listenOnce(
      onPartialResult: (partial) {
        setState(() => _partialText = partial);
      },
    );

    setState(() {
      _isListening = false;
      _partialText = '';
    });

    if (text != null && text.isNotEmpty) {
      // Process through NLP fallback
      final tags = await ai.extractSymptoms(text);
      if (tags.isNotEmpty) {
        ref.read(symptomCheckerProvider.notifier).addSymptoms(tags);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Identified ${tags.length} symptom(s) from voice!')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not understand any symptoms from voice.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(symptomCheckerProvider);
    final notifier = ref.read(symptomCheckerProvider.notifier);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('Symptom Checker'),
        actions: [
          if (state.selectedSymptoms.isNotEmpty)
            TextButton(
              onPressed: notifier.reset,
              child: const Text('Reset', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: state.result != null
          ? _TriageResultView(
              result: state.result!,
              onBack: () => notifier.toggleSymptom(''), // trigger state update to clear result
            )
          : Column(
              children: [
                _HeaderBanner(),
                if (_isListening)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: AppColors.primaryLight.withValues(alpha: 0.1),
                    child: Row(
                      children: [
                        const Icon(Icons.mic_rounded, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _partialText,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: Symptoms.groups.entries.map((entry) {
                      return _SymptomGroup(
                        title: entry.key,
                        tags: entry.value,
                        selectedTags: state.selectedSymptoms,
                        onToggle: notifier.toggleSymptom,
                      );
                    }).toList(),
                  ),
                ),
                _BottomAction(
                  selectedCount: state.selectedSymptoms.length,
                  isLoading: state.isLoading,
                  onCheck: notifier.runTriage,
                ),
              ],
            ),
      floatingActionButton: state.result == null
          ? FloatingActionButton(
              onPressed: _isListening ? null : _startVoiceInput,
              backgroundColor: _isListening ? Colors.grey : AppColors.primary,
              child: _isListening
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.mic_rounded, color: Colors.white),
            )
          : null,
    );
  }
}

class _HeaderBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primary.withValues(alpha: 0.05),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Select all the symptoms you are currently experiencing to get immediate triage advice. This works entirely offline.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SymptomGroup extends StatelessWidget {
  final String title;
  final List<String> tags;
  final List<String> selectedTags;
  final ValueChanged<String> onToggle;

  const _SymptomGroup({
    required this.title,
    required this.tags,
    required this.selectedTags,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              final isSelected = selectedTags.contains(tag);
              final label = Symptoms.labels[tag] ?? tag;
              return FilterChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (_) => onToggle(tag),
                selectedColor: AppColors.primary,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : cs.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 13,
                ),
                backgroundColor: cs.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : cs.outline.withValues(alpha: 0.2),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  final int selectedCount;
  final bool isLoading;
  final VoidCallback onCheck;

  const _BottomAction({
    required this.selectedCount,
    required this.isLoading,
    required this.onCheck,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: selectedCount > 0 && !isLoading ? onCheck : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    'Check Symptoms ($selectedCount)',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// â”€â”€ Triage Result View â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _TriageResultView extends ConsumerWidget {
  final TriageResult result;
  final VoidCallback onBack;

  const _TriageResultView({required this.result, required this.onBack});

  Color get _color {
    switch (result.severity) {
      case TriageSeverity.critical:
        return AppColors.severityCritical;
      case TriageSeverity.high:
        return AppColors.severityHigh;
      case TriageSeverity.moderate:
        return AppColors.severityModerate;
      case TriageSeverity.low:
        return AppColors.severityLow;
    }
  }

  IconData get _icon {
    switch (result.severity) {
      case TriageSeverity.critical:
        return Icons.emergency_rounded;
      case TriageSeverity.high:
        return Icons.warning_rounded;
      case TriageSeverity.moderate:
        return Icons.info_rounded;
      case TriageSeverity.low:
        return Icons.check_circle_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Severity Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(_icon, color: Colors.white, size: 48),
                const SizedBox(height: 12),
                Text(
                  '${result.severity.label} Priority',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  result.severity.action,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Action needed
          const Text(
            'Immediate Action',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _color.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.directions_run_rounded, color: _color, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    result.immediateAction,
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Reasoning
          const Text(
            'Why this recommendation?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            result.reasoning,
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.8),
              fontSize: 15,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          // Symptoms submitted
          Text(
            'Based on your symptoms:',
            style: TextStyle(
              fontSize: 14,
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: result.matchedSymptoms.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  Symptoms.labels[tag] ?? tag,
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // Related Actions
          if (result.relatedFirstAidTopicId != null) ...[
            OutlinedButton.icon(
              onPressed: () {
                // Navigate to First Aid screen, maybe select the specific topic in a future phase.
                context.go('/firstAid');
              },
              icon: const Icon(Icons.medical_services_rounded),
              label: Text('View First Aid: ${result.relatedFirstAidCondition}'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (result.severity == TriageSeverity.critical ||
              result.severity == TriageSeverity.high)
            ElevatedButton.icon(
              onPressed: () {
                context.go('/hospitals');
              },
              icon: const Icon(Icons.local_hospital_rounded),
              label: const Text('Find Nearest Hospital'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.severityCritical,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

          const SizedBox(height: 24),
          Center(
            child: TextButton(
              onPressed: () {
                ref.read(symptomCheckerProvider.notifier).reset();
              },
              child: const Text('Start Over'),
            ),
          ),
        ],
      ),
    );
  }
}
