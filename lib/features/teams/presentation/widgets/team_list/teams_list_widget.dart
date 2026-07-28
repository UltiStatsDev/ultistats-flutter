import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_colors.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/app_refreshing_indicator.dart';
import 'package:ultistats/core/widgets/search_filter_bar.dart';
import 'package:ultistats/features/teams/presentation/providers/teams_list_notifier.dart';
import 'package:ultistats/features/teams/presentation/providers/teams_list_state.dart';
import 'package:ultistats/features/teams/presentation/screens/edit_team_screen.dart';
import 'package:ultistats/features/teams/presentation/widgets/team_list/team_card.dart';
import 'package:ultistats/router/app_router.gr.dart';

class TeamsListWidget extends ConsumerStatefulWidget {
  const TeamsListWidget({super.key, required this.state});

  final TeamsListLoaded state;

  @override
  ConsumerState<TeamsListWidget> createState() => _TeamsListWidgetState();
}

class _TeamsListWidgetState extends ConsumerState<TeamsListWidget> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    ref
        .read(teamsListProvider.notifier)
        .onScrollUpdate(
          _scrollController.offset,
          _scrollController.position.maxScrollExtent,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Column(
          children: [
            const SearchFilterBar(),
            const SizedBox(height: 5),
            Expanded(
              child: AppRefreshingIndicator(
                onRefresh: () => ref.read(teamsListProvider.notifier).refresh(),
                child: ListView.separated(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: theme.screenPadding, top: 5),
                  itemCount:
                      widget.state.teams.length +
                      (widget.state.hasReachedEnd ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index >= widget.state.teams.length) {
                      return _buildLoadingIndicator(widget.state.isLoadingMore);
                    }
                    return TeamCard(
                      team: widget.state.teams[index],
                      onPressed: () {},
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          right: 19 - theme.screenPadding,
          bottom: 24,
          child: FloatingActionButton(
            onPressed: () {
              context.router.push(
                EditTeamRoute(
                  title: "Создание команды",
                  confirmButtonText: "Создать команду",
                  initialData: EditTeamScreenInitial(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
        Positioned(
          top: theme.searchBarSize + 4.5,
          left: 0,
          right: 0,
          height: 8,
          child: _listGradient(),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _listGradient() {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.purple, AppColors.purple.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}
