class CreateTeamParams {
  final String name;
  final List<String> playerIds;
  final String? city;

  const CreateTeamParams({
    required this.name,
    required this.playerIds,
    this.city,
  });
}