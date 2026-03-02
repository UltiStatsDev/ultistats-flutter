class UpdateTeamParams {
  final String teamId;
  final String? name;
  final List<String>? playerIds;

  const UpdateTeamParams({
    required this.teamId,
    this.name,
    this.playerIds,
  });
}