import 'package:alchemy/data/element_data.dart';
import 'package:alchemy/main.dart';
import 'package:alchemy/providers/alchemy_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AlchemyProvider> _createCleanProvider({
  Map<String, Object> initialPrefs = const {},
}) async {
  SharedPreferences.setMockInitialValues(initialPrefs);
  final provider = AlchemyProvider();
  await provider.loadSettings();
  return provider;
}

Future<void> _drainAchievementOverlay(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 800));
  await tester.pump(const Duration(milliseconds: 2500));
  await tester.pump(const Duration(milliseconds: 600));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Alchemy app starts cleanly with provider and default Lab state', (
    WidgetTester tester,
  ) async {
    final provider = await _createCleanProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<AlchemyProvider>.value(
        value: provider,
        child: const AlchemyApp(),
      ),
    );
    await tester.pump();

    expect(find.text('ALCHEMY'), findsOneWidget);
    expect(find.text('Laboratory'), findsOneWidget);
    expect(find.text('Fusion Chamber'), findsOneWidget);
    expect(find.text('Fire'), findsOneWidget);
    expect(find.text('Water'), findsOneWidget);
    expect(find.text('Earth'), findsOneWidget);
    expect(find.text('Air'), findsOneWidget);
  });

  testWidgets('AlchemyApp can also bootstrap its own provider when pumped directly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AlchemyApp());
    await tester.pump();

    expect(find.text('ALCHEMY'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('Main navigation switches across all four tabs', (
    WidgetTester tester,
  ) async {
    final provider = await _createCleanProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<AlchemyProvider>.value(
        value: provider,
        child: const AlchemyApp(),
      ),
    );
    await tester.pump();

    // 1. Lab tab (initial)
    expect(find.text('Fusion Chamber'), findsOneWidget);

    // 2. Collection tab
    await tester.tap(find.byIcon(Icons.grid_view_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('Element Collection'), findsOneWidget);
    expect(find.text('Discovery Progress'), findsOneWidget);

    // 3. Discover tab
    await tester.tap(find.byIcon(Icons.account_tree_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('Discovery Tree'), findsOneWidget);

    // 4. Profile tab
    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('Alchemist'), findsOneWidget);
    expect(find.text('Alchemy Level'), findsOneWidget);

    // Return to Lab tab
    await tester.tap(find.byIcon(Icons.science_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('Fusion Chamber'), findsOneWidget);
  });

  testWidgets(
    'First-time vs repeated vs invalid fusion outcomes update UI and XP accurately in English and Bengali',
    (WidgetTester tester) async {
      final provider = await _createCleanProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider<AlchemyProvider>.value(
          value: provider,
          child: const AlchemyApp(),
        ),
      );
      await tester.pump();

      expect(provider.xp, 0);
      expect(provider.discoveryCount, 4);

      // First-time fusion: Fire + Water -> Steam
      provider.addElement('fire');
      await tester.pump();
      expect(find.text('First element ready'), findsOneWidget);

      provider.addElement('water');
      final firstOutcome = provider.fuseElements();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1100));

      expect(firstOutcome.status, FusionStatus.newDiscovery);
      expect(firstOutcome.element, ElementData.steam);
      // 25 XP for common Steam + 25 XP for unlocking "First Discovery" (5 elements)
      expect(firstOutcome.xpGained, 50);
      expect(provider.xp, 50);
      expect(provider.discoveryCount, 5);
      expect(provider.achievementCount, 1);

      expect(find.text('Steam'), findsOneWidget);
      expect(find.text('NEW DISCOVERY'), findsOneWidget);
      expect(find.text('ALREADY DISCOVERED'), findsNothing);
      expect(find.text('+50 XP'), findsOneWidget);

      // Drain achievement unlock overlay timer
      await _drainAchievementOverlay(tester);
      expect(provider.pendingAchievement, isNull);

      // Repeated fusion of the same recipe: Fire + Water -> Steam (already discovered)
      provider.addElement('fire');
      provider.addElement('water');
      final repeatOutcome = provider.fuseElements();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1100));

      expect(repeatOutcome.status, FusionStatus.alreadyDiscovered);
      expect(repeatOutcome.element, ElementData.steam);
      expect(repeatOutcome.xpGained, 0);
      // XP, discoveries, and achievements must not increase on repeated fusion
      expect(provider.xp, 50);
      expect(provider.discoveryCount, 5);
      expect(provider.achievementCount, 1);
      expect(provider.pendingAchievement, isNull);

      expect(find.text('Steam'), findsOneWidget);
      expect(find.text('ALREADY DISCOVERED'), findsOneWidget);
      expect(find.text('NEW DISCOVERY'), findsNothing);

      // Switch to Bengali and verify localized already-discovered feedback
      await provider.setLanguage('bn');
      await tester.pump();
      expect(find.text('বাষ্প'), findsOneWidget);
      expect(find.text('পূর্বে আবিষ্কৃত'), findsOneWidget);
      expect(find.text('নতুন আবিষ্কার'), findsNothing);

      // Invalid combination in Bengali: Fire + Fire -> null
      provider.addElement('fire');
      provider.addElement('fire');
      final invalidOutcome = provider.fuseElements();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(invalidOutcome.status, FusionStatus.invalidCombination);
      expect(invalidOutcome.element, isNull);
      expect(provider.xp, 50);
      expect(find.text('কিছুই ঘটেনি'), findsOneWidget);
      expect(find.text('অন্য একটি সংমিশ্রণ চেষ্টা করুন'), findsOneWidget);
    },
  );

  testWidgets(
    'Discovery Map updates nodes and connection painter when a new element is discovered',
    (WidgetTester tester) async {
      final provider = await _createCleanProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider<AlchemyProvider>.value(
          value: provider,
          child: const AlchemyApp(),
        ),
      );
      await tester.pump();

      // Navigate to Discover tab
      await tester.tap(find.byIcon(Icons.account_tree_outlined));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      // Before discovering Steam: 4 elements discovered, Steam is locked ('???')
      expect(find.text('Steam'), findsNothing);
      expect(find.text('4'), findsOneWidget);

      final mapCustomPaintFinder = find.descendant(
        of: find.byType(InteractiveViewer),
        matching: find.byType(CustomPaint),
      );
      final painterBefore =
          tester.widget<CustomPaint>(mapCustomPaintFinder.first).painter!;

      // Discover Steam (Fire + Water)
      provider.addElement('fire');
      provider.addElement('water');
      final outcome = provider.fuseElements();
      expect(outcome.isNewDiscovery, isTrue);

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Steam node is now unlocked on the map and discovery count is 5
      expect(find.text('Steam'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);

      final painterAfter =
          tester.widget<CustomPaint>(mapCustomPaintFinder.first).painter!;

      // Regression check: connection painter must detect the new discovery
      expect(painterAfter.shouldRepaint(painterBefore), isTrue);
      expect(painterAfter.shouldRepaint(painterAfter), isFalse);

      // Drain achievement overlay triggered by 5th discovery
      await _drainAchievementOverlay(tester);
    },
  );

  test(
    'Level-up trigger resets cleanly and persistence failures do not crash gameplay',
    () async {
      final failingProvider = AlchemyProvider(
        prefsProvider: () => Future<SharedPreferences>.error(
          Exception('Storage unavailable'),
        ),
      );

      // Failed preference read falls back safely to defaults
      await failingProvider.loadSettings();
      expect(failingProvider.isLoaded, isTrue);
      expect(failingProvider.discoveryCount, 4);
      expect(failingProvider.xp, 0);

      // Awarding 100 XP reaches Level 2 and sets levelUpTriggered
      failingProvider.addXp(100);
      expect(failingProvider.level, 2);
      expect(failingProvider.levelUpTriggered, isTrue);

      // Subsequent non-leveling XP gain clears stale levelUpTriggered
      failingProvider.addXp(25);
      expect(failingProvider.level, 2);
      expect(failingProvider.levelUpTriggered, isFalse);

      // Language change works in memory even when persistence write fails
      await failingProvider.setLanguage('bn');
      expect(failingProvider.languageCode, 'bn');
    },
  );
}