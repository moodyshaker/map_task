import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_task/widgets/customScaffold.dart';
import '../constants.dart';

import '../core/notifications/firebase.dart';
import '../core/provider/auth_provider.dart';
import '../core/router/router.dart';
import '../core/validate/validation.dart';
import '../widgets/customButton.dart';
import '../widgets/customTextFeild.dart';
import '../widgets/main_text.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    FirebaseNotifications.getFCM();
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.get(context);
    return CustomScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Column(
          children: [
            SizedBox(
              height: 60.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MainText(
                  text: 'Sign In',
                  font: 24.sp,
                  weight: FontWeight.w600,
                ),
              ],
            ),
            SizedBox(
              height: 80.h,
            ),
            Form(
              key: _form,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      controller: auth.loginEmailController,
                      hasHint: true,
                      prefixPath: 'email_icon',
                      hint: 'Phone',
                      isPhone: true,
                      type: TextInputType.phone,
                      valid: (String? v) =>
                          v!.isEmpty ? 'Please Check Your Phone Number' : null,
                    ),
                    SizedBox(height: 40.h),
                    CustomTextField(
                      controller: auth.loginPasswordController,
                      hasHint: true,
                      hint: 'Password',
                      prefixPath: 'password_icon',
                      type: TextInputType.visiblePassword,
                      isPassword: true,
                      valid: (String? v) => v!.isEmpty
                          ? 'Please Enter your password'
                          : v.length < 8
                              ? 'Make sure your password is not less than 8 characters'
                              : null,
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    CustomButton(
                      title: 'Sign In',
                      onPressed: () async {
                        if (_form.currentState!.validate()) {
                          await auth.login();
                        }
                      },
                      verticalPadding: 16.h,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
