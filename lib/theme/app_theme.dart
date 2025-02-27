// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voccent/theme/theme_type.dart';

class AppTheme {
  AppTheme._();
  static ThemeType themeType = ThemeType.light;
  static ThemeData theme = getTheme();

  static void init() {
    resetFont();
    FxAppTheme.changeLightTheme(lightTheme);
    FxAppTheme.changeDarkTheme(darkTheme);
  }

  static void resetFont() {
    FxTextStyle.changeFontFamily(GoogleFonts.ibmPlexSans);
    FxTextStyle.changeDefaultFontWeight({
      100: FontWeight.w100,
      200: FontWeight.w200,
      300: FontWeight.w300,
      400: FontWeight.w300,
      500: FontWeight.w400,
      600: FontWeight.w500,
      700: FontWeight.w600,
      800: FontWeight.w700,
      900: FontWeight.w800,
    });
  }

  static ThemeData getTheme([ThemeType? themeType]) {
    if ((themeType ?? AppTheme.themeType) == ThemeType.light) {
      return lightTheme;
    }

    return darkTheme;
  }

  static void changeFxTheme(ThemeType themeType) {
    if (themeType == ThemeType.light) {
      FxAppTheme.changeThemeType(FxAppThemeType.light);
    } else if (themeType == ThemeType.dark) {
      FxAppTheme.changeThemeType(FxAppThemeType.dark);
    }
  }

  /// -------------------------- Light Theme  -------------------------------------------- ///
  static final ThemeData lightTheme = ThemeData(
    /// Brightness
    brightness: Brightness.light,

    /// Primary Color
    primaryColor: const Color(0xff3d63ff),

    /// Scaffold color
    scaffoldBackgroundColor: const Color(0xffededed),
    canvasColor: Colors.transparent,

    /// AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xffededed),
      iconTheme: IconThemeData(color: Color(0xff495057)),
      actionsIconTheme: IconThemeData(color: Color(0xff495057)),
    ),

    /// Card Theme
    cardTheme: const CardTheme(color: Color(0xfff0f0f0)),
    cardColor: const Color(0xfff0f0f0),

    textTheme: TextTheme(
      titleLarge: GoogleFonts.aBeeZee(),
      bodyLarge: GoogleFonts.abel(),
    ),

