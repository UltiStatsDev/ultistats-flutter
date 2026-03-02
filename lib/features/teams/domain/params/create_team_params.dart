class CreateTeamParams {
  final String name;
  final List<String> playerIds;

  const CreateTeamParams({
    required this.name,
    required this.playerIds,
  });
}