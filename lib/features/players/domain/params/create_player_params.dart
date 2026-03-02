class CreatePlayerParams {
  final int number;
  final String firstName;
  final String lastName;
  final String teamId;

  const CreatePlayerParams({
    required this.number,
    required this.firstName,
    required this.lastName,
    required this.teamId,
  });
}