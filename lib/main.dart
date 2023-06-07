import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_task/feature/login.dart';
import 'package:provider/provider.dart';
import 'core/appStorage/shared_preference.dart';
import 'core/provider/auth_provider.dart';
import 'core/router/router.dart';
import 'feature/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Preferences.instance.initPref();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return ScreenUtilInit(
        designSize: const Size(428, 926),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext ctx, Widget? child) => MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => AuthProvider()),
              ],
              child: Builder(
                builder: (BuildContext c) => MaterialApp(
                  title: 'Map Task',
                  debugShowCheckedModeBanner: false,
                  navigatorKey: navigatorKey,
                  theme: ThemeData(fontFamily: 'Poppins'),
                  builder: (context, child) => Directionality(
                    child: child!,
                    textDirection: TextDirection.ltr,
                  ),
                  home: (Preferences.instance.getUserId.isNotEmpty &&
                          Preferences.instance.getUserToken.isNotEmpty)
                      ? Home()
                      : Login(),
                ),
              ),
            ));
  }
}
