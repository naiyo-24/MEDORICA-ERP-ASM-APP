import 'package:flutter_riverpod/legacy.dart';
import '../models/asm.dart';
import '../services/profile/auth_services.dart';

/// Authentication state class
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final ASM? user;
  final String? asmId;
  final String? error;

  AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.user,
    this.asmId,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    ASM? user,
    String? asmId,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      asmId: asmId ?? this.asmId,
      error: error,
    );
  }
}

/// Authentication notifier for managing auth state
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authServices) : super(AuthState());

  final AuthServices _authServices;

  /// Login with phone number and password
  Future<void> login(String phone, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final trimmedPhone = phone.trim();
      if (trimmedPhone.isEmpty) {
        state = AuthState(error: 'Phone number is required.');
        return;
      }

      if (password.isEmpty) {
        state = AuthState(error: 'Password is required.');
        return;
      }

      final user = await _authServices.login(
        phone: trimmedPhone,
        password: password,
      );
      final asmId = user.asmId ?? user.id;

      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        user: user,
        asmId: asmId,
        error: null,
      );
    } catch (error) {
      state = AuthState(error: _readErrorMessage(error));
    }
  }

  void syncAuthenticatedUser(ASM profile) {
    state = state.copyWith(
      isAuthenticated: true,
      isLoading: false,
      user: profile,
      asmId: profile.asmId ?? profile.id,
      error: null,
    );
  }

  /// Logout current user
  void logout() {
    state = AuthState();
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Check if user is authenticated
  bool get isAuthenticated => state.isAuthenticated;

  /// Get current user
  ASM? get currentUser => state.user;

  String _readErrorMessage(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }
    return message;
  }
}
