import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/features/players/presentation/providers/edit_player_notifier.dart';
import 'package:ultistats/features/players/presentation/providers/players_list_notifier.dart';
import 'package:ultistats/features/players/presentation/providers/players_list_state.dart';

final playersListProvider =
    NotifierProvider<PlayersListNotifier, PlayersListState>(
      PlayersListNotifier.new,
    );

final editPlayerProvider =
    NotifierProvider<EditPlayerNotifier, EditPlayerState>(
      EditPlayerNotifier.new,
    );
