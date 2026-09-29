import 'package:ultistats/features/matches/domain/entities/match_event.dart';

class CreateEventParams {
  final String matchId;
  final Event event;

  const CreateEventParams({required this.matchId, required this.event});
}
