import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/matches/domain/entities/match_participant.dart';

part 'match_participant_model.g.dart';

@JsonSerializable()
class MatchParticipantModel {
  final String participantId;
  final String kind;
  final String? firstName;
  final String? lastName;
  final String displayName;
  final int? number;

  const MatchParticipantModel({
    required this.participantId,
    required this.kind,
    required this.firstName,
    required this.lastName,
    required this.displayName,
    required this.number,
  });

  factory MatchParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$MatchParticipantModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchParticipantModelToJson(this);

  MatchParticipant toEntity() {
    return MatchParticipant(
      participantId: participantId,
      kind: ParticipantKind.parse(kind),
      firstName: firstName,
      lastName: lastName,
      displayName: displayName,
      number: number,
    );
  }
}
