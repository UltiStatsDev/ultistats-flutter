import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/app_refreshing_indicator.dart';
import 'package:ultistats/core/widgets/error_screen.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/features/teams/presentation/providers/teams_list_state.dart';
import 'package:ultistats/features/teams/presentation/providers/teams_providers.dart';
import 'package:ultistats/features/teams/presentation/widgets/no_teams_widget.dart';
import 'package:ultistats/features/teams/presentation/widgets/team_card.dart';

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

    return ScreenWrapper(
      child: Stack(
        children: [
          _buildContent(theme),
          Positioned(
            right: 19 - theme.screenPadding,
            bottom: 24,
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    final state = ref.watch(teamsListProvider);

    return switch (state) {
      TeamsListLoading() => const Center(child: CircularProgressIndicator()),
      TeamsListError(:final exception, :final stackTrace) => ErrorScreen(
          exception: exception,
          stackTrace: stackTrace,
          onRetry: () => ref.read(teamsListProvider.notifier).loadInitial(),
        ),
      TeamsListLoaded(:final teams) when teams.isEmpty => NoTeamsWidget(),
      TeamsListLoaded() => _buildList(theme, state),
    };
  }

  Widget _buildList(ThemeData theme, TeamsListLoaded state) {
    return AppRefreshingIndicator(
      onRefresh: () => ref.read(teamsListProvider.notifier).refresh(),
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: theme.screenPadding),
        itemCount: state.teams.length + (state.hasReachedEnd ? 0 : 1),
        itemBuilder: (context, index) {
          if (index >= state.teams.length) {
            return _buildLoadingIndicator(state.isLoadingMore);
          }
          return TeamCard(team: state.teams[index], onPressed: () {});
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
      ),
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
