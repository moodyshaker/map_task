import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_task/core/appStorage/shared_preference.dart';
import 'package:map_task/core/provider/auth_provider.dart';
import '../../constants.dart';
import '../../core/router/router.dart';
import '../feature/login.dart';
import 'action_dialog.dart';
import 'main_text.dart';

class CustomScaffold extends StatefulWidget {
  final String? title;
  final bool home;
  final Widget body;
  final Widget? actionWidget;
  final Color? backgroundColor;

  final Function()? onBackPressed;

  const CustomScaffold(
      {this.title,
      required this.body,
      this.backgroundColor,
      this.home = false,
      this.actionWidget,
      this.onBackPressed,
      Key? key})
      : super(key: key);

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.get(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          WillPopScope(
            onWillPop: () async {
              if (!MagicRouter.canPop && widget.onBackPressed == null) {
                widget.home
                    ? showDialog(
                        context: navigatorKey.currentContext!,
                        builder: (c) => ActionDialog(
                              content: 'Do you want logout ?',
                              onCancelClick: () {
                                MagicRouter.pop();
                              },
                              approveAction: 'Yes',
                              cancelAction: 'No',
                              onApproveClick: () async {
                                MagicRouter.pop();
                               await auth.logout();
                              },
                            ))
                    : showDialog(
                        context: navigatorKey.currentContext!,
                        builder: (c) => ActionDialog(
                              content: 'Do you want to exit ?',
                              onCancelClick: () {
                                MagicRouter.pop();
                              },
                              approveAction: 'Yes',
                              cancelAction: 'No',
                              onApproveClick: () {
                                MagicRouter.pop();
                                SystemNavigator.pop();
                              },
                            ));
              } else {
                widget.onBackPressed != null
                    ? widget.onBackPressed!()
                    : MagicRouter.pop();
              }
              return false;
            },
            child: Scaffold(
              backgroundColor: widget.backgroundColor ?? kWhiteColor,
              body: SafeArea(child: widget.body),
            ),
          ),
        ],
      ),
    );
  }
}
