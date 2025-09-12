import 'package:flutter/material.dart';

class AppRadius {
  // Border radius scale
  static const double xs = 2;
  static const double sm = 4;
  static const double md = 6;
  static const double lg = 8;
  static const double xl = 12;
  static const double xxl = 16;

  // Common border radius
  static const BorderRadius radiusXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusXxl = BorderRadius.all(Radius.circular(xxl));

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
}
