class CreatePlayerParams {
  final int? number;
  final String firstName;
  final String lastName;
  final String? teamId;

  const CreatePlayerParams({
    this.number,
    required this.firstName,
    required this.lastName,
    this.teamId,
  });
}