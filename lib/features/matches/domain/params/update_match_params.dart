class UpdateMatchParams {
  final String matchId;
  final List<String>? teamIds;
  final DateTime? plannedStartTimestamp;
  final int? playersPerTeam;

  const UpdateMatchParams({
    required this.matchId,
    this.teamIds,
    this.plannedStartTimestamp,
    this.playersPerTeam,
  });
}
