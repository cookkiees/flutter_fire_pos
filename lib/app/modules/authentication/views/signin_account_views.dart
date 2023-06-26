import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/custom_elevated_button_widget.dart';
import '../../../components/custom_textformfield_widget.dart';
import '../../../data/providers/authentication_provider.dart';
import '../../../theme/text_theme.dart';
import '../../../theme/utils/my_colors.dart';
import '../widgets/custom_checkbox_widget.dart';

class SignInAccountViews extends StatelessWidget {
  const SignInAccountViews({
    super.key,
    required this.authProvider,
  });
  final AuthenticationProvider authProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      padding: const EdgeInsets.symmetric(
        vertical: 50,
      ),
      decoration: const BoxDecoration(
        color: Colors.white12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back',
                  style: MyTextTheme.defaultStyle(
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Continue with Google or enter your details',
                  style: MyTextTheme.defaultStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () => authProvider.loginWithGoogle(),
                    icon: SvgPicture.asset('/icons/google.svg', height: 26),
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: MyColors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(),
                          borderRadius: BorderRadius.circular(4),
                        )),
                    label: Text(
                      'Sign in with Google',
                      style: MyTextTheme.defaultStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Flexible(child: Divider(thickness: 1)),
                    const SizedBox(width: 12),
                    Text(
                      'or',
                      style: MyTextTheme.defaultStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Flexible(child: Divider(thickness: 1)),
                  ],
                ),
                const SizedBox(height: 24),
                CustomTextFormFieldWidget(
                  labelText: 'Email',
                  styleColor: MyColors.primary,
                  errorText: authProvider.errorEmail,
                  controller: authProvider.emailController,
                  // errorText: '',
                ),
                const SizedBox(height: 8),
                CustomTextFormFieldWidget(
                  labelText: 'Password',
                  styleColor: MyColors.primary,
                  errorText: authProvider.errorPasword,
                  controller: authProvider.passwordController,
                  // errorText: '',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 90, right: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomCheckboxWidget(
                  value: authProvider.value,
                  onChanged: (newValue) {
                    authProvider.setValue(newValue ?? false);
                  },
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'Forgot password',
                    style: MyTextTheme.defaultStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.blue,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: Column(
              children: [
                CustomElevatedButtonWidget(
                  title: 'Sign in',
                  radius: 4,
                  onPressed: () => authProvider.loginWithEmailPassword(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account ?",
                      style: MyTextTheme.defaultStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => authProvider.changeTabIndex(1),
                      child: Text(
                        "Sign up for free",
                        style: MyTextTheme.defaultStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.blue,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}
