# ✨ ALCHEMY — Element Fusion Laboratory

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-Framework-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-Language-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Platform-iOS%20%7C%20Android-8B5CF6?style=for-the-badge" alt="Platforms" />
  <img src="https://img.shields.io/badge/Theme-Cosmic%20Dark-17122B?style=for-the-badge" alt="Cosmic Theme" />
</p>

<p align="center">
  <strong>Combine elements. Discover the unknown. Master the art of alchemy.</strong>
</p>

<p align="center">
  A cosmic-inspired element fusion game built with Flutter, where experimentation unlocks new discoveries and every combination brings you closer to mastering the laboratory.
</p>

---

## 🌌 Overview

**Alchemy** is a Flutter-based element discovery game built around experimentation, fusion, and exploration.

Start with the primordial elements—Fire, Water, Earth, and Air—and combine them to discover new elements. Experiment with different combinations, expand your collection, explore the relationships between discoveries, and progress through your alchemical journey.

Wrapped in a dark cosmic aesthetic with glowing violet accents, animated orbital effects, and interactive laboratory components, Alchemy brings the experience of element discovery to life.

## ✨ Features

### 🧪 Laboratory & Element Fusion
- Combine elements through intuitive tap-to-fuse interactions.
- Drag and drop elements into the fusion chamber.
- Explore combinations using the game's recipe system.
- Receive feedback for successful discoveries, repeated combinations, and unsuccessful attempts.
- Experience cosmic-inspired fusion animations and visual effects.

### 🔥 Element Discovery
- Begin your journey with the four primal elements.
- Unlock new elements by discovering valid combinations.
- Earn experience and progress through levels.
- Track discoveries and explore the growing element catalog.

### 📚 Collection & Grimoire
- Browse discovered elements in a dedicated collection.
- Search elements by their English or Bengali names.
- Filter elements by category.
- Open element details to explore available information.
- Send elements directly into the fusion chamber.

### 🌳 Discovery Tree
- Explore relationships between elements and their ingredients.
- Navigate the discovery graph with interactive pan and zoom controls.
- Inspect element nodes and their alchemical connections.

### 👤 Alchemist Profile
- Track discovery progress and alchemist rank.
- View available achievements and discovery statistics.
- Configure supported gameplay preferences.
- Reset game progress through a confirmation flow.

### 💜 Cosmic Interface
- Dark, nebula-inspired visual design.
- Glowing violet accents and elemental color coding.
- Animated particles and orbital effects.
- Reusable interface components and consistent styling.
- Smooth transitions and responsive interaction feedback.

### ⚙️ Additional Experience
- Language selection for supported languages.
- Fusion hints for eligible undiscovered combinations.
- Fusion history for reviewing previous experiments.
- Haptic feedback controls where supported.
- Persistent game progress and preferences, according to the existing storage implementation.

---

## 🎨 Design Philosophy

Alchemy combines a mysterious cosmic atmosphere with a clear, interactive game interface.

| Design Element | Direction |
|---|---|
| Visual identity | Cosmic, mystical, and minimal |
| Background | Deep space and midnight tones |
| Primary accent | Violet and lavender |
| Element colors | Distinct colors for individual elements |
| Motion | Subtle particles, orbital movement, and fusion feedback |
| Interaction | Direct, responsive, and intuitive |
| Interface | Reusable components and consistent visual hierarchy |

The goal is to make experimentation feel rewarding while keeping the interface readable and easy to navigate.

## 🛠️ Tech Stack

- **Flutter** — Cross-platform application development
- **Dart** — Application logic and game mechanics
- **Material Icons** — Consistent vector-based iconography
- **Custom Flutter Widgets** — Reusable alchemical interface components
- **Flutter Animation APIs** — Interactive motion and visual effects
- **Automated Tests** — Verification of supported application behavior

The application uses its existing project architecture and dependencies. Specific state-management and storage technologies depend on the implementation in the repository.

## 📱 Application Screens

