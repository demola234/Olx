import 'package:ecommerce/core/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class OlxButton extends StatelessWidget {
  const OlxButton({
    Key? key,
    required this.color,
    required this.onTap,
    this.isBorder = false,
    this.textColor = Colors.white,
    required this.text,
    this.icon = "",
  }) : super(key: key);

  final Color color;
  final String text;
  final Color textColor;
  final String icon;
  final bool isBorder;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        height: 60,
        width: context.screenWidth(),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
              color: isBorder
                  ? const Color(0xFF1F2421).withOpacity(0.3)
                  : Colors.transparent),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const XMargin(5),
              icon.isNotEmpty ? SvgPicture.asset(icon) : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
