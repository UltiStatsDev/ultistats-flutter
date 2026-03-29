class CreateMatchParams {
  final List<String> teamIds;
  final DateTime? plannedStartTimestamp;

  const CreateMatchParams({
    required this.teamIds,
    this.plannedStartTimestamp,
  });
}