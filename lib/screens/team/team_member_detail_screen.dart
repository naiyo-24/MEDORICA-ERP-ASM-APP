import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../models/team_member.dart';
import '../../widgets/app_bar.dart';
import '../../cards/team_member/team_member_header_card.dart';
import '../../cards/team_member/team_member_contact_card.dart';
import '../../cards/team_member/team_member_work_area_card.dart';

class TeamMemberDetailScreen extends StatelessWidget {
  final TeamMember member;

  const TeamMemberDetailScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: MRAppBar(
        showBack: true,
        showActions: false,
        titleText: member.name,
        subtitleText: member.phone,
        onBack: () => context.pop(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card with member photo
            TeamMemberHeaderCard(member: member),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPaddingHorizontal,
              ),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.md),
                  // Contact Information Card
                  TeamMemberContactCard(member: member),
                  const SizedBox(height: AppSpacing.md),
                  // Work Area Card
                  TeamMemberWorkAreaCard(member: member),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
