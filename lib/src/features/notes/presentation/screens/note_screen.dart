// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kamandi/src/features/notes/data/note_service.dart';
import 'package:kamandi/src/features/notes/domain/note_model.dart';
import 'package:kamandi/src/features/notes/presentation/widgets/add_note_fab.dart';

import 'package:kamandi/src/features/notes/presentation/widgets/dimissable_note_item.dart';

class NoteScreen extends ConsumerStatefulWidget {
  const NoteScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(allNotesProvider);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: notes.when(
            data: (notesData) => ListView.builder(
              itemCount: notesData.length,
              itemBuilder: (context, index) {
                
                return DismissibleNoteItem(note: Note.fromMap(notesData[index]));
              },
            ),
            error: (error, _) => Text('Error: $error'),
            loading: () => const CircularProgressIndicator.adaptive(),
          ),
        ),
        floatingActionButton: const AddNoteFAB());
  }
}
