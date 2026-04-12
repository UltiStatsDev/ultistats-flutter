class PlayerListItem {
  final String id;
  final String firstName;
  final String lastName;
  final String? teamName;
  final int? number;
  final String? photoUrl;

  const PlayerListItem({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.teamName,
    this.number,
    this.photoUrl,
  });

  factory PlayerListItem.placeholder() => const PlayerListItem(
        id: '0',
        firstName: 'FirstName',
        lastName: 'LastName',
        number: 0,
      );
}
