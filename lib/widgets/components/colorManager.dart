import 'package:flutter/material.dart';

// ─── Color palette ────────────────────────────────────────────────────────────

class AppColors {
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color widgetBackground;
  final Color primaryBackground;
  final Color secondaryBackground;
  final Color text;
  final Color delete;

  const AppColors({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.widgetBackground,
    required this.primaryBackground,
    required this.secondaryBackground,
    required this.text,
    required this.delete,
  });

  AppColors copyWith({
    Color? primary,
    Color? primaryLight,
    Color? primaryDark,
    Color? widgetBackground,
    Color? primaryBackground,
    Color? secondaryBackground,
    Color? text,
    Color? delete,
  }) => AppColors(
    primary: primary ?? this.primary,
    primaryLight: primaryLight ?? this.primaryLight,
    primaryDark: primaryDark ?? this.primaryDark,
    widgetBackground: widgetBackground ?? this.widgetBackground,
    primaryBackground: primaryBackground ?? this.primaryBackground,
    secondaryBackground: secondaryBackground ?? this.secondaryBackground,
    text: text ?? this.text,
    delete: delete ?? this.delete,
  );
}

// ─── Built-in themes ─────────────────────────────────────────────────────────

class AppThemes {
  AppThemes._();

  static const String dark = 'dark';
  static const String light = 'light';

  static const Map<String, AppColors> all = {
    dark: AppColors(
      primary: Colors.blue,
      primaryLight: Color.fromARGB(255, 22, 99, 134),
      primaryDark: Color.fromARGB(255, 23, 48, 60),
      widgetBackground: Color.fromARGB(255, 23, 48, 60),
      primaryBackground: Colors.black,
      secondaryBackground: Color.fromARGB(255, 37, 49, 54),
      text: Colors.white,
      delete: Colors.red,
    ),
    light: AppColors(
      primary: Colors.blue,
      primaryLight: Color.fromARGB(255, 74, 174, 255),
      primaryDark: Color(0xFF0D47A1),
      widgetBackground: Color.fromARGB(255, 74, 174, 255),
      primaryBackground: Color.fromARGB(255, 255, 255, 255),
      secondaryBackground: Color.fromARGB(255, 196, 196, 196),
      text: Color(0xFF212121),
      delete: Color(0xFFB3261E),
    ),
  };
}

// ─── Internal state ───────────────────────────────────────────────────────────

class _ThemeState {
  final String activeThemeId;
  final AppColors colors;
  final Map<String, AppColors> registry;

  const _ThemeState({
    required this.activeThemeId,
    required this.colors,
    required this.registry,
  });

  _ThemeState copyWith({
    String? activeThemeId,
    AppColors? colors,
    Map<String, AppColors>? registry,
  }) => _ThemeState(
    activeThemeId: activeThemeId ?? this.activeThemeId,
    colors: colors ?? this.colors,
    registry: registry ?? this.registry,
  );
}

// ─── Manager ──────────────────────────────────────────────────────────────────

class ColorManager {
  ColorManager._();

  static final _notifier = ValueNotifier<_ThemeState>(
    _ThemeState(
      activeThemeId: AppThemes.dark,
      colors: AppThemes.all[AppThemes.dark]!,
      registry: Map.unmodifiable(AppThemes.all),
    ),
  );

  // ── Read ──────────────────────────────────────────────────────────────────

  static _ThemeState get _s => _notifier.value;
  static AppColors get _c => _s.colors;

  static String get activeTheme => _s.activeThemeId;
  static List<String> get availableThemes => _s.registry.keys.toList();

  static Color get primary => _c.primary;
  static Color get primaryLight => _c.primaryLight;
  static Color get primaryDark => _c.primaryDark;
  static Color get widgetBackground => _c.widgetBackground;
  static Color get primaryBackground => _c.primaryBackground;
  static Color get secondaryBackground => _c.secondaryBackground;
  static Color get text => _c.text;
  static Color get delete => _c.delete;

  // ── Switch to a named theme ───────────────────────────────────────────────

  /// Switch to any registered theme by id.
  /// Throws [ArgumentError] if the id is not registered.
  static void switchTheme(String themeId) {
    final colors = _s.registry[themeId];
    if (colors == null) {
      throw ArgumentError('Theme "$themeId" is not registered.');
    }
    _notifier.value = _s.copyWith(activeThemeId: themeId, colors: colors);
  }

  // ── Register a custom theme ───────────────────────────────────────────────

  /// Add (or overwrite) a theme at runtime.
  /// Pass [activate: true] to switch to it immediately.
  static void registerTheme(
    String themeId,
    AppColors colors, {
    bool activate = false,
  }) {
    final updated = Map<String, AppColors>.from(_s.registry)
      ..[themeId] = colors;
    _notifier.value = _s.copyWith(
      registry: Map.unmodifiable(updated),
      activeThemeId: activate ? themeId : null,
      colors: activate ? colors : null,
    );
  }

  // ── Mutate the active theme on the fly ───────────────────────────────────

  /// Tweak individual colors without leaving the current theme.
  static void set(AppColors Function(AppColors) updater) {
    _notifier.value = _s.copyWith(colors: updater(_s.colors));
  }

  static Listenable get themeChanges => _notifier;

  // ── Internal ──────────────────────────────────────────────────────────────

  static ValueNotifier<_ThemeState> get _listenable => _notifier;
}

// ─── Provider widget ──────────────────────────────────────────────────────────

class ColorManagerProvider extends StatelessWidget {
  final Widget child;
  const ColorManagerProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<_ThemeState>(
      valueListenable: ColorManager._listenable,
      builder: (_, _, _) => child,
    );
  }
}
