import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/team_member.dart';
import '../../widgets/app_bar.dart';
import '../../cards/team_member/team_member_card.dart';
import '../../providers/team_provider.dart';

class TeamMembersScreen extends ConsumerWidget {
  final String teamId;
  final String teamName;

  const TeamMembersScreen({
    super.key,
    required this.teamId,
    required this.teamName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isTeamsLoadingProvider);
    final team = ref.watch(teamByIdProvider(teamId));
    final error = ref.watch(teamErrorProvider);

    final teamMembers = (team?.teamMembers ?? const []).map((member) {
      return TeamMember(
        id: member.mrId,
        name: member.fullName,
        phone: member.phoneNo,
        altPhone: member.altPhoneNo,
        email: member.email,
        photoUrl: member.profilePhoto,
        headquarter: member.headquarterAssigned ?? '-',
        territories: member.territoriesOfWork,
        teamId: teamId,
      );
    }).toList();

    return Scaffold(
      appBar: MRAppBar(
        showBack: true,
        showActions: false,
        titleText: team?.name.isNotEmpty == true ? team!.name : teamName,
        subtitleText: '${teamMembers.length} members',
        onBack: () => context.pop(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null && error.isNotEmpty
          ? Center(child: Text(error))
          : team == null
          ? const Center(child: Text('Team not found'))
          : teamMembers.isEmpty
          ? const Center(child: Text('No team members available'))
          : ListView.builder(
              itemCount: teamMembers.length,
              itemBuilder: (context, index) {
                return TeamMemberCard(
                  member: teamMembers[index],
                  onTap: () {
                    context.push(
                      '/team-member-detail/${teamMembers[index].id}',
                      extra: teamMembers[index],
                    );
                  },
                );
              },
            ),
    );
  }
}
