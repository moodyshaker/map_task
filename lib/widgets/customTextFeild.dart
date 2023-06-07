import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants.dart';
import 'main_text.dart';

class CustomTextField extends StatefulWidget {
  final String? hint;
  final String? initialValue;
  final int? minLines;
  final int? maxLines;
  final bool? hasLabel;
  final bool? hasHint;
  final Color? hintColor;
  final int? maxLength;
  final bool nullMax;
  final TextInputType? type;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String?)? onsave;
  final Function()? suffixCallback;
  final Function(String?)? onChange;
  final Function()? iconCallback;
  final String? Function(String?)? valid;
  final AutovalidateMode? validationMode;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Color? cursorColor;
  final bool isPassword;
  final double? radius;
  final FontWeight? hintWeight;
  final double? hintFont;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final String? prefixPath;
  final FocusNode? focus;
  final bool autoFocus;
  final bool? read;
  final bool withPasswordIcon;
  final bool isPhone;
  final bool? flag;
  final TextAlign? align;
  final TextInputAction? action;
  final VoidCallback? edit;
  final bool? isEdit;
  final double? hor;
  final double? horizontalPadding;
  final double? verticalPadding;

  CustomTextField({
    this.hint,
    this.maxLines,
    this.onsave,
    this.hintWeight,
    this.hintFont,
    this.onTap,
    this.cursorColor,
    this.radius,
    this.minLines,
    this.hintColor,
    this.suffixCallback,
    this.withPasswordIcon = true,
    this.suffixIcon,
    this.type,
    this.initialValue,
    this.maxLength,
    this.nullMax = false,
    this.inputFormatters,
    this.fillColor,
    this.valid,
    this.action,
    this.hasHint = true,
    this.align,
    this.onChange,
    this.isPassword = false,
    this.iconCallback,
    this.controller,
    this.isPhone = false,
    this.focus,
    this.autoFocus = false,
    this.prefixPath,
    this.hasLabel,
    this.read,
    this.edit,
    this.isEdit,
    this.flag,
    this.hor,
    this.validationMode,
    this.verticalPadding,
    this.horizontalPadding,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isHidden = true;

  void _visibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(16.r), boxShadow: [
        BoxShadow(
          color: kBlackColor.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 3,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ]),
      child: TextFormField(
        onTap: widget.onTap,
        initialValue: widget.initialValue,
        validator: widget.valid,
        controller: widget.controller,
        cursorColor: widget.cursorColor ?? kPrimaryColor,
        onSaved: widget.onsave,
        focusNode: widget.focus,
        inputFormatters: widget.inputFormatters,
        textAlign: widget.align ?? TextAlign.start,
        textInputAction: widget.action,
        readOnly: widget.read == true ? true : false,
        maxLines:
            widget.nullMax ? null : widget.maxLines ?? widget.minLines ?? 1,
        minLines: widget.minLines,
        autofocus: widget.autoFocus,
        maxLength: widget.isPhone ? 11 : widget.maxLength,
        obscureText: widget.isPassword ? _isHidden : false,
        keyboardType: widget.type,
        onChanged: widget.onChange,
        style: TextStyle(
          fontSize: 16.sp,
          color: kBlackColor,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
        ),
        decoration: InputDecoration(
          errorStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          hintText: widget.hasHint == true ? widget.hint : null,
          fillColor: widget.fillColor ?? kWhiteColor,
          filled: true,
          contentPadding: EdgeInsets.symmetric(
              horizontal: widget.horizontalPadding ?? 25.w,
              vertical: (widget.minLines != null && widget.minLines! > 1)
                  ? 10.h
                  : widget.verticalPadding ?? 0),
          prefixIcon: widget.prefixPath != null
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  height: 45.h,
                  width: 45.w,
                  child: Center(
                    child: Image.asset(getAsset(widget.prefixPath!),
                        height: 24.h, width: 24.w),
                  ),
                )
              : null,
          labelText: widget.hasLabel == true ? widget.hint : null,
          prefix: widget.flag == true ? const MainText(text: "+966  ") : null,
          icon: widget.isEdit == true ? const Icon(Icons.edit) : null,
          counterText: '',
          labelStyle: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
            fontFamily: 'Poppins',
          ),
          hintStyle: TextStyle(
            fontSize: widget.hintFont ?? 16.sp,
            fontWeight: widget.hintWeight ?? FontWeight.w400,
            color: widget.hintColor ?? kBlackColor,
            fontFamily: 'Poppins',
          ),
          suffixIcon: widget.isPassword
              ? widget.withPasswordIcon
                  ? Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: IconButton(
                        onPressed: _visibility,
                        alignment: Alignment.center,
                        icon: _isHidden
                            ? const Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                              )
                            : const Icon(
                                Icons.visibility,
                                color: Colors.grey,
                              ),
                      ),
                    )
                  : IconButton(
                      onPressed: () {},
                      icon: Container(),
                    )
              : widget.suffixIcon,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(widget.radius ?? 16.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: kPrimaryColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(widget.radius ?? 16.r),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(widget.radius ?? 16.r),
          ),
        ),
      ),
    );
  }
}
