import 'package:flutter/material.dart';

const header = TextStyle(
  fontFamily: 'San Francisco',
  fontSize: 26,
  fontWeight: FontWeight.bold,
  height: 1.1,
);

const titleBold = TextStyle(
  fontFamily: 'San Francisco',
  fontSize: 18,
  fontWeight: FontWeight.bold,
  height: 1.25,
);

const title = TextStyle(
  fontFamily: 'San Francisco',
  fontSize: 18,
  fontWeight: FontWeight.normal,
  height: 1.25,
);

const caption = TextStyle(
  fontFamily: 'San Francisco',
  fontSize: 14,
  fontWeight: FontWeight.bold,
  height: 1.4,
);

const body = TextStyle(
  fontFamily: 'San Francisco',
  fontSize: 14,
  fontWeight: FontWeight.normal,
  height: 1.4,
);

const bodySmoke = TextStyle(
  fontFamily: 'San Francisco',
  fontSize: 14,
  fontWeight: FontWeight.normal,
  height: 1.4,
);

const button = TextStyle(
  fontFamily: 'San Francisco',
  fontSize: 14,
  fontWeight: FontWeight.normal,
  height: 1.0,
);

const functional = TextStyle(
  fontFamily: 'San Francisco',
  fontSize: 12,
  fontWeight: FontWeight.normal,
  height: 1.25,
);

const small = TextStyle(
  fontFamily: 'San Francisco',
  fontSize: 10,
  fontWeight: FontWeight.normal,
  height: 1.25,
);

// Colors
// text colors
const textPrimary = Color.fromRGBO(33, 33, 33, 1);
const textSmoke = Color.fromRGBO(97, 97, 97, 1);
const redSolid = Color.fromRGBO(230, 74, 25, 1);
const redLight = Color.fromRGBO(229, 148, 148, 1);
const greenSolid = Color.fromRGBO(56, 142, 60, 1);
const greenLight = Color.fromRGBO(148, 229, 151, 1);

// background colors
const background = Color.fromRGBO(255, 255, 255, 1);
const redBackground = Color.fromRGBO(255, 216, 204, 1);
const greenBackground = Color.fromRGBO(232, 245, 233, 1);

// primary colors
const primary = Color.fromRGBO(101, 141, 221, 1);
const primarySmoke = Color.fromRGBO(245, 250, 255, 1);

class CommonThemes {
  static ThemeData appTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(background: background),
    fontFamily: 'San Francisco',
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      hintStyle: body.copyWith(
        color: Colors.black.withOpacity(0.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      fillColor: background,
      filled: true,
      labelStyle: body,
      border: const OutlineInputBorder(
        gapPadding: 0,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: textSmoke),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: textSmoke),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: button,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        side: const BorderSide(color: Colors.transparent),
      ),
    ),
  );
}
