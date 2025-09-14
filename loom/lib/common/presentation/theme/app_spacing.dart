import 'package:flutter/material.dart';

class AppSpacing {
  // Spacing scale based on 4px grid system
  static const double xs = 4;
  static const double sm = 8;
  static const double smd = 12; // Small-medium spacing
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // Common padding values
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingSmd = EdgeInsets.all(smd);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  // Horizontal padding
  static const EdgeInsets paddingHorizontalXs =
      EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets paddingHorizontalSm =
      EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalSmd =
      EdgeInsets.symmetric(horizontal: smd);
  static const EdgeInsets paddingHorizontalMd =
      EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLg =
      EdgeInsets.symmetric(horizontal: lg);

  // Vertical padding
  static const EdgeInsets paddingVerticalXs =
      EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingVerticalSm =
      EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalSmd =
      EdgeInsets.symmetric(vertical: smd);
  static const EdgeInsets paddingVerticalMd =
      EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLg =
      EdgeInsets.symmetric(vertical: lg);

  // Specific combinations for padding
  static const EdgeInsets paddingTopXs = EdgeInsets.only(top: xs);
  static const EdgeInsets paddingBottomXs = EdgeInsets.only(bottom: xs);
  static const EdgeInsets paddingLeftXs = EdgeInsets.only(left: xs);
  static const EdgeInsets paddingRightXs = EdgeInsets.only(right: xs);

  static const EdgeInsets paddingTopSm = EdgeInsets.only(top: sm);
  static const EdgeInsets paddingBottomSm = EdgeInsets.only(bottom: sm);
  static const EdgeInsets paddingLeftSm = EdgeInsets.only(left: sm);
  static const EdgeInsets paddingRightSm = EdgeInsets.only(right: sm);

  static const EdgeInsets paddingTopSmd = EdgeInsets.only(top: smd);
  static const EdgeInsets paddingBottomSmd = EdgeInsets.only(bottom: smd);
  static const EdgeInsets paddingLeftSmd = EdgeInsets.only(left: smd);
  static const EdgeInsets paddingRightSmd = EdgeInsets.only(right: smd);

  static const EdgeInsets paddingTopMd = EdgeInsets.only(top: md);
  static const EdgeInsets paddingBottomMd = EdgeInsets.only(bottom: md);
  static const EdgeInsets paddingLeftMd = EdgeInsets.only(left: md);
  static const EdgeInsets paddingRightMd = EdgeInsets.only(right: md);

  static const EdgeInsets paddingTopLg = EdgeInsets.only(top: lg);
  static const EdgeInsets paddingBottomLg = EdgeInsets.only(bottom: lg);
  static const EdgeInsets paddingLeftLg = EdgeInsets.only(left: lg);
  static const EdgeInsets paddingRightLg = EdgeInsets.only(right: lg);

  static const EdgeInsets paddingTopXl = EdgeInsets.only(top: xl);
  static const EdgeInsets paddingBottomXl = EdgeInsets.only(bottom: xl);
  static const EdgeInsets paddingLeftXl = EdgeInsets.only(left: xl);
  static const EdgeInsets paddingRightXl = EdgeInsets.only(right: xl);

  static const EdgeInsets paddingTopXxl = EdgeInsets.only(top: xxl);
  static const EdgeInsets paddingBottomXxl = EdgeInsets.only(bottom: xxl);
  static const EdgeInsets paddingLeftXxl = EdgeInsets.only(left: xxl);
  static const EdgeInsets paddingRightXxl = EdgeInsets.only(right: xxl);

  // Common margin values
  static const EdgeInsets marginXs = EdgeInsets.all(xs);
  static const EdgeInsets marginSm = EdgeInsets.all(sm);
  static const EdgeInsets marginSmd = EdgeInsets.all(smd);
  static const EdgeInsets marginMd = EdgeInsets.all(md);
  static const EdgeInsets marginLg = EdgeInsets.all(lg);
  static const EdgeInsets marginXl = EdgeInsets.all(xl);

  // Horizontal margin
  static const EdgeInsets marginHorizontalXs =
      EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets marginHorizontalSm =
      EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets marginHorizontalSmd =
      EdgeInsets.symmetric(horizontal: smd);
  static const EdgeInsets marginHorizontalMd =
      EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets marginHorizontalLg =
      EdgeInsets.symmetric(horizontal: lg);

  // Vertical margin
  static const EdgeInsets marginVerticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets marginVerticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets marginVerticalSmd =
      EdgeInsets.symmetric(vertical: smd);
  static const EdgeInsets marginVerticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets marginVerticalLg = EdgeInsets.symmetric(vertical: lg);

  // Specific combinations for margin
  static const EdgeInsets marginTopXs = EdgeInsets.only(top: xs);
  static const EdgeInsets marginBottomXs = EdgeInsets.only(bottom: xs);
  static const EdgeInsets marginLeftXs = EdgeInsets.only(left: xs);
  static const EdgeInsets marginRightXs = EdgeInsets.only(right: xs);

  static const EdgeInsets marginTopSm = EdgeInsets.only(top: sm);
  static const EdgeInsets marginBottomSm = EdgeInsets.only(bottom: sm);
  static const EdgeInsets marginLeftSm = EdgeInsets.only(left: sm);
  static const EdgeInsets marginRightSm = EdgeInsets.only(right: sm);

  static const EdgeInsets marginTopSmd = EdgeInsets.only(top: smd);
  static const EdgeInsets marginBottomSmd = EdgeInsets.only(bottom: smd);
  static const EdgeInsets marginLeftSmd = EdgeInsets.only(left: smd);
  static const EdgeInsets marginRightSmd = EdgeInsets.only(right: smd);

  static const EdgeInsets marginTopMd = EdgeInsets.only(top: md);
  static const EdgeInsets marginBottomMd = EdgeInsets.only(bottom: md);
  static const EdgeInsets marginLeftMd = EdgeInsets.only(left: md);
  static const EdgeInsets marginRightMd = EdgeInsets.only(right: md);

  static const EdgeInsets marginTopLg = EdgeInsets.only(top: lg);
  static const EdgeInsets marginBottomLg = EdgeInsets.only(bottom: lg);
  static const EdgeInsets marginLeftLg = EdgeInsets.only(left: lg);
  static const EdgeInsets marginRightLg = EdgeInsets.only(right: lg);

  static const EdgeInsets marginTopXl = EdgeInsets.only(top: xl);
  static const EdgeInsets marginBottomXl = EdgeInsets.only(bottom: xl);
  static const EdgeInsets marginLeftXl = EdgeInsets.only(left: xl);
  static const EdgeInsets marginRightXl = EdgeInsets.only(right: xl);

  static const EdgeInsets marginTopXxl = EdgeInsets.only(top: xxl);
  static const EdgeInsets marginBottomXxl = EdgeInsets.only(bottom: xxl);
  static const EdgeInsets marginLeftXxl = EdgeInsets.only(left: xxl);
  static const EdgeInsets marginRightXxl = EdgeInsets.only(right: xxl);
}
