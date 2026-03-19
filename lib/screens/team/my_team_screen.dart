import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_bar.dart';
import '../../cards/team/team_card.dart';
import '../../providers/team_provider.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../routes/app_router.dart';
import '../../widgets/loader.dart';

class MyTeamScreen extends ConsumerWidget {
  const MyTeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teams = ref.watch(allTeamsProvider);
    final isLoading = ref.watch(isTeamsLoadingProvider);
    final error = ref.watch(teamErrorProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(AppRouter.home);
        }
      },
      child: Scaffold(
        appBar: MRAppBar(
          showBack: false,
          showActions: false,
          titleText: 'My Team',
          subtitleText: 'Manage your sales teams',
        ),
        body: isLoading
            ? const Center(
                child: Loader(
                  text: 'Loading teams...',
                  logoSize: 36.0,
                  backgroundColor: Colors.transparent,
                ),
              )
            : error != null && error.isNotEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(error, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          final asmId = ref.read(authNotifierProvider).asmId;
                          if (asmId != null && asmId.trim().isNotEmpty) {
                            ref
                                .read(teamNotifierProvider.notifier)
                                .loadTeamsByAsmId(asmId);
                          }
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            : teams.isEmpty
            ? const Center(child: Text('No teams available'))
            : ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context, index) {
                  return TeamCard(
                    team: teams[index],
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${teams[index].name} selected'),
                        ),
                      );
                    },
                  );
                },
              ),
        bottomNavigationBar: const MRBottomNavBar(currentIndex: 1),
      ),
    );
  }
}
