import 'package:json_annotation/json_annotation.dart';

part 'photo_url_response.g.dart';

@JsonSerializable()
class PhotoUrlResponse {
  final String? url;

  const PhotoUrlResponse({this.url});

  factory PhotoUrlResponse.fromJson(Map<String, dynamic> json) =>
      _$PhotoUrlResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoUrlResponseToJson(this);
}
