import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class Config {
  static bool get isAndroid => Platform.isAndroid;
  static bool get isIos => Platform.isIOS;

  static TextStyle h1(BuildContext context) => GoogleFonts.montserrat(
        fontSize: textSize(context, 4),
        height: 1.6,
        fontWeight: FontWeight.w600,
      );

  static TextStyle h2(BuildContext context) => GoogleFonts.montserrat(
        fontSize: textSize(context, 3),
        height: 1.6,
        fontWeight: FontWeight.w700,
      );

  static TextStyle h3(BuildContext context) => GoogleFonts.montserrat(
        fontSize: textSize(context, 2.5),
        height: 1.6,
        fontWeight: FontWeight.w400,
      );

  static TextStyle b1(BuildContext context) => GoogleFonts.montserrat(
        fontSize: textSize(context, 1.5),
        fontWeight: FontWeight.w600,
        height: 1.6,
      );

  static TextStyle b2(BuildContext context) => GoogleFonts.montserrat(
        fontSize: textSize(context, 1.5),
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  static TextStyle b3(BuildContext context) => GoogleFonts.montserrat(
        fontSize: textSize(context, 1.2),
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  static double yMargin(BuildContext context, double height) {
    double viewPortHeight = MediaQuery.of(context).size.longestSide;
    viewPortHeight = viewPortHeight > 950 ? 950 : viewPortHeight;
    return height * (viewPortHeight / 100);
  }

  static double xMargin(BuildContext context, double width) {
    double viewPortwidth = MediaQuery.of(context).size.shortestSide;
    viewPortwidth = viewPortwidth > 650 ? 650 : viewPortwidth;
    return width * (viewPortwidth / 100);
  }

  static double textSize(BuildContext context, double size) {
    double vph = MediaQuery.of(context).size.longestSide;
    double vpw = MediaQuery.of(context).size.shortestSide;

    final val = pow(vph, 2) + pow(vpw, 2);

    double hyp = sqrt(val);
    hyp = hyp > 1000 ? 1000 : hyp;

    return size * (hyp / 100);
  }
}

extension CustomContext on BuildContext {
  double screenHeight([double percent = 1]) =>
      MediaQuery.of(this).size.height * percent;

  double screenWidth([double percent = 1]) =>
      MediaQuery.of(this).size.width * percent;
}

class XMargin extends StatelessWidget {
  final double x;
  // ignore: use_key_in_widget_constructors
  const XMargin(this.x);
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: x);
  }
}

class YMargin extends StatelessWidget {
  final double y;
  // ignore: use_key_in_widget_constructors
  const YMargin(this.y);
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: y);
  }
}
