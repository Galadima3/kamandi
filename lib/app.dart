import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kamandi/src/features/chat/chat_screen.dart';
import 'package:kamandi/src/features/gallery/home_screen.dart';
import 'package:kamandi/src/features/notes/presentation/screens/note_screen.dart';

final bottomNavbarIndexProvider = StateProvider<int>((ref) => 0);

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomNavBarIndex = ref.watch(bottomNavbarIndexProvider);
    List<Widget> screens = const [
      HomeScreen(),
      NoteScreen(),
      ChatScreen(),
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomNavBarIndex,
        onTap: (value) => ref
            .read(bottomNavbarIndexProvider.notifier)
            .update((state) => value),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.note_add), label: 'Note'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chat'),
        ],
      
      ),
      body: screens[bottomNavBarIndex],
    );
  }
}
