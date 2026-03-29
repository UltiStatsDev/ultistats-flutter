import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_colors.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/app_refreshing_indicator.dart';
import 'package:ultistats/core/widgets/error_screen.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/core/widgets/search_filter_bar.dart';
import 'package:ultistats/features/matches/presentation/providers/matches_list_state.dart';
import 'package:ultistats/features/matches/presentation/providers/matches_providers.dart';
import 'package:ultistats/features/matches/presentation/widgets/match_card.dart';
import 'package:ultistats/features/matches/presentation/widgets/no_matches_widget.dart';

@RoutePage()
class MatchesListScreen extends ConsumerStatefulWidget {
  const MatchesListScreen({super.key});

  @override
  ConsumerState<MatchesListScreen> createState() => _MatchesListScreenState();
}

class _MatchesListScreenState extends ConsumerState<MatchesListScreen> {
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
    final state = ref.read(matchesListProvider);
    if (state is MatchesListLoaded && !state.isLoadingMore && _isNearBottom) {
      ref.read(matchesListProvider.notifier).loadMore();
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
    final state = ref.watch(matchesListProvider);

    return ScreenWrapper(
      child: switch (state) {
        MatchesListLoading() => const Center(child: CircularProgressIndicator()),
        MatchesListError(:final exception, :final stackTrace) => ErrorScreen(
            exception: exception,
            stackTrace: stackTrace,
            onRetry: () => ref.read(matchesListProvider.notifier).loadInitial(),
          ),
        MatchesListLoaded(:final matches) when matches.isEmpty => const NoMatchesWidget(),
        MatchesListLoaded() => _buildBody(theme, state),
      },
    );
  }

  Widget _buildBody(ThemeData theme, MatchesListLoaded state) {
    return Stack(
      children: [
        Column(
          children: [
            const SearchFilterBar(),
            const SizedBox(height: 5),
            Expanded(
              child: AppRefreshingIndicator(
                onRefresh: () => ref.read(matchesListProvider.notifier).refresh(),
                child: ListView.separated(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: theme.screenPadding, top: 5),
                  itemCount: state.matches.length + (state.hasReachedEnd ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index >= state.matches.length) {
                      return _buildLoadingIndicator(state.isLoadingMore);
                    }
                    return MatchCard(
                      match: state.matches[index],
                      onPressed: () {},
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
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
