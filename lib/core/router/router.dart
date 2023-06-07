import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Route<dynamic>? onGenerateRoute(RouteSettings settings) => null;

class MagicRouter {
  static BuildContext? currentContext = navigatorKey.currentContext;

  static Future<dynamic> navigateTo(Widget page) =>
      navigatorKey.currentState!.push(_materialPageRoute(page));

  static Future<dynamic> navigateAndPopAll(Widget page) =>
      navigatorKey.currentState!.pushAndRemoveUntil(
        _materialPageRoute(page),
        (_) => false,
      );

  static Future<dynamic> navigateAndPopUntilFirstPage(Widget page) =>
      navigatorKey.currentState!.pushAndRemoveUntil(
          _materialPageRoute(page), (route) => route.isFirst);

  static Future<dynamic> navigateAndPop(Widget page) =>
      navigatorKey.currentState!.pushReplacement(_materialPageRoute(page));

  static bool get canPop => navigatorKey.currentState!.canPop();

  static void pop() => navigatorKey.currentState!.pop();

  static Route<dynamic> _materialPageRoute(Widget page) => Platform.isIOS
      ? CupertinoPageRoute(builder: (_) => page)
      : MaterialPageRoute(builder: (_) => page);
}
