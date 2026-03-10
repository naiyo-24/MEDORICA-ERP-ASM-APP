import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/auth_notifier.dart';
import '../services/profile/auth_services.dart';

/// Provider for authentication state management
///
/// This provider manages the authentication state throughout the app.
/// Use this to access auth state and trigger login/logout actions.

final authServicesProvider = Provider<AuthServices>((ref) {
  return AuthServices();
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(authServicesProvider)),
);
