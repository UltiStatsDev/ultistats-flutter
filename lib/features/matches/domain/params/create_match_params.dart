class CreateMatchParams {
  final List<String> teamIds;
  final DateTime? plannedStartTimestamp;
  final int playersPerTeam;

  const CreateMatchParams({
    required this.teamIds,
    required this.playersPerTeam,
    this.plannedStartTimestamp,
  });
}