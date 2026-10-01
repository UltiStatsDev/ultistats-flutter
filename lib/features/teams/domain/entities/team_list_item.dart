class TeamListItem {
  final String id;
  final String name;
  final String? city;
  final String? photoUrl;

  const TeamListItem({
    required this.id,
    required this.name,
    this.city,
    this.photoUrl,
  });
}
