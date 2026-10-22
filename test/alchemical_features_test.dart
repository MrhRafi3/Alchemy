import 'package:alchemy/data/element_data.dart';
import 'package:alchemy/data/recipe_data.dart';
import 'package:alchemy/main.dart';
import 'package:alchemy/providers/alchemy_provider.dart';
import 'package:alchemy/screens/element_details_screen.dart';
import 'package:alchemy/widgets/element_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AlchemyProvider> _createProvider() async {
  SharedPreferences.setMockInitialValues({});
  final provider = AlchemyProvider();
  await provider.loadSettings();
  return provider;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Alchemical Engine & Recipe Expansion Tests', () {
    test('Expanded recipes forge correctly from ingredients', () async {
      final provider = await _createProvider();

      // Lava + Air -> Stone
      provider.addElement('lava');
      provider.addElement('air');
      final stoneOutcome = provider.fuseElements();
      expect(stoneOutcome.isNewDiscovery, isTrue);
      expect(stoneOutcome.element, ElementData.stone);

      // Stone + Air -> Sand
      provider.addElement('stone');
      provider.addElement('air');
      final sandOutcome = provider.fuseElements();
      expect(sandOutcome.isNewDiscovery, isTrue);
      expect(sandOutcome.element, ElementData.sand);

      // Fire + Sand -> Glass
      provider.addElement('fire');
      provider.addElement('sand');
      final glassOutcome = provider.fuseElements();
      expect(glassOutcome.isNewDiscovery, isTrue);
      expect(glassOutcome.element, ElementData.glass);

      // Earth + Lava -> Volcano
      provider.addElement('earth');
      provider.addElement('lava');
      final volcanoOutcome = provider.fuseElements();
      expect(volcanoOutcome.isNewDiscovery, isTrue);
      expect(volcanoOutcome.element, ElementData.volcano);
    });

    test(
      'RecipeData.findIngredientsFor returns accurate recipe components',
      () {
        final steamIngredients = RecipeData.findIngredientsFor('steam');
        expect(steamIngredients, containsAll(['fire', 'water']));

        final lavaIngredients = RecipeData.findIngredientsFor('lava');
        expect(lavaIngredients, containsAll(['earth', 'fire']));

        final glassIngredients = RecipeData.findIngredientsFor('glass');
        expect(glassIngredients, containsAll(['fire', 'sand']));

        final primalIngredients = RecipeData.findIngredientsFor('fire');
        expect(primalIngredients, isNull);
      },
    );

    test(
      'Craftable undiscovered hint intelligently suggests available recipes',
      () async {
        final provider = await _createProvider();

        // With only starting elements (fire, water, earth, air), hints can suggest steam, lava, etc.
        final hint = provider.getCraftableUndiscoveredHint();
        expect(hint, isNotNull);
        expect([
          'steam',
          'lava',
          'energy',
          'plant',
          'cloud',
          'dust',
        ], contains(hint!.id));
      },
    );

    test('Fusion history records session attempts accurately', () async {
      final provider = await _createProvider();
      expect(provider.fusionHistory, isEmpty);

      provider.addElement('fire');
      provider.addElement('water');
      provider.fuseElements();

      expect(provider.fusionHistory.length, 1);
      expect(provider.fusionHistory.first.first.id, 'fire');
      expect(provider.fusionHistory.first.second.id, 'water');
      expect(provider.fusionHistory.first.result?.id, 'steam');
      expect(provider.fusionHistory.first.isNew, isTrue);

      // Attempt invalid combination
      provider.addElement('fire');
      provider.addElement('fire');
      provider.fuseElements();

      expect(provider.fusionHistory.length, 2);
      expect(provider.fusionHistory.first.result, isNull);
    });

    test('Reset progress cleanly restores the 4 primal elements', () async {
      final provider = await _createProvider();

      provider.addElement('fire');
      provider.addElement('water');
      provider.fuseElements(); // Discovers Steam, increases XP
      expect(provider.discoveryCount, 5);
      expect(provider.xp, greaterThan(0));

      await provider.resetProgress();

      expect(provider.discoveryCount, 4);
      expect(provider.xp, 0);
      expect(provider.unlockedAchievementIds, isEmpty);
      expect(
        provider.discoveredElementIds,
        containsAll(['fire', 'water', 'earth', 'air']),
      );
      expect(provider.firstElementId, isNull);
      expect(provider.secondElementId, isNull);
    });

    test('Haptic feedback preference toggles and persists', () async {
      final provider = await _createProvider();
      expect(provider.hapticsEnabled, isTrue);

      await provider.setHapticsEnabled(false);
      expect(provider.hapticsEnabled, isFalse);

      await provider.setHapticsEnabled(true);
      expect(provider.hapticsEnabled, isTrue);
    });
  });

  group('UI & Screen Interaction Tests', () {
    testWidgets('Tapping ElementCard triggers onTap callback', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElementCard(
              element: ElementData.fire,
              languageCode: 'en',
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Fire'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('Collection screen searches and filters elements by text', (
      tester,
    ) async {
      final provider = await _createProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider<AlchemyProvider>.value(
          value: provider,
          child: const AlchemyApp(),
        ),
      );
      await tester.pump();

      // Navigate to Collection tab
      await tester.tap(find.byIcon(Icons.grid_view_outlined));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      final gridFinder = find.byType(SliverGrid);
      expect(
        find.descendant(of: gridFinder, matching: find.text('Fire')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: gridFinder, matching: find.text('Water')),
        findsOneWidget,
      );

      // Enter search term 'Fire'
      await tester.enterText(find.byType(TextField), 'Fire');
      await tester.pump();

      expect(
        find.descendant(of: gridFinder, matching: find.text('Fire')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: gridFinder, matching: find.text('Water')),
        findsNothing,
      );

      // Clear search with non-existent element
      await tester.enterText(find.byType(TextField), 'NonExistentElement123');
      await tester.pump();

      expect(find.text('No elements found'), findsOneWidget);
    });

    testWidgets(
      'Element details screen renders lore, rarity, and Send to Lab button',
      (tester) async {
        final provider = await _createProvider();

        await tester.pumpWidget(
          ChangeNotifierProvider<AlchemyProvider>.value(
            value: provider,
            child: const MaterialApp(
              home: ElementDetailsScreen(
                element: ElementData.fire,
                languageCode: 'en',
              ),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('Fire'), findsOneWidget);
        expect(find.text('Common'), findsOneWidget);
        expect(find.text('About'), findsOneWidget);
        expect(
          find.text('Primal Element — existed since the dawn of creation.'),
          findsOneWidget,
        );

        // Scroll down to reveal the button
        final sendButton = find.text('Send to Lab Chamber');
        await tester.scrollUntilVisible(sendButton, 150);
        await tester.pumpAndSettle();

        expect(sendButton, findsOneWidget);

        // Tap Send to Lab Chamber
        await tester.tap(sendButton);
        await tester.pump();

        expect(provider.firstElementId, 'fire');
      },
    );

    testWidgets('Home screen hint dialog opens and closes cleanly', (
      tester,
    ) async {
      final provider = await _createProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider<AlchemyProvider>.value(
          value: provider,
          child: const AlchemyApp(),
        ),
      );
      await tester.pump();

      // Tap hint lightbulb icon
      await tester.tap(find.byIcon(Icons.lightbulb_outline_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Alchemical Whisper'), findsOneWidget);
      expect(find.text('Understood'), findsOneWidget);

      // Close hint
      await tester.tap(find.text('Understood'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Alchemical Whisper'), findsNothing);
    });
  });
}
