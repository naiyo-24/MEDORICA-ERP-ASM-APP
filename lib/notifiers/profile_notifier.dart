import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import '../models/asm.dart';
import '../notifiers/auth_notifier.dart';
import '../services/profile/profile_services.dart';

/// Profile state class
class ProfileState {
  final bool isLoading;
  final ASM? profile;
  final String? error;

  ProfileState({this.isLoading = false, this.profile, this.error});

  ProfileState copyWith({bool? isLoading, ASM? profile, String? error}) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      error: error,
    );
  }
}

/// Profile notifier for managing profile state
class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier(this._profileServices) : super(ProfileState());

  final ProfileServices _profileServices;
  String? _asmId;

  /// Set profile data
  void setProfile(ASM profile) {
    _asmId = profile.asmId ?? _asmId ?? profile.id;
    state = state.copyWith(profile: profile, isLoading: false, error: null);
  }

  void syncAuthState(AuthState authState) {
    if (!authState.isAuthenticated || authState.asmId == null) {
      clearProfile();
      return;
    }

    _asmId = authState.asmId;
    if (authState.user != null && state.profile == null) {
      setProfile(authState.user!);
    }

    unawaited(loadProfile(authState.asmId!, forceRefresh: true));
  }

  Future<void> loadProfile(String asmId, {bool forceRefresh = false}) async {
    if (!forceRefresh &&
        _asmId == asmId &&
        state.profile != null &&
        !state.isLoading) {
      return;
    }

    _asmId = asmId;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final profile = await _profileServices.fetchProfile(asmId);
      _asmId = profile.asmId ?? asmId;
      state = state.copyWith(profile: profile, isLoading: false, error: null);
    } catch (error) {
      state = state.copyWith(isLoading: false, error: _readErrorMessage(error));
    }
  }

  Future<bool> refreshProfile() async {
    if (_asmId == null || _asmId!.isEmpty) {
      state = state.copyWith(error: 'No profile is available to refresh.');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final profile = await _profileServices.fetchProfile(_asmId!);
      _asmId = profile.asmId ?? _asmId;
      state = state.copyWith(profile: profile, isLoading: false, error: null);
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, error: _readErrorMessage(error));
      return false;
    }
  }

  /// Set loading state
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  /// Set error
  void setError(String error) {
    state = state.copyWith(error: error, isLoading: false);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Update profile
  Future<bool> updateProfile(
    ASM updatedProfile, {
    String? profileImagePath,
  }) async {
    final asmId = _asmId ?? updatedProfile.asmId ?? updatedProfile.id;
    if (asmId.isEmpty) {
      state = state.copyWith(error: 'Profile identifier is missing.');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final profile = await _profileServices.updateProfile(
        asmId: asmId,
        profile: updatedProfile,
        profileImagePath: profileImagePath,
      );
      _asmId = profile.asmId ?? asmId;
      state = state.copyWith(profile: profile, isLoading: false, error: null);
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, error: _readErrorMessage(error));
      return false;
    }
  }

  /// Clear profile
  void clearProfile() {
    _asmId = null;
    state = ProfileState();
  }

  String _readErrorMessage(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }
    return message;
  }
}
