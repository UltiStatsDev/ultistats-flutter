import 'package:ultistats/features/matches/domain/entities/event.dart';

class UpdateEventParams {
  final String matchId;
  final String eventId;
  final EventType type;

  const UpdateEventParams({
    required this.matchId,
    required this.eventId,
    required this.type,
  });
}
