// File: lib/utils/app_constants.dart

import 'package:flutter/material.dart';

/// App-wide constants for consistent spacing, sizing, and timing
class AppConstants {
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Border radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;

  // Icon sizes
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;

  // Button heights
  static const double buttonHeightS = 36.0;
  static const double buttonHeightM = 48.0;
  static const double buttonHeightL = 56.0;

  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Elevation
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;

  // Max widths
  static const double maxContentWidth = 600.0;
  static const double maxDialogWidth = 500.0;

  // Padding presets
  static const EdgeInsets paddingAll = EdgeInsets.all(spacingM);
  static const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(
    horizontal: spacingM,
  );
  static const EdgeInsets paddingVertical = EdgeInsets.symmetric(
    vertical: spacingM,
  );
  static const EdgeInsets paddingAllL = EdgeInsets.all(spacingL);
  static const EdgeInsets paddingAllS = EdgeInsets.all(spacingS);

  // Database constants
  static const String dbName = 'app_database.db';
  static const int dbVersion = 1;
}
