import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/components/custom_textformfield_widget.dart';
import 'package:flutter_fire_pos/app/data/providers/authentication_provider.dart';
import 'package:flutter_fire_pos/app/theme/text_theme.dart';
import 'package:flutter_fire_pos/app/theme/utils/my_colors.dart';
import 'package:provider/provider.dart';

import '../../components/custom_elevated_button_widget.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    return Scaffold(
      backgroundColor: MyColors.primary,
      body: Container(
        padding: const EdgeInsets.all(10.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 500,
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
              width: 800,
              decoration: BoxDecoration(
                color: MyColors.primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Get Started',
                    style: MyTextTheme.defaultStyle(
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 36),
                  CustomTextFormFieldWidget(
                    labelText: 'Email',
                    styleColor: Colors.white,
                    errorText: authProvider.errorEmail,
                    controller: authProvider.emailController,
                    // errorText: '',
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormFieldWidget(
                    labelText: 'Password',
                    styleColor: Colors.white,
                    errorText: authProvider.errorPasword,
                    controller: authProvider.passwordController,
                    // errorText: '',
                  ),
                  const SizedBox(height: 36),
                  CustomElevatedButtonWidget(
                    title: 'Sign in',
                    radius: 4,
                    onPressed: () => authProvider.loginWithEmailPassword(),
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () => authProvider.loginWithGoogle(),
                      icon: const Icon(Icons.apple),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.purple,
                      ),
                      label: Text(
                        'Sign in with Google',
                        style: MyTextTheme.defaultStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
