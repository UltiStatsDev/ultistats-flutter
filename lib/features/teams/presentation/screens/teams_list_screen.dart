import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_colors.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/app_refreshing_indicator.dart';
import 'package:ultistats/core/widgets/error_screen.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/features/teams/presentation/providers/teams_list_state.dart';
import 'package:ultistats/features/teams/presentation/providers/teams_providers.dart';
import 'package:ultistats/features/teams/presentation/widgets/no_teams_widget.dart';
import 'package:ultistats/features/teams/presentation/widgets/team_card.dart';
import 'package:ultistats/features/teams/presentation/widgets/search_filter_bar.dart';

@RoutePage()
class TeamsListScreen extends ConsumerStatefulWidget {
  const TeamsListScreen({super.key});

  @override
  ConsumerState<TeamsListScreen> createState() => _TeamsListScreenState();
}

class _TeamsListScreenState extends ConsumerState<TeamsListScreen> {
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
    final state = ref.read(teamsListProvider);
    if (state is TeamsListLoaded && !state.isLoadingMore && _isNearBottom) {
      ref.read(teamsListProvider.notifier).loadMore();
    }
  }

  bool get _isNearBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(teamsListProvider);
    return ScreenWrapper(
      child: switch (state) {
        TeamsListLoading() => const Center(child: CircularProgressIndicator()),
        TeamsListError(:final exception, :final stackTrace) => ErrorScreen(
          exception: exception,
          stackTrace: stackTrace,
          onRetry: () => ref.read(teamsListProvider.notifier).loadInitial(),
        ),
        TeamsListLoaded(:final teams) when teams.isEmpty => NoTeamsWidget(),
        TeamsListLoaded() => _buildBody(theme, state),
      },
    );
  }

  Widget _buildBody(ThemeData theme, TeamsListLoaded state) {
    return Stack(
      children: [
        Column(
          children: [
            SearchFilterBar(),
            SizedBox(height: 5),
            Expanded(
              child: AppRefreshingIndicator(
                onRefresh: () => ref.read(teamsListProvider.notifier).refresh(),
                child: ListView.separated(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: theme.screenPadding, top: 5),
                  itemCount: state.teams.length + (state.hasReachedEnd ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index >= state.teams.length) {
                      return _buildLoadingIndicator(state.isLoadingMore);
                    }
                    return TeamCard(team: state.teams[index], onPressed: () {});
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
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ),
        Positioned(
          top: theme.searchBarSize + 4.5,
          left: 0,
          right: 0,
          height: 8,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.purple,
                    AppColors.purple.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
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
}
