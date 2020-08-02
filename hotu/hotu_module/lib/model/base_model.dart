import 'package:json_annotation/json_annotation.dart';
part 'base_model.g.dart';

@JsonSerializable()
class BaseModel {
  String msg = "";
  String code = "";

  BaseModel();

  factory BaseModel.fromeJson(Map<String, dynamic> json) => _$BaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BaseModelToJson(this);
}