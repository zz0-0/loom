import 'package:flutter/material.dart';

class AppRadius {
  // Border radius scale
  static const double xs = 2;
  static const double sm = 4;
  static const double md = 6;
  static const double lg = 8;
  static const double xl = 12;
  static const double xxl = 16;
  static const double xxxl = 24;
  static const double circular = 9999; // For fully rounded elements

  // Common border radius
  static const BorderRadius radiusXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusXxl = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius radiusXxxl =
      BorderRadius.all(Radius.circular(xxxl));
  static const BorderRadius radiusCircular =
      BorderRadius.all(Radius.circular(circular));

  // Rounded rectangle borders
  static const RoundedRectangleBorder roundedRectangleXs =
      RoundedRectangleBorder(borderRadius: radiusXs);
  static const RoundedRectangleBorder roundedRectangleSm =
      RoundedRectangleBorder(borderRadius: radiusSm);
  static const RoundedRectangleBorder roundedRectangleMd =
      RoundedRectangleBorder(borderRadius: radiusMd);
  static const RoundedRectangleBorder roundedRectangleLg =
      RoundedRectangleBorder(borderRadius: radiusLg);
  static const RoundedRectangleBorder roundedRectangleXl =
      RoundedRectangleBorder(borderRadius: radiusXl);
  static const RoundedRectangleBorder roundedRectangleXxl =
      RoundedRectangleBorder(borderRadius: radiusXxl);
  static const RoundedRectangleBorder roundedRectangleXxxl =
      RoundedRectangleBorder(borderRadius: radiusXxxl);

  // Specific radius values for common UI patterns
  static const double buttonRadius = sm; // 4
  static const double cardRadius = lg; // 8
  static const double dialogRadius = lg; // 8
  static const double inputRadius = sm; // 4
  static const double tooltipRadius = sm; // 4
  static const double badgeRadius = md; // 6

  // Utility method to get radius by value
  static BorderRadius getRadius(double value) {
    return BorderRadius.all(Radius.circular(value));
  }

  static RoundedRectangleBorder getRoundedRectangleBorder(double value) {
    return RoundedRectangleBorder(borderRadius: getRadius(value));
  }
}
