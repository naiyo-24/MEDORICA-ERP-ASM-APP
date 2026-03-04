import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/team_notifier.dart';
import '../models/team.dart';

/// Provider for team state management
final teamNotifierProvider = StateNotifierProvider<TeamNotifier, TeamState>(
  (ref) => TeamNotifier(),
);

/// Computed provider for getting all teams
final allTeamsProvider = Provider<List<Team>>((ref) {
  return ref.watch(teamNotifierProvider).teams;
});

/// Computed provider for checking if teams are loading
final isTeamsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(teamNotifierProvider).isLoading;
});

/// Computed provider for getting team error
final teamErrorProvider = Provider<String?>((ref) {
  return ref.watch(teamNotifierProvider).error;
});