    /// Colorscheme
    colorScheme: const ColorScheme.light(
      primary: Color(0xff6874E8),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0x80777ddd),
      onPrimaryContainer: Color(0xff333333),
      secondary: Color(0xffff8800),
      onSecondary: Color(0xff333333),
      secondaryContainer: Color(0xffffaf55),
      onSecondaryContainer: Color(0xff111111),
      tertiary: Color.fromARGB(255, 0, 140, 7),
      onTertiary: Color(0xffeeeeee),
      tertiaryContainer: Color(0xffffbab8),
      onTertiaryContainer: Color(0xffeeeeee),
      error: Color(0xffb3261e),
      onError: Color(0xffffffff),
      errorContainer: Color(0xfff9dedd),
      onErrorContainer: Color(0xff370b1e),
      background: Color(0xffededed),
      onBackground: Color(0xff555555),
      surface: Color(0xffdddddd),
      onSurface: Color(0xff000000),
      surfaceVariant: Color(0xffe7e0ec),
      onSurfaceVariant: Color(0xff49454e),
      outline: Color(0xff79747f),
    )
        .copyWith(background: const Color(0xffededed))
        .copyWith(error: const Color(0xfff0323c)),

    /// Floating Action Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: const Color(0xff3C4EC5),
      splashColor: const Color(0xffeeeeee).withAlpha(100),
      highlightElevation: 8,
      elevation: 4,
      focusColor: const Color(0xff3C4EC5),
      hoverColor: const Color(0xff3C4EC5),
      foregroundColor: const Color(0xffeeeeee),
    ),

    /// Divider Theme
    dividerTheme:
        const DividerThemeData(color: Color(0xffe8e8e8), thickness: 1),
    dividerColor: const Color(0xffe8e8e8),

    /// Bottom AppBar Theme
    bottomAppBarTheme:
        const BottomAppBarTheme(color: Color(0xffeeeeee), elevation: 2),

    /// Tab bar Theme
    tabBarTheme: const TabBarTheme(
      unselectedLabelColor: Color(0xff495057),
      labelColor: Color(0xff3d63ff),
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0xff3d63ff), width: 2),
      ),
    ),

    /// CheckBox theme
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(const Color(0xffeeeeee)),
      fillColor: MaterialStateProperty.all(const Color(0xff3C4EC5)),
    ),

    /// Radio theme
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(const Color(0xff3C4EC5)),
    ),

    ///Switch Theme
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.resolveWith((state) {
        const interactiveStates = <MaterialState>{
          MaterialState.pressed,
          MaterialState.hovered,
          MaterialState.focused,
          MaterialState.selected,
        };
        if (state.any(interactiveStates.contains)) {
          return const Color(0xffabb3ea);
        }
        return null;
      }),
      thumbColor: MaterialStateProperty.resolveWith((state) {
        const interactiveStates = <MaterialState>{
          MaterialState.pressed,
          MaterialState.hovered,
          MaterialState.focused,
          MaterialState.selected,
        };
        if (state.any(interactiveStates.contains)) {
          return const Color(0xff3C4EC5);
        }
        return null;
      }),
    ),

    /// Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: const Color(0xff3d63ff),
      inactiveTrackColor: const Color(0xff3d63ff).withAlpha(140),
      trackShape: const RoundedRectSliderTrackShape(),
      trackHeight: 4,
      thumbColor: const Color(0xff3d63ff),
      thumbShape: const RoundSliderThumbShape(),
      overlayShape: const RoundSliderOverlayShape(),
      tickMarkShape: const RoundSliderTickMarkShape(),
      inactiveTickMarkColor: Colors.red[100],
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      valueIndicatorTextStyle: const TextStyle(
        color: Color(0xffeeeeee),
      ),
    ),

    /// Other Colors
    splashColor: Colors.white.withAlpha(100),
    indicatorColor: const Color(0xffeeeeee),
    highlightColor: const Color(0xffeeeeee),
  );

  /// -------------------------- Dark Theme  -------------------------------------------- ///
  static final ThemeData darkTheme = ThemeData(
    /// Brightness
    brightness: Brightness.dark,

    /// Primary Color
    primaryColor: const Color(0xff3d63ff),

    /// Scaffold and Background color
    scaffoldBackgroundColor: const Color(0xff161616),
    canvasColor: Colors.transparent,

    /// AppBar Theme
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xff161616)),

    /// Card Theme
    cardTheme: const CardTheme(color: Color(0xff222327)),
    cardColor: const Color(0xff222327),

    /// Colorscheme
    colorScheme: const ColorScheme.dark(
      primary: Color(0xff777ddd),
      onPrimary: Color(0xffeeeeee),
      primaryContainer: Color(0x80777ddd),
      onPrimaryContainer: Color(0xffe6e7fd),
      secondary: Color(0xffff8800),
      onSecondary: Color(0xff333333),
      secondaryContainer: Color(0xffffaf55),
      onSecondaryContainer: Color(0xff111111),
      tertiary: Color.fromARGB(255, 30, 232, 40),
      onTertiary: Color(0xff161616),
      tertiaryContainer: Color(0xffffbab8),
      onTertiaryContainer: Color(0xff161616),
      error: Color(0xffff0000),
      onError: Color(0xff161616),
      errorContainer: Color(0xffff5a36),
      onErrorContainer: Color(0xff161616),
      background: Color(0xff161616),
      onBackground: Color(0xff9d9d9d),
      surface: Color(0xff555555),
      onSurface: Color(0x90eeeeee),
      surfaceVariant: Color(0xff5c5c5c),
      onSurfaceVariant: Color(0x90eeeeee),
      outline: Color(0xff808080),
    )
        .copyWith(background: const Color(0xff161616))
        .copyWith(error: Colors.orange),

    /// Input (Text-Field) Theme
    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xff069DEF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white70),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white70),
      ),
    ),

    /// Divider Color
    dividerTheme:
        const DividerThemeData(color: Color(0xff363636), thickness: 1),
    dividerColor: const Color(0xff363636),

    /// Floating Action Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: const Color(0xff069DEF),
      splashColor: Colors.white.withAlpha(100),
      highlightElevation: 8,
      elevation: 4,
      focusColor: const Color(0xff069DEF),
      hoverColor: const Color(0xff069DEF),
      foregroundColor: Colors.white,
    ),

    /// Bottom AppBar Theme
    bottomAppBarTheme:
        const BottomAppBarTheme(color: Color(0xff464c52), elevation: 2),

    /// Tab bar Theme
    tabBarTheme: const TabBarTheme(
      unselectedLabelColor: Color(0xff495057),
      labelColor: Color(0xff069DEF),
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0xff069DEF), width: 2),
      ),
    ),

    ///Switch Theme
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.resolveWith((state) {
        const interactiveStates = <MaterialState>{
          MaterialState.pressed,
          MaterialState.hovered,
          MaterialState.focused,
          MaterialState.selected,
        };
        if (state.any(interactiveStates.contains)) {
          return const Color(0xffabb3ea);
        }
        return null;
      }),
      thumbColor: MaterialStateProperty.resolveWith((state) {
        const interactiveStates = <MaterialState>{
          MaterialState.pressed,
          MaterialState.hovered,
          MaterialState.focused,
          MaterialState.selected,
        };
        if (state.any(interactiveStates.contains)) {
          return const Color(0xff3C4EC5);
        }
        return null;
      }),
    ),

    /// Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: const Color(0xff069DEF),
      inactiveTrackColor: const Color(0xff069DEF).withAlpha(100),
      trackShape: const RoundedRectSliderTrackShape(),
      trackHeight: 4,
      thumbColor: const Color(0xff069DEF),
      thumbShape: const RoundSliderThumbShape(),
      overlayShape: const RoundSliderOverlayShape(),
      tickMarkShape: const RoundSliderTickMarkShape(),
      inactiveTickMarkColor: Colors.red[100],
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
      ),
    ),

    ///Other Color
    indicatorColor: Colors.white,
    disabledColor: const Color(0xffa3a3a3),
    highlightColor: Colors.white.withAlpha(28),
    splashColor: Colors.white.withAlpha(56),
  );

  static ThemeData createTheme(ColorScheme colorScheme) {
    if (themeType != ThemeType.light) {
      return darkTheme.copyWith(
        colorScheme: colorScheme,
      );
    }
    return lightTheme.copyWith(colorScheme: colorScheme);
  }
}
