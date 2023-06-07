import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../constants.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 120),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          height: 150.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitDoubleBounce(color: kPrimaryColor,),
            ],
          ),
        ),
      ),
    );
  }
}
