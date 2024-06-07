import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kamandi/src/constants/api_keys.dart';
import 'package:kamandi/src/features/auth/data/auth_repository.dart';
import 'package:kamandi/src/routing/app_router.dart';
import 'package:kamandi/src/routing/route_paths.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Keys.url,
    anonKey: Keys.anonKey,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
// This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 867),
      minTextAdapt: false,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Kamandi',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: GoogleFonts.urbanist().fontFamily,
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFF31A1DC)),
            useMaterial3: true,
          ),
          routerConfig: appRouter,
        );
      },
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final User? user; // Declare user as late to avoid initialization errors

  @override
  void initState() {
    super.initState();
    user = ref.read(userDetailsProvider); // Read user data on initialization
  }

  @override
  Widget build(BuildContext context) {
    //final user = ref.watch(userDetailsProvider);

    // Access and potentially modify your internal state variables here

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                ref.read(supabaseAuthProvider).signOut().then((_) =>
                    context.pushReplacementNamed(RoutePaths.loginScreenRoute));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Text(
            'Home Page + ${user?.userMetadata?['displayName'] ?? "Unavailable"}'),
      ),
    );
  }
}
