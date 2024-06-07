import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SupabaseAuthRepository {
  final Supabase _supabase = Supabase.instance;

  //getter
  User? get userDetails => _supabase.client.auth.currentUser;

  Future<User?> signInEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.client.auth
        .signInWithPassword(password: password, email: email);
    return response.user;
  }

  Future<void> signOut() async {
    await _supabase.client.auth.signOut();
  }

  Future<AuthResponse?> signUpEmailAndPassword(
      {required String email,
      required String password,
      required String phoneNumber,
      required String displayName}) async {
    final rex = await _supabase.client.auth
        .signUp(password: password, email: email, data: {
      'phoneNumber': phoneNumber,
      'displayName': displayName,
    });
    return rex;
  }
}

final supabaseAuthProvider = Provider<SupabaseAuthRepository>((ref) {
  return SupabaseAuthRepository();
});
final userDetailsProvider = Provider.autoDispose<User?>((ref) {
  return ref.read(supabaseAuthProvider).userDetails;
});
