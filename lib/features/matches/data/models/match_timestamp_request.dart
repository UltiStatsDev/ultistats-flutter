import 'package:json_annotation/json_annotation.dart';

part 'match_timestamp_request.g.dart';

@JsonSerializable()
class MatchTimestampRequest {
  final String timestamp;

  const MatchTimestampRequest({required this.timestamp});

  factory MatchTimestampRequest.fromDateTime(DateTime date) =>
      MatchTimestampRequest(timestamp: date.toIso8601String());

  Map<String, dynamic> toJson() => _$MatchTimestampRequestToJson(this);
}
