class UpdatePlayerParams {
  final String playerId;
  final int? number;
  final String? firstName;
  final String? lastName;
  final String? teamId;

  const UpdatePlayerParams({
    required this.playerId,
    this.number,
    this.firstName,
    this.lastName,
    this.teamId,
  });
}