import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/team_notifier.dart';
import '../models/team.dart';
import '../services/team/team_services.dart';
import 'auth_provider.dart';

final teamServicesProvider = Provider<TeamServices>((ref) {
  return TeamServices();
});

/// Provider for team state management
final teamNotifierProvider = StateNotifierProvider<TeamNotifier, TeamState>((
  ref,
) {
  final notifier = TeamNotifier(ref.read(teamServicesProvider));

  ref.listen(authNotifierProvider, (previous, next) {
    if (!next.isAuthenticated || next.asmId == null) {
      notifier.syncAsm(null);
      return;
    }

    notifier.syncAsm(next.asmId);
  }, fireImmediately: true);

  return notifier;
});

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

final teamByIdProvider = Provider.family<Team?, String>((ref, teamId) {
  final teams = ref.watch(allTeamsProvider);
  for (final team in teams) {
    if (team.id == teamId) {
      return team;
    }
  }
  return null;
});
