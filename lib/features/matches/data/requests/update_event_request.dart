import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/matches/domain/entities/event.dart';
import 'package:ultistats/features/matches/domain/params/update_event_params.dart';

part 'update_event_request.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdateEventRequest {
  final EventType type;

  const UpdateEventRequest({required this.type});

  Map<String, dynamic> toJson() => _$UpdateEventRequestToJson(this);

  factory UpdateEventRequest.fromParams(UpdateEventParams params) {
    return UpdateEventRequest(type: params.type);
  }
}
