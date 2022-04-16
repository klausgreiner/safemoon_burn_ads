import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Post extends Equatable {
  final String? title;
  final String? thumbnail;
  @JsonKey(name: 'url_overridden_by_dest')
  final String? img;
  final String? description;
  @JsonKey(name: 'permalink')
  final String? link;

  const Post(this.title, this.thumbnail, this.img, this.description, this.link);

  factory Post.fromJson(Map<String, dynamic> json) =>
      _$PostFromJson(json["data"]);

  @override
  List<Object?> get props => [title, thumbnail, img, description, link];
}
