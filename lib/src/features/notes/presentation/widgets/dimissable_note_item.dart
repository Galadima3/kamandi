// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamandi/src/features/notes/data/note_service.dart';
import 'package:kamandi/src/features/notes/domain/note_model.dart';
import 'package:kamandi/src/features/notes/presentation/widgets/dismissible_theming.dart';

class DismissibleNoteItem extends ConsumerWidget {
  final Note note;
  

  const DismissibleNoteItem({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(note.id.toString()),
      background: slideRightBackground(),
      secondaryBackground: slideLeftBackground(),
      confirmDismiss: (direction) => _handleDismiss(context, direction, ref, note),
      child: Card(
        child: ListTile(
          title: Text(note.body),
        ),
      ),
    );
  }

  Future<bool?> _handleDismiss(BuildContext context, DismissDirection direction, WidgetRef ref, Note note) async {
    if (direction == DismissDirection.endToStart) {
      return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text("Are you sure you want to delete this item?"),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel", style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text("Delete", style: TextStyle(color: Colors.red)),
                onPressed: () async {
                  await ref.read(noteServiceProvider).deleteNote(
                    noteID: note.id,
                  );
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );
    } else {
      showAdaptiveDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text("Edit a note"),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            TextFormField(
              initialValue: note.body,
              onFieldSubmitted: (value) async {
                await ref.read(noteServiceProvider).updateNote(
                  noteID: note.id,
                  updatedNote: value,
                );
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    }
    return null;
  }
}

