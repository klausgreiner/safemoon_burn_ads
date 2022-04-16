// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      json['title'] as String?,
      json['thumbnail'] as String?,
      json['url_overridden_by_dest'] as String?,
      json['description'] as String?,
      json['permalink'] as String?,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'title': instance.title,
      'thumbnail': instance.thumbnail,
      'url_overridden_by_dest': instance.img,
      'description': instance.description,
      'permalink': instance.link,
    };
