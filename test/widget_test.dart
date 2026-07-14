import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aarogya_sathi/main_shell.dart';
import 'package:aarogya_sathi/app.dart';

/// Smoke test: every tab of the navigation shell renders without throwing.
void main() {
  group('Phase 0 — Shell smoke tests', () {
    testWidgets('App widget builds without error', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: ArogyaSathiApp()),
      );
      // Let go_router resolve initial route
      await tester.pumpAndSettle();
      // Home screen text should be visible
      expect(find.text('Quick Actions'), findsOneWidget);
    });

    testWidgets('Bottom nav has 5 destinations', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: ArogyaSathiApp()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(NavigationDestination), findsNWidgets(5));
    });
  });
}
