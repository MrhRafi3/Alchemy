import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/achievement_data.dart';
import '../data/element_data.dart';
import '../data/recipe_data.dart';
import '../models/achievement_model.dart';
import '../models/element_model.dart';

/// Represents all supported outcomes when attempting to fuse elements.
enum FusionStatus {
  /// Fewer than two elements were selected when fusion was attempted.
  incomplete,

  /// A valid recipe produced an element that had not been discovered before.
  newDiscovery,

  /// A valid recipe produced an element that was already in the collection.
  alreadyDiscovered,

  /// Two elements were combined, but no recipe exists for the pair.
  invalidCombination,
}

/// Immutable value object describing the outcome of a fusion attempt.
class FusionResult {
  final FusionStatus status;
  final ElementModel? element;
  final int xpGained;
  final List<AchievementModel> unlockedAchievements;
  final bool leveledUp;

  const FusionResult({
    required this.status,
    this.element,
    this.xpGained = 0,
    this.unlockedAchievements = const [],
    this.leveledUp = false,
  });

  bool get isSuccess =>
      status == FusionStatus.newDiscovery ||
      status == FusionStatus.alreadyDiscovered;

  bool get isNewDiscovery => status == FusionStatus.newDiscovery;

  bool get isAlreadyDiscovered =>
      status == FusionStatus.alreadyDiscovered;

  bool get isInvalid => status == FusionStatus.invalidCombination;

  bool get isIncomplete => status == FusionStatus.incomplete;
}

class AlchemyProvider extends ChangeNotifier {
  static const String _languageKey = 'languageCode';
  static const String _xpKey = 'xp';
  static const String _discoveredElementsKey = 'discoveredElements';
  static const String _unlockedAchievementsKey =
      'unlockedAchievements';

  static const Set<String> _startingElementIds = {
    'fire',
    'water',
    'earth',
    'air',
  };

  final Future<SharedPreferences> Function()? prefsProvider;

  AlchemyProvider({
    this.prefsProvider,
  });

  String _languageCode = 'en';

  String? _firstElementId;
  String? _secondElementId;

  final Set<String> _discoveredElementIds = {
    ..._startingElementIds,
  };
  late Set<String> _discoveredElementIdsView =
      Set<String>.unmodifiable(_discoveredElementIds);

  final Set<String> _unlockedAchievementIds = {};
  late Set<String> _unlockedAchievementIdsView =
      Set<String>.unmodifiable(_unlockedAchievementIds);

  final List<AchievementModel> _pendingAchievements = [];

  int _xp = 0;
  bool _levelUpTriggered = false;
  FusionResult? _lastFusionResult;

  bool _isLoaded = false;
  bool _languageMutatedBeforeLoad = false;
  bool _progressMutatedBeforeLoad = false;
  Future<void>? _loadFuture;
  Future<void> _pendingWrite = Future<void>.value();

  String get languageCode => _languageCode;

  String? get firstElementId => _firstElementId;
  String? get secondElementId => _secondElementId;

  /// Immutable snapshot of discovered element IDs so widgets and custom
  /// painters can reliably compare previous and current discovery state.
  Set<String> get discoveredElementIds => _discoveredElementIdsView;

  /// Immutable snapshot of unlocked achievement IDs.
  Set<String> get unlockedAchievementIds =>
      _unlockedAchievementIdsView;

  int get xp => _xp;

  int get discoveryCount => _discoveredElementIds.length;

  int get achievementCount => _unlockedAchievementIds.length;

  bool get levelUpTriggered => _levelUpTriggered;

  FusionResult? get lastFusionResult => _lastFusionResult;

  bool get isLoaded => _isLoaded;

  AchievementModel? get pendingAchievement {
    if (_pendingAchievements.isEmpty) {
      return null;
    }

    return _pendingAchievements.first;
  }

  int get level {
    var currentLevel = 1;
    var requiredXp = 100;

    while (_xp >= requiredXp) {
      currentLevel++;
      requiredXp += currentLevel * 100;
    }

    return currentLevel;
  }

  int get currentLevelXp {
    var xpBeforeLevel = 0;

    for (int i = 1; i < level; i++) {
      xpBeforeLevel += i * 100;
    }

    return (_xp - xpBeforeLevel).clamp(0, xpForNextLevel);
  }

  int get xpForNextLevel => level * 100;

  double get levelProgress {
    if (xpForNextLevel == 0) {
      return 0;
    }

    return (currentLevelXp / xpForNextLevel).clamp(0.0, 1.0);
  }

  void _refreshDiscoveredSnapshot() {
    _discoveredElementIdsView =
        Set<String>.unmodifiable(_discoveredElementIds);
  }

