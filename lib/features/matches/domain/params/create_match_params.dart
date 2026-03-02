class CreateMatchParams {
  final List<String> teamIds;
  final DateTime plannedStartDate;

  const CreateMatchParams({
    required this.teamIds,
    required this.plannedStartDate,
  });
}