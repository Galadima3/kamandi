import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NoteService {
  final supabase = Supabase.instance.client;

  // Create notes
  Future<void> createNote({required note}) async {
    await supabase.from('notes').insert({'body': note});
  }

  // Read Notes
  Stream<List<Map<String, dynamic>>> get getAllNotes =>
      supabase.from('notes').stream(primaryKey: ['id']);

  // Update Note
  Future<void> updateNote(
      {required noteID, required String updatedNote}) async {
    await supabase.from('notes').update({'body': updatedNote}).eq('id', noteID);
  }

  // Delete Notes
  Future<void> deleteNote({required noteID}) async {
    await supabase.from('notes').delete().eq('id', noteID);
  }
}

final noteServiceProvider = Provider<NoteService>((ref) {
  return NoteService();
});

final allNotesProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final notes = ref.read(noteServiceProvider);
  return notes.getAllNotes;
});
