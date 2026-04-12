import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/teams/domain/entities/team_list_item.dart';

part 'team_list_item_model.g.dart';

@JsonSerializable()
class TeamListItemModel {
  final String id;
  final String name;
  final String? city;
  final String? photoUrl;

  const TeamListItemModel({
    required this.id,
    required this.name,
    this.city,
    this.photoUrl,
  });

  factory TeamListItemModel.fromJson(Map<String, dynamic> json) =>
      _$TeamListItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamListItemModelToJson(this);

  TeamListItem toEntity() {
    return TeamListItem(
      id: id,
      name: name,
      city: city,
      photoUrl: photoUrl,
    );
  }
}
