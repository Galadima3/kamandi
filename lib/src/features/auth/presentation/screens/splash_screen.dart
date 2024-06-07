import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kamandi/src/routing/route_paths.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final vizier = Supabase.instance.client.auth.currentSession;
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 3000), () {
      final session = Supabase.instance.client.auth.currentSession;

      if (session == null) {
        // context.pushReplacementNamed(RoutePaths.loginScreenRoute);
        context.pushReplacementNamed(RoutePaths.landingScreenRoute);
      } else {
        // context.pushReplacementNamed(RoutePaths.homeScreenRoute);
        context.pushReplacementNamed(RoutePaths.appScreenRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Image.asset(
            'assets/images/tank.png'
            
            ,
            height: 300.h,
            width: 200.w,
          )),
    );
  }
}
