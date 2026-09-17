enum ParticipantKind {
  player,
  unknown;

  static ParticipantKind parse(String kind) {
    return switch (kind.toUpperCase()) {
      'PLAYER' => ParticipantKind.player,
      'UNKNOWN' => ParticipantKind.unknown,
      _ => ParticipantKind.unknown,
    };
  }
}

class MatchParticipant {
  final String participantId;
  final ParticipantKind kind;
  final String? firstName;
  final String? lastName;
  final String displayName;
  final int? number;

  const MatchParticipant({
    required this.participantId,
    required this.kind,
    required this.firstName,
    required this.lastName,
    required this.displayName,
    required this.number,
  });
}
