// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo()
    ..msg = json['msg'] as String
    ..code = json['code'] as String
    ..name = json['name'] as String
    ..userName = json['nick_name'] as String
    ..mblNo = json['phoneNO'] as String
    ..tokenId = json['tokenId'] as String
    ..isRealName = json['isRealName'] as String
    ..roleCode = json['roleCode'] as String
    ..userLogo = json['user_logo'] as String
    ..sex = json['sex'] as String
    ..idNo = json['idNo'] as String
    ..id = json['id'] as String;
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'msg': instance.msg,
      'code': instance.code,
      'name': instance.name,
      'nick_name': instance.userName,
      'phoneNO': instance.mblNo,
      'tokenId': instance.tokenId,
      'isRealName': instance.isRealName,
      'roleCode': instance.roleCode,
      'user_logo': instance.userLogo,
      'sex': instance.sex,
      'idNo': instance.idNo,
      'id': instance.id,
    };
