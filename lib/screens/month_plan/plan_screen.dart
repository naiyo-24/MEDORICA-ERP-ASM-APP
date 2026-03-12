import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/app_bar.dart';
import '../../theme/app_theme.dart';
import '../../providers/team_provider.dart';
import '../../providers/month_plan_provider.dart';
import '../../cards/month_plan/calendar_card.dart';
import '../../cards/month_plan/plan_card.dart';
import '../../models/team.dart';

class PlanScreen extends ConsumerStatefulWidget {
  const PlanScreen({super.key});

  @override
  ConsumerState<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends ConsumerState<PlanScreen> {
  String? _selectedMemberId;
  DateTime? _selectedDate;
  String? _lastLoadedMemberId;

  @override
  Widget build(BuildContext context) {
    final teams = ref.watch(allTeamsProvider);
    final isTeamsLoading = ref.watch(isTeamsLoadingProvider);
    final teamsError = ref.watch(teamErrorProvider);
    final members = _memberOptionsFromTeams(teams);
    final selectedId =
        _selectedMemberId ?? (members.isNotEmpty ? members.first.mrId : null);
    final monthPlanState = ref.watch(monthPlanNotifierProvider);

    if (selectedId != null && _lastLoadedMemberId != selectedId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _lastLoadedMemberId = selectedId;
        ref
            .read(monthPlanNotifierProvider.notifier)
            .setSelectedMember(selectedId);
      });
    }

    final plans = selectedId != null && _selectedDate != null
        ? ref.watch(
            monthPlanForMemberAndDateProvider({
              'memberId': selectedId,
              'date': _selectedDate,
            }),
          )
        : [];

    return Scaffold(
      appBar: const MRAppBar(
        showBack: true,
        showActions: false,
        titleText: 'Monthly Plan',
        subtitleText: 'View plans by team member',
      ),
      backgroundColor: AppColors.surface,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Team Member',
              ),
              hint: Text(
                isTeamsLoading
                    ? 'Loading team members...'
                    : members.isEmpty
                    ? 'No team members available'
                    : 'Choose a member',
              ),
              items: members
                  .map(
                    (m) => DropdownMenuItem(
                      value: m.mrId,
                      child: Text('${m.name} (${m.teamName})'),
                    ),
                  )
                  .toList(),
              initialValue: members.any((m) => m.mrId == selectedId)
                  ? selectedId
                  : null,
              onChanged: (v) {
                setState(() {
                  _selectedMemberId = v;
                  _selectedDate = null;
                });
                if (v != null && v.trim().isNotEmpty) {
                  _lastLoadedMemberId = v;
                  ref
                      .read(monthPlanNotifierProvider.notifier)
                      .loadPlansByMember(v, forceRefresh: true);
                }
              },
            ),
            if (teamsError != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  teamsError,
                  style: AppTypography.caption.copyWith(color: AppColors.error),
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            if (selectedId != null)
              CalendarCard(
                memberId: selectedId,
                onDateSelected: (d) => setState(() => _selectedDate = d),
              ),
            const SizedBox(height: AppSpacing.md),
            if (monthPlanState.isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else if (monthPlanState.error != null)
              Expanded(
                child: Center(
                  child: Text(
                    monthPlanState.error!,
                    style: AppTypography.description,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else if (_selectedDate == null)
              Text(
                'Tap a date on the calendar to view its plan',
                style: AppTypography.description,
              )
            else if (plans.isEmpty)
              Text(
                'No plans for selected date',
                style: AppTypography.description,
              )
            else
              Expanded(
                child: ListView(
                  children: plans.map((e) => PlanCard(entry: e)).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<_PlanMemberOption> _memberOptionsFromTeams(List<Team> teams) {
    final options = <_PlanMemberOption>[];
    for (final team in teams) {
      final teamId = (team.numericTeamId ?? int.tryParse(team.id) ?? 0)
          .toString();
      for (final member in team.teamMembers) {
        if (member.mrId.trim().isEmpty) {
          continue;
        }
        options.add(
          _PlanMemberOption(
            mrId: member.mrId.trim(),
            name: member.fullName.trim().isEmpty
                ? member.mrId.trim()
                : member.fullName.trim(),
            teamId: teamId,
            teamName: team.name.trim().isEmpty ? 'Team $teamId' : team.name,
          ),
        );
      }
    }
    return options;
  }
}

class _PlanMemberOption {
  final String mrId;
  final String name;
  final String teamId;
  final String teamName;

  const _PlanMemberOption({
    required this.mrId,
    required this.name,
    required this.teamId,
    required this.teamName,
  });
}
