class Player {
  final String id;
  final String? teamId;
  final int? number;
  final String firstName;
  final String lastName;

  const Player({
    required this.id,
    this.teamId,
    this.number,
    required this.firstName,
    required this.lastName,
  });
}
