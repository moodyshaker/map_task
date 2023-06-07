import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class MainText extends StatelessWidget {
  final String? text;
  final String? family;
  final double? font;
  final FontWeight? weight;
  final double verticalPadding, horizontalPadding;
  final TextDecoration? decoration;
  final TextOverflow? overflow;
  final TextAlign textAlign;
  final Color? color;
  final double? lineHeight;
  final int? maxLines;

  const MainText({
    Key? key,
    this.text,
    this.font,
    this.overflow,
    this.lineHeight,
    this.decoration,
    this.textAlign = TextAlign.start,
    this.verticalPadding = 0,
    this.horizontalPadding = 0,
    this.color,
    this.maxLines,
    this.weight,
    this.family,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding, horizontal: horizontalPadding),
      child: Text(text!,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          style: TextStyle(
            color: color ?? kBlackColor,
            fontSize: font ?? 20.sp,
            height: lineHeight,
            decoration: decoration ?? TextDecoration.none,
            fontWeight: weight ?? FontWeight.w500,
            fontFamily: family ?? 'Poppins',
          )),
    );
  }
}
