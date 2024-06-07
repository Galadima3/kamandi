// ignore_for_file: use_build_context_synchronously

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kamandi/src/features/auth/data/auth_repository.dart';
import 'package:kamandi/src/features/auth/presentation/screens/login_screen.dart';
import 'package:kamandi/src/features/auth/presentation/widgets/custom_snackbar.dart';
import 'package:kamandi/src/features/auth/presentation/widgets/fancy_auth_button.dart';
import 'package:kamandi/src/routing/route_paths.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final isPasswordVisibleProviderX = StateProvider<bool>((ref) => true);
final isLoadingProviderX = StateProvider<bool>((ref) => false);

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final displayNameController = TextEditingController();
  final emailFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();
  String phoneNumber = '';

  Future<void> onRegister(
      {required String email,
      required String password,
      required String phoneNumber,
      required String displayName,
      required WidgetRef ref}) async {
    if (emailFormKey.currentState!.validate() &&
        passwordFormKey.currentState!.validate()) {
      try {
        ref.read(isLoadingProviderX.notifier).update((state) => true);
        final user = await ref
            .read(supabaseAuthProvider)
            .signUpEmailAndPassword(
                email: email,
                password: password,
                phoneNumber: phoneNumber,
                displayName: displayName);

        ref.read(isLoadingProvider.notifier).update((state) => false);

        if (user != null) {
          context.pushReplacementNamed(RoutePaths.homeScreenRoute);
        }
      } on AuthException catch (error) {
        ref.read(isLoadingProviderX.notifier).update((state) => false);
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar(context, error.message));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final isLoading = ref.watch(isLoadingProviderX);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.045.h,
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
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.035.h),
            //Phone Number
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
              child: IntlPhoneField(
                disableLengthCheck: true,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                initialCountryCode: 'NG',
                onChanged: (phone) {
                  setState(() => phoneNumber = phone.completeNumber);
                },
              ),
            ),
            SizedBox(height: height * 0.035.h),

            //Display Name
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.name,
                controller: displayNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Can\'t be empty';
                  }
                  if (value.length < 4) {
                    return 'Username is too short';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Username',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.035.h),
            //password
            Form(
              key: passwordFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Consumer(
                  builder: (context, ref, child) {
                    final isPasswordVisible =
                        ref.watch(isPasswordVisibleProviderX);
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
                                  .read(isPasswordVisibleProviderX.notifier)
                                  .state = !isPasswordVisible;
                            },
                            icon: Icon(isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                if (emailFormKey.currentState!.validate() &&
                    passwordFormKey.currentState!.validate()) {
                  onRegister(
                      email: emailController.text,
                      password: passwordController.text,
                      phoneNumber: phoneNumber,
                      displayName: displayNameController.text,
                      ref: ref);
                }
              },
              child: FancyAuthButton(
                inputW: isLoading
                    ? Transform.scale(
                        scale: 0.5,
                        child: const CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.white,
                        ),
                      )
                    : Text(
                        "Register",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp),
                      ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Are you registered already?",
                  //style: kStyle1,
                ),
                SizedBox(width: 3.5.w),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return const LoginScreen();
                      },
                    ));
                  },
                  child: const Text(
                    "Sign in",
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

extension CustomPadding on Widget {
  Widget withPadding(EdgeInsets padding) {
    return Padding(
      padding: padding,
      child: this,
    );
  }
}
