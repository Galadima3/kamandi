// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamandi/src/features/notes/data/note_service.dart';

class AddNoteFAB extends ConsumerWidget {
  const AddNoteFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        showAdaptiveDialog(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text("Add a note"),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            children: [
              TextFormField(
                onFieldSubmitted: (value) async {
                  await ref.read(noteServiceProvider).createNote(
                    note: value,
                  );
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
