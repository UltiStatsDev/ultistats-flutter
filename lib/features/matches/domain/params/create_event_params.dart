import 'package:ultistats/features/matches/domain/entities/event.dart';

class CreateEventParams {
  final String matchId;
  final Event event;

  const CreateEventParams({required this.matchId, required this.event});
}
