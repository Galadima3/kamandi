import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kamandi/src/features/auth/presentation/widgets/landing_screen_button.dart';
import 'package:kamandi/src/routing/route_paths.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/tank.png",
            height: 200,
            width: 200,
          ),
          SizedBox(
            height: 100.h,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LandingScreenButton(
                    text: 'Sign up',
                    buttonFunction: () =>
                        context.pushNamed(RoutePaths.registerScreenRoute)),
                LandingScreenButton(
                    text: 'Log in',
                    buttonFunction: () =>
                        context.pushNamed(RoutePaths.loginScreenRoute)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
