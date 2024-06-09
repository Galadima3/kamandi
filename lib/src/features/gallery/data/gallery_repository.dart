import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class GalleryRepository {
  final supabase = Supabase.instance.client.storage;

  Future<void> uploadImage(File imageFile, String path) async {
    await supabase
        .from('gallery') // Replace with your storage bucket name
        .upload(path, imageFile);
  }

  // Read all images
}
