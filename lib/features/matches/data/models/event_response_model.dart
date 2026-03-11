import 'package:json_annotation/json_annotation.dart';

part 'event_response_model.g.dart';

@JsonSerializable()
class EventResponseModel {
  final String? diskHolderId;

  const EventResponseModel({this.diskHolderId});

  factory EventResponseModel.fromJson(Map<String, dynamic> json) => 
      _$EventResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventResponseModelToJson(this);
}
