// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kamandi/src/features/auth/data/auth_repository.dart';
import 'package:kamandi/src/features/auth/presentation/screens/register_screen.dart';
import 'package:kamandi/src/features/auth/presentation/widgets/custom_snackbar.dart';
import 'package:kamandi/src/features/auth/presentation/widgets/fancy_auth_button.dart';
import 'package:kamandi/src/routing/route_paths.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final isPasswordVisibleProvider = StateProvider<bool>((ref) => true);
final isLoadingProvider = StateProvider<bool>((ref) => false);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();

  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session != null && session.user.id.isNotEmpty) {
        context.pushReplacementNamed(RoutePaths.appScreenRoute);
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _authSubscription.cancel();
    super.dispose();
  }

  Future<void> onLogin(
      {required String email,
      required String password,
      required WidgetRef ref,
      required BuildContext context}) async {
    if (emailFormKey.currentState!.validate() &&
        passwordFormKey.currentState!.validate()) {
      try {
        ref.read(isLoadingProvider.notifier).update((state) => true);

        await ref.read(supabaseAuthProvider).signInEmailAndPassword(
              email: email,
              password: password,
            );

        ref.read(isLoadingProvider.notifier).update((state) => false);
      } on AuthException catch (error) {
        ref.read(isLoadingProvider.notifier).update((state) => false);
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar(context, error.message));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height * 0.045.h),

            Image.asset(
              'assets/images/tank.png',
              width: 200.w,
              height: 200.h,
            ),
            SizedBox(
              height: height * 0.05.h,
            ),
            //email
            Form(
              key: emailFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: emailController,
                  validator: (value) => EmailValidator.validate(value!)
                      ? null
                      : "Please enter a valid email",
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.035.h,
            ),
            //password
            Form(
              key: passwordFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Consumer(
                  builder: (context, ref, child) {
                    final isPasswordVisible =
                        ref.watch(isPasswordVisibleProvider);
                    return TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: isPasswordVisible,
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) => value!.length > 6
                          ? null
                          : "Password should be more than 6 characters",
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: IconButton(
                            onPressed: () {
                              ref
                                  .read(isPasswordVisibleProvider.notifier)
                                  .state = !isPasswordVisible;
                            },
                            icon: Icon(isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            Consumer(
              builder: (context, ref, child) {
                final isLoading = ref.watch(isLoadingProvider);
                return GestureDetector(
                  onTap: () => onLogin(
                      email: emailController.text,
                      password: passwordController.text,
                      context: context,
                      ref: ref),
                  child: FancyAuthButton(
                    inputW: isLoading
                        ? Transform.scale(
                            scale: 0.5,
                            child: const CircularProgressIndicator.adaptive(
                              backgroundColor: Colors.white,
                            ),
                          )
                        : Text(
                            "Log in",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp),
                          ),
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  // style: kStyle1,
                ),
                SizedBox(width: 3.5.w),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return const RegisterScreen();
                      },
                    ));
                  },
                  child: const Text(
                    "Sign up",
                    //style: kStyle2,
                  ),
                )
              ],
            ).withPadding(const EdgeInsets.only(top: 10)),
          ],
        ),
      ),
    );
  }
}
