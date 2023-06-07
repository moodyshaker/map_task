import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final String? family;
  final Color? color;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? verticalMargin;
  final double? horizontalMargin;
  final FontWeight? weight;
  final bool isTransparent;
  final bool withBorder;
  final Color? borderColor;
  final Color? textColor;
  final Color? imageColor;
  final double? width;
  final double? height;
  final double? borderWidth;
  final double? hor;
  final double? ver;
  final double? font;
  final bool withIcon;
  final String? iconPath;

  CustomButton(
      {this.onPressed,
      required this.title,
      this.color,
      this.iconPath,
      this.width,
      this.withBorder = false,
      this.verticalPadding,
      this.verticalMargin,
      this.borderWidth,
      this.withIcon = false,
      this.horizontalPadding,
      this.horizontalMargin,
      this.family,
      this.weight,
      this.borderColor,
      this.hor,
      this.isTransparent = false,
      this.height,
      this.font,
      this.textColor,
      this.ver,
      this.imageColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: horizontalMargin ?? 0.w,
            vertical: verticalMargin ?? 0.h),
        padding: EdgeInsets.symmetric(
            vertical: verticalPadding ?? 15.h,
            horizontal: horizontalPadding ?? 0.w),
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: isTransparent ? Colors.transparent : color ?? kPrimaryColor,
          borderRadius: BorderRadius.circular(20.r),
          border: withBorder
              ? Border.all(
                  width: borderWidth ?? 1.0, color: borderColor ?? Colors.white)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                  color: textColor ?? kWhiteColor,
                  fontSize: font ?? 20.sp,
                  fontFamily: family ?? 'Poppins',
                  fontWeight: weight ?? FontWeight.w400),
            ),
            if (withIcon)
              SizedBox(
                width: 12.w,
              ),
            if (withIcon)
              Image.asset(
                getAsset(iconPath!),
                height: 16.h,
                width: 16.h,
              ),
          ],
        ),
      ),
    );
  }
}
