import 'package:flutter_riverpod/legacy.dart';
import '../models/team.dart';
import '../services/team/team_services.dart';

/// Team state class
class TeamState {
  final bool isLoading;
  final List<Team> teams;
  final String? error;

  TeamState({this.isLoading = false, this.teams = const [], this.error});

  TeamState copyWith({bool? isLoading, List<Team>? teams, String? error}) {
    return TeamState(
      isLoading: isLoading ?? this.isLoading,
      teams: teams ?? this.teams,
      error: error,
    );
  }
}

/// Team notifier for managing team state
class TeamNotifier extends StateNotifier<TeamState> {
  TeamNotifier(this._teamServices) : super(TeamState());

  final TeamServices _teamServices;
  String? _activeAsmId;

  Future<void> syncAsm(String? asmId) async {
    final nextAsmId = asmId?.trim();
    if (nextAsmId == null || nextAsmId.isEmpty) {
      _activeAsmId = null;
      state = TeamState();
      return;
    }

    if (_activeAsmId == nextAsmId &&
        (state.teams.isNotEmpty || state.isLoading)) {
      return;
    }

    _activeAsmId = nextAsmId;
    await loadTeamsByAsmId(nextAsmId);
  }

  Future<void> loadTeamsByAsmId(String asmId) async {
    final normalizedAsmId = asmId.trim();
    if (normalizedAsmId.isEmpty) {
      state = TeamState(error: 'ASM ID is required to load teams.');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final teams = await _teamServices.fetchTeamsByAsmId(normalizedAsmId);
      state = state.copyWith(isLoading: false, teams: teams, error: null);
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: _readErrorMessage(error),
        teams: const [],
      );
    }
  }

  /// Add team
  void addTeam(Team team) {
    final currentTeams = [...state.teams, team];
    state = state.copyWith(teams: currentTeams);
  }

  /// Update team
  void updateTeam(Team team) {
    final updatedTeams = state.teams
        .map((t) => t.id == team.id ? team : t)
        .toList();
    state = state.copyWith(teams: updatedTeams);
  }

  /// Delete team
  void deleteTeam(String teamId) {
    final filteredTeams = state.teams.where((t) => t.id != teamId).toList();
    state = state.copyWith(teams: filteredTeams);
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

  String _readErrorMessage(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }
    return message;
  }
}
