class PlayerListItem {
  final String id;
  final String firstName;
  final String lastName;
  final String? photoUrl;

  const PlayerListItem({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.photoUrl,
  });

  factory PlayerListItem.placeholder() => const PlayerListItem(
        id: '0',
        firstName: 'FirstName',
        lastName: 'LastName',
      );
}
