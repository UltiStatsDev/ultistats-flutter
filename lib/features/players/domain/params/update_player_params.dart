class UpdatePlayerParams {
  final String playerId;
  final String? firstName;
  final String? lastName;

  const UpdatePlayerParams({
    required this.playerId,
    this.firstName,
    this.lastName,
  });
}