| Screen | Description |
|---|---|
| **Lab** | Combine elements and experiment with fusion recipes. |
| **Collection** | Browse, search, and filter discovered elements. |
| **Discover** | Explore element relationships through the discovery tree. |
| **Profile** | View alchemist progression, achievements, and settings. |
| **Element Details** | Inspect an element and its available recipe information. |

## 🚀 Getting Started

### Prerequisites

Install the following tools:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart SDK](https://dart.dev/get-dart) — included with Flutter
- [Git](https://git-scm.com/)
- Android Studio or Xcode for the platform you want to run

### Installation

**1. Clone the repository**

```bash
git clone YOUR_REPOSITORY_URL
```

**2. Enter the project directory**

```bash
cd alchemy
```

Replace `alchemy` with the actual directory name if different.

**3. Install dependencies**

```bash
flutter pub get
```

**4. Check connected devices**

```bash
flutter devices
```

**5. Run the application**

```bash
flutter run
```

To run on a specific device, use:

```bash
flutter run -d DEVICE_ID
```

Replace `DEVICE_ID` with the identifier shown by `flutter devices`.

## 🧪 Development & Testing

Run static analysis:

```bash
flutter analyze
```

Format Dart files:

```bash
dart format .
```

Run automated tests:

```bash
flutter test
```

Build an Android APK:

```bash
flutter build apk --release
```

Build an iOS application:

```bash
flutter build ios --release
```

Building for iOS requires a compatible macOS environment with Xcode and the appropriate signing configuration when applicable.

## 📂 Project Structure

The following represents the main structure reported for the project. Additional directories may exist.

```text
lib/
├── data/
│   ├── element_data.dart
│   └── recipe_data.dart
├── models/
│   └── element_model.dart
├── screens/
│   ├── home_screen.dart
│   ├── collection_screen.dart
│   ├── discovery_screen.dart
│   ├── element_details_screen.dart
│   └── profile_screen.dart
├── widgets/
│   ├── alchemical_components.dart
│   ├── fusion_area.dart
│   ├── language_selector.dart
│   └── particle_background.dart
└── main.dart
```

**Note:** This is a representative structure, not a guarantee that every filename or directory exactly matches the current repository.

## 🧠 How Fusion Works

Alchemy follows an element-combination model:

1. Select an available element.
2. Add another element to the fusion chamber.
3. Let the recipe system evaluate the combination.
4. Discover a new element when a valid, previously undiscovered recipe matches.
5. Earn progression rewards according to the implemented game rules.
6. Explore the new discovery and continue experimenting.

The available combinations and results are defined by the game's element and recipe data.

## 🗺️ Roadmap

Potential future improvements include:

- [ ] Expanded element catalog and additional fusion recipes.
- [ ] More elaborate discovery animations and particle effects.
- [ ] Enhanced collection sorting and discovery filters.
- [ ] Additional achievements and progression milestones.
- [ ] Improved accessibility and reduced-motion options.
- [ ] Further gameplay balancing and automated regression tests.
- [ ] Additional interface refinements based on device testing.

This roadmap describes potential improvements, not features that are necessarily implemented today.

## 🤝 Contributing

Contributions, suggestions, and bug reports are welcome.

1. Fork the repository.
2. Create a feature branch.
3. Implement and test your changes.
4. Open a pull request with a clear description of the improvements.

Please preserve existing game rules and avoid introducing regressions to fusion, discovery, and progression systems.

## 📄 License

No license has been specified here. Add a `LICENSE` file and update this section before distributing the project or accepting contributions under an open-source license.

## 👨‍💻 Developer

**Mrh Rafi**

Flutter developer passionate about crafting polished mobile experiences, interactive interfaces, and creative applications.

- GitHub: [@mrhrafi3](https://github.com/mrhrafi3)

---

<p align="center">
  <strong>✨ Every discovery begins with an experiment.</strong>
  <br />
  <sub>Built with Flutter and a little cosmic curiosity.</sub>
</p>