  void _refreshAchievementsSnapshot() {
    _unlockedAchievementIdsView =
        Set<String>.unmodifiable(_unlockedAchievementIds);
  }

  Future<SharedPreferences> _getPrefs() {
    final provider = prefsProvider;
    if (provider != null) {
      return provider();
    }
    return SharedPreferences.getInstance();
  }

  /// Serializes persistence writes to prevent interleaving or out-of-order
  /// updates and catches storage errors so gameplay remains usable.
  Future<void> _enqueueWrite(
    Future<void> Function(SharedPreferences prefs) action,
  ) {
    _pendingWrite = _pendingWrite.then((_) async {
      try {
        final prefs = await _getPrefs();
        await action(prefs);
      } catch (error) {
        debugPrint(
          'AlchemyProvider persistence write failed: $error',
        );
      }
    });
    return _pendingWrite;
  }

  Future<void> loadSettings() {
    return _loadFuture ??= _performLoadSettings();
  }

  Future<void> _performLoadSettings() async {
    try {
      final prefs = await _getPrefs();

      if (!_languageMutatedBeforeLoad) {
        final savedLanguage = prefs.getString(_languageKey);
        if (savedLanguage == 'en' || savedLanguage == 'bn') {
          _languageCode = savedLanguage!;
        } else {
          _languageCode = 'en';
        }
      } else {
        await _enqueueWrite((p) async {
          await p.setString(_languageKey, _languageCode);
        });
      }

      final rawSavedXp = prefs.getInt(_xpKey) ?? 0;
      final savedXp = rawSavedXp < 0 ? 0 : rawSavedXp;

      final savedElements = prefs.getStringList(
        _discoveredElementsKey,
      );
      final validSavedElements = <String>{
        ..._startingElementIds,
        if (savedElements != null)
          ...savedElements.where(
            (id) => ElementData.findById(id) != null,
          ),
      };

      final savedAchievements = prefs.getStringList(
        _unlockedAchievementsKey,
      );
      final validSavedAchievements = <String>{
        if (savedAchievements != null)
          ...savedAchievements.where(
            (id) => AchievementData.all.any((a) => a.id == id),
          ),
      };

      if (!_progressMutatedBeforeLoad) {
        _xp = savedXp;
        _discoveredElementIds
          ..clear()
          ..addAll(validSavedElements);
        _unlockedAchievementIds
          ..clear()
          ..addAll(validSavedAchievements);

        // Synchronize unlocked achievement records with restored discoveries
        // without queuing duplicate unlock notifications or re-awarding XP.
        for (final achievement in AchievementData.all) {
          if (_discoveredElementIds.length >=
              achievement.requiredDiscoveries) {
            _unlockedAchievementIds.add(achievement.id);
          }
        }

        _refreshDiscoveredSnapshot();
        _refreshAchievementsSnapshot();
      } else {
        // Merge in-memory progress made before async load completed.
        _discoveredElementIds.addAll(validSavedElements);
        _unlockedAchievementIds.addAll(validSavedAchievements);
        _xp += savedXp;

        for (final achievement in AchievementData.all) {
          if (_discoveredElementIds.length >=
              achievement.requiredDiscoveries) {
            _unlockedAchievementIds.add(achievement.id);
          }
        }

        _refreshDiscoveredSnapshot();
        _refreshAchievementsSnapshot();
        await _saveProgress();
      }
    } catch (error) {
      debugPrint('AlchemyProvider loadSettings failed: $error');
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }

  Future<void> setLanguage(String languageCode) async {
    if (languageCode != 'en' && languageCode != 'bn') {
      return;
    }

    if (!_isLoaded) {
      _languageMutatedBeforeLoad = true;
    }

    if (_languageCode != languageCode) {
      _languageCode = languageCode;
      notifyListeners();
    }

    await _enqueueWrite((prefs) async {
      await prefs.setString(
        _languageKey,
        _languageCode,
      );
    });
  }

  void addElement(String elementId) {
    if (ElementData.findById(elementId) == null) {
      return;
    }

    _levelUpTriggered = false;

    if (_firstElementId == null) {
      _firstElementId = elementId;
      _lastFusionResult = null;
    } else if (_secondElementId == null) {
      _secondElementId = elementId;
    } else {
      _firstElementId = elementId;
      _secondElementId = null;
      _lastFusionResult = null;
    }

    notifyListeners();
  }

  void addXp(int amount) {
    if (amount <= 0) {
      return;
    }

    if (!_isLoaded) {
      _progressMutatedBeforeLoad = true;
    }

    final previousLevel = level;
    _xp += amount;
    _levelUpTriggered = level > previousLevel;

    _saveProgress();
    notifyListeners();
  }

  void clearLevelUpTrigger() {
    if (!_levelUpTriggered) {
      return;
    }

    _levelUpTriggered = false;
    notifyListeners();
  }

  /// Reads and clears the transient level-up flag so callers can react once
  /// without leaving a stale flag set across later interactions.
  bool consumeLevelUpTrigger() {
    if (!_levelUpTriggered) {
      return false;
    }

    _levelUpTriggered = false;
    notifyListeners();
    return true;
  }

  FusionResult fuseElements() {
    if (_firstElementId == null || _secondElementId == null) {
      const incompleteResult = FusionResult(
        status: FusionStatus.incomplete,
      );
      _lastFusionResult = incompleteResult;
      return incompleteResult;
    }

    final firstId = _firstElementId!;
    final secondId = _secondElementId!;

    _firstElementId = null;
    _secondElementId = null;
    _levelUpTriggered = false;

    final result = RecipeData.findResult(
      firstId,
      secondId,
    );

    if (result == null) {
      const invalidResult = FusionResult(
        status: FusionStatus.invalidCombination,
      );
      _lastFusionResult = invalidResult;
      notifyListeners();
      return invalidResult;
    }

    final isNewDiscovery = _discoveredElementIds.add(result.id);

    if (!isNewDiscovery) {
      final repeatResult = FusionResult(
        status: FusionStatus.alreadyDiscovered,
        element: result,
        xpGained: 0,
      );
      _lastFusionResult = repeatResult;
      notifyListeners();
      return repeatResult;
    }

    if (!_isLoaded) {
      _progressMutatedBeforeLoad = true;
    }

    _refreshDiscoveredSnapshot();

    final previousLevel = level;
    final xpBefore = _xp;

    _xp += ElementData.xpForRarity(result.rarity);

    final newlyUnlocked = _checkAchievementsInternal();

    final xpGained = _xp - xpBefore;
    final didLevelUp = level > previousLevel;
    _levelUpTriggered = didLevelUp;

    final discoveryResult = FusionResult(
      status: FusionStatus.newDiscovery,
      element: result,
      xpGained: xpGained,
      unlockedAchievements:
          List<AchievementModel>.unmodifiable(newlyUnlocked),
      leveledUp: didLevelUp,
    );
    _lastFusionResult = discoveryResult;

    _saveProgress();
    notifyListeners();

    return discoveryResult;
  }

  List<AchievementModel> _checkAchievementsInternal() {
    final newlyUnlocked = <AchievementModel>[];

    for (final achievement in AchievementData.all) {
      if (_unlockedAchievementIds.contains(achievement.id)) {
        continue;
      }

      if (discoveryCount >= achievement.requiredDiscoveries) {
        _unlockedAchievementIds.add(achievement.id);
        if (!_pendingAchievements.any(
          (pending) => pending.id == achievement.id,
        )) {
          _pendingAchievements.add(achievement);
        }
        _xp += achievement.xpReward;
        newlyUnlocked.add(achievement);
      }
    }

    if (newlyUnlocked.isNotEmpty) {
      _refreshAchievementsSnapshot();
    }

    return newlyUnlocked;
  }

  AchievementModel? consumePendingAchievement() {
    if (_pendingAchievements.isEmpty) {
      return null;
    }

    final achievement = _pendingAchievements.removeAt(0);

    notifyListeners();

    return achievement;
  }

  List<AchievementModel> get achievements => AchievementData.all;

  List<AchievementModel> get unlockedAchievements {
    return AchievementData.all
        .where(
          (achievement) =>
              _unlockedAchievementIds.contains(achievement.id),
        )
        .toList();
  }

  void clearFusion() {
    if (_firstElementId == null &&
        _secondElementId == null &&
        _lastFusionResult == null &&
        !_levelUpTriggered) {
      return;
    }

    _firstElementId = null;
    _secondElementId = null;
    _lastFusionResult = null;
    _levelUpTriggered = false;

    notifyListeners();
  }

  Future<void> _saveProgress() {
    final xpSnapshot = _xp;
    final elementsSnapshot = _discoveredElementIds.toList(
      growable: false,
    );
    final achievementsSnapshot = _unlockedAchievementIds.toList(
      growable: false,
    );

    return _enqueueWrite((prefs) async {
      await prefs.setInt(
        _xpKey,
        xpSnapshot,
      );

      await prefs.setStringList(
        _discoveredElementsKey,
        elementsSnapshot,
      );

      await prefs.setStringList(
        _unlockedAchievementsKey,
        achievementsSnapshot,
      );
    });
  }

  String text({
    required String english,
    required String bangla,
  }) {
    return _languageCode == 'bn' ? bangla : english;
  }
}
