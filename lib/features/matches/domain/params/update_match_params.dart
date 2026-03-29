class UpdateMatchParams {
  final String matchId;
  final List<String>? teamIds;
  final DateTime? plannedStartTimestamp;

  const UpdateMatchParams({
    required this.matchId,
    this.teamIds,
    this.plannedStartTimestamp,
  });
}
