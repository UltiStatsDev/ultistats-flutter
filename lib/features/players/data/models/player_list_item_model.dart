import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/players/domain/entities/player_list_item.dart';

part 'player_list_item_model.g.dart';

@JsonSerializable()
class PlayerListItemModel {
  final String id;
  final String firstName;
  final String lastName;
  final String? photoUrl;

  const PlayerListItemModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.photoUrl,
  });

  factory PlayerListItemModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerListItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerListItemModelToJson(this);

  PlayerListItem toEntity() {
    return PlayerListItem(
      id: id,
      firstName: firstName,
      lastName: lastName,
      photoUrl: photoUrl,
    );
  }
}
