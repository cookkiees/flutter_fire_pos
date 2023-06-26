import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/modules/responsive/responsive_layout.dart';
import 'package:provider/provider.dart';

import '../../data/providers/authentication_provider.dart';
import '../../theme/utils/my_colors.dart';
import 'views/signin_account_views.dart';
import 'views/signup_account_views.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      body: ResponsiveLayout(
        phone: Container(
          alignment: Alignment.center,
          child: Consumer<AuthenticationProvider>(
            builder: (context, authProvider, child) => IndexedStack(
              index: authProvider.tabIndex,
              children: [
                SignInAccountViews(authProvider: authProvider),
                SignUpAccountViews(authProvider: authProvider),
              ],
            ),
          ),
        ),
        tablet: Container(
          alignment: Alignment.center,
          child: Consumer<AuthenticationProvider>(
            builder: (context, authProvider, child) => IndexedStack(
              index: authProvider.tabIndex,
              children: [
                SignInAccountViews(authProvider: authProvider),
                SignUpAccountViews(authProvider: authProvider),
              ],
            ),
          ),
        ),
        largeTablet: Container(
          alignment: Alignment.center,
          child: Consumer<AuthenticationProvider>(
            builder: (context, authProvider, child) => IndexedStack(
              index: authProvider.tabIndex,
              children: [
                SignInAccountViews(authProvider: authProvider),
                SignUpAccountViews(authProvider: authProvider),
              ],
            ),
          ),
        ),
        computer: Container(
          alignment: Alignment.center,
          child: Row(
            children: [
              Consumer<AuthenticationProvider>(
                builder: (context, authProvider, child) => SizedBox(
                  width: 500,
                  child: IndexedStack(
                    index: authProvider.tabIndex,
                    children: [
                      SignInAccountViews(authProvider: authProvider),
                      SignUpAccountViews(authProvider: authProvider),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
