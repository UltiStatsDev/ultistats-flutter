import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/match_game/data/match_event_queue.dart';

/// Очередь отправки событий живёт вне notifier-а матча, чтобы неотправленные
/// события не терялись при пересоздании экрана.
final matchEventQueueProvider = Provider<MatchEventQueue>((ref) {
  return MatchEventQueue(ref.read(matchEventsRepositoryProvider));
});
