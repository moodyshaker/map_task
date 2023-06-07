import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants.dart';

class ActionDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final String? approveAction;
  final ShapeBorder? shape;
  final String? cancelAction;
  final VoidCallback? onApproveClick;
  final VoidCallback? onCancelClick;

  const ActionDialog({
    this.title,
    this.content,
    this.shape,
    this.approveAction,
    this.cancelAction,
    this.onApproveClick,
    this.onCancelClick,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Dialog(
        backgroundColor: kWhiteColor,
        shape: shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              title != null
                  ? Text(
                      title!,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: kBlackColor,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.start,
                    )
                  : Container(),
              title != null
                  ? SizedBox(
                      height: 10.h,
                    )
                  : Container(),
              content != null
                  ? Text(
                      content!,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: kBlackColor,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : Container(),
              content != null
                  ? SizedBox(
                      height: 10.h,
                    )
                  : Container(),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                onApproveClick != null || approveAction != null
                    ? ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  100.0.r,
                                ),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                kPrimaryColor)),
                        onPressed: onApproveClick,
                        child: Text(
                          approveAction ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                          ),
                        ),
                      )
                    : Container(),
                ((onApproveClick != null || approveAction != null) &&
                        (onCancelClick != null || cancelAction != null))
                    ? SizedBox(
                        width: 10.w,
                      )
                    : Container(),
                onCancelClick != null || cancelAction != null
                    ? ElevatedButton(
                        onPressed: onCancelClick,
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  100.r,
                                ),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                kPrimaryColor)),
                        child: Text(
                          cancelAction ?? '',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp),
                        ),
                      )
                    : Container()
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
