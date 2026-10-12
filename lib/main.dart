import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/alchemy_provider.dart';
import 'screens/collection_screen.dart';
import 'screens/discovery_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/achievement_unlock_overlay.dart';
import 'widgets/language_selector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final alchemyProvider = AlchemyProvider();
  await alchemyProvider.loadSettings();

  runApp(
    ChangeNotifierProvider<AlchemyProvider>.value(
      value: alchemyProvider,
      child: const AlchemyApp(),
    ),
  );
}

class AlchemyApp extends StatelessWidget {
  final AlchemyProvider? provider;

  const AlchemyApp({
    super.key,
    this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alchemy',
      theme: AppTheme.darkTheme,
      home: const MainNavigationScreen(),
    );

    if (provider != null) {
      return ChangeNotifierProvider<AlchemyProvider>.value(
        value: provider!,
        child: app,
      );
    }

    final existingProvider = Provider.of<AlchemyProvider?>(
      context,
      listen: false,
    );
    if (existingProvider != null) {
      return app;
    }

    return ChangeNotifierProvider<AlchemyProvider>(
      create: (_) => AlchemyProvider()..loadSettings(),
      child: app,
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CollectionScreen(),
    DiscoveryScreen(),
    ProfileScreen(),
  ];

  void _finishAchievementNotification(
      AlchemyProvider alchemy,
      ) {
    alchemy.consumePendingAchievement();
  }

  @override
  Widget build(BuildContext context) {
    final alchemy = context.watch<AlchemyProvider>();

    final titles = [
      alchemy.text(
        english: 'Lab',
        bangla: 'ল্যাব',
      ),
      alchemy.text(
        english: 'Collection',
        bangla: 'সংগ্রহ',
      ),
      alchemy.text(
        english: 'Discover',
        bangla: 'আবিষ্কার',
      ),
      alchemy.text(
        english: 'Profile',
        bangla: 'প্রোফাইল',
      ),
    ];

    final pendingAchievement =
        alchemy.pendingAchievement;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[_currentIndex],
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: LanguageSelector(),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: KeyedSubtree(
                key: ValueKey(_currentIndex),
                child: _screens[_currentIndex],
              ),
            ),
          ),
          if (pendingAchievement != null)
            AchievementUnlockOverlay(
              key: ValueKey(pendingAchievement.id),
              achievement: pendingAchievement,
              languageCode: alchemy.languageCode,
              onFinished: () {
                _finishAchievementNotification(alchemy);
              },
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.science_outlined),
            selectedIcon: const Icon(Icons.science),
            label: titles[0],
          ),
          NavigationDestination(
            icon: const Icon(Icons.grid_view_outlined),
            selectedIcon: const Icon(Icons.grid_view),
            label: titles[1],
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_tree_outlined),
            selectedIcon: const Icon(Icons.account_tree),
            label: titles[2],
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: titles[3],
          ),
        ],
      ),
    );
  }
}