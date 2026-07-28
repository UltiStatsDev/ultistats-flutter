import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/matches/domain/entities/match_event.dart';
import 'package:ultistats/features/matches/domain/params/create_event_params.dart';

part 'create_event_request.g.dart';

@JsonSerializable(includeIfNull: false)
class CreateEventRequest {
  final DateTime occurredAt;

  const CreateEventRequest({required this.occurredAt});

  Map<String, dynamic> toJson() => _$CreateEventRequestToJson(this);

  factory CreateEventRequest.fromParams(CreateEventParams params) {
    return CreateEventRequest(occurredAt: params.occurredAt);
  }
}
