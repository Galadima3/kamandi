import 'dart:io';
import 'package:photo_gallery/photo_gallery.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
// import "package:images_picker/images_picker.dart";
import 'package:kamandi/src/features/auth/data/auth_repository.dart';
import 'package:kamandi/src/routing/route_paths.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final User? user; // Declare user as late to avoid initialization errors
  File? _selectedImage;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    user = ref.read(userDetailsProvider); // Read user data on initialization
  }

  @override
  Widget build(BuildContext context) {
    //final user = ref.watch(userDetailsProvider);
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
        child: Column(
          children: [
            Container(
              height: 100,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.blueAccent,
              ),
              child: Center(
                child: _selectedImage != null
                    ? Image.file(_selectedImage!, fit: BoxFit.contain,)
                    : const Text(
                        "No Image Selected",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            )
          ],
        ),
        // child: Text(
        //     'Home Page + ${user?.userMetadata?['displayName'] ?? "Unavailable"}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final XFile? pickedFile =
              await picker.pickImage(source: ImageSource.camera);
          // final pickedFile = await ImagesPicker.pick(
          //   count: 1,
          //   gif: true,

          // );

          if (pickedFile != null) {
            setState(() {
              _selectedImage = File(pickedFile.path);
              print(_selectedImage);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
