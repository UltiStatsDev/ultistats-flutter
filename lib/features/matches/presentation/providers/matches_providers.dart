import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/features/matches/presentation/providers/matches_list_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/matches_list_state.dart';

final matchesListProvider =
    NotifierProvider<MatchesListNotifier, MatchesListState>(MatchesListNotifier.new);
