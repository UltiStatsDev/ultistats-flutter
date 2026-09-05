import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_colors.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/app_refreshing_indicator.dart';
import 'package:ultistats/features/players/presentation/providers/players_list_notifier.dart';
import 'package:ultistats/features/players/presentation/providers/players_list_state.dart';
import 'package:ultistats/features/players/presentation/screens/edit_player_screen.dart';
import 'package:ultistats/features/players/presentation/screens/player_detail_screen.dart';
import 'package:ultistats/features/players/presentation/widgets/players_list/player_card.dart';
import 'package:ultistats/router/app_router.gr.dart';

class PlayersListWidget extends ConsumerStatefulWidget {
  const PlayersListWidget({super.key, required this.state});

  final PlayersListLoaded state;

  @override
  ConsumerState<PlayersListWidget> createState() => _PlayersListWidgetState();
}

class _PlayersListWidgetState extends ConsumerState<PlayersListWidget> {
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
    ref.read(playersListProvider.notifier).onScrollUpdate(
          _scrollController.offset,
          _scrollController.position.maxScrollExtent,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        AppRefreshingIndicator(
          onRefresh: () => ref.read(playersListProvider.notifier).refresh(),
          child: ListView.separated(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: theme.screenPadding + 80, top: 5),
            itemCount: widget.state.players.length + (widget.state.hasReachedEnd ? 0 : 1),
            itemBuilder: (context, index) {
              if (index >= widget.state.players.length) {
                return _buildLoadingIndicator(widget.state.isLoadingMore);
              }
              final player = widget.state.players[index];
              return PlayerCard(
                player: player,
                onPressed: () {
                  context.router.push(PlayerDetailRoute(playerId: player.id));
                },
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12),
          ),
        ),
        Positioned(
          right: 19 - theme.screenPadding,
          bottom: 24,
          child: FloatingActionButton(
            onPressed: () {
              context.router.push(
                EditPlayerRoute(
                  title: "Создание игрока",
                  confirmButtonText: "Создать игрока",
                  initialData: const EditPlayerScreenInitial(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 12,
          child: _listGradient(),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: isLoading ? const CircularProgressIndicator() : const SizedBox.shrink(),
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
