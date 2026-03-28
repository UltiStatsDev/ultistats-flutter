import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/features/teams/presentation/providers/teams_list_notifier.dart';
import 'package:ultistats/features/teams/presentation/providers/teams_list_state.dart';

final teamsListProvider =
    NotifierProvider<TeamsListNotifier, TeamsListState>(TeamsListNotifier.new);
