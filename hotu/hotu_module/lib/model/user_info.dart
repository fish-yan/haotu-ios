import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'user_info.g.dart';

@JsonSerializable()
class UserInfo extends BaseModel {

  static UserInfo get instance => _getInstance();

  static UserInfo _instance;

  static UserInfo _getInstance() {
    if (_instance == null) {
      _instance = UserInfo();
    }
    return _instance;
  }

  String name = "";
  @JsonKey(name: "nick_name")
  String userName = "";
  @JsonKey(name: "phoneNO")
  String mblNo = "";
  String tokenId = "";
  String isRealName = "0";
  String roleCode = "";
  @JsonKey(name: "user_logo")
  String userLogo = "";
  String sex = "";
  String idNo = "";
  String id = "";

  UserInfo();

  factory UserInfo.fromeJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);

  setInstance() async {
    UserInfo.instance.msg = msg ?? "";
    UserInfo.instance.code = code ?? "";
    UserInfo.instance.userName = userName ?? "";
    UserInfo.instance.mblNo = mblNo ?? "";
    UserInfo.instance.name = name ?? "";
    UserInfo.instance.isRealName = isRealName ?? "";
    UserInfo.instance.roleCode = roleCode ?? "";
    UserInfo.instance.userLogo = userLogo ?? "";
    UserInfo.instance.sex = sex ?? "";
    UserInfo.instance.id = id ?? "";
    UserInfo.instance.idNo = idNo ?? "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("mblNo", UserInfo.instance.mblNo);
    prefs.setString("userName", UserInfo.instance.userName);
    prefs.setString("name", UserInfo.instance.name);
    prefs.setString("isRealName", UserInfo.instance.isRealName);
    prefs.setString("roleCode", UserInfo.instance.roleCode);
    prefs.setString("userLogo", UserInfo.instance.userLogo);
    prefs.setString("sex", UserInfo.instance.sex);
    prefs.setString("idNo", UserInfo.instance.idNo);
    prefs.setString("id", UserInfo.instance.id);
  }

  Future<bool> isLogined() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserInfo.instance.tokenId = prefs.getString("tokenId") ?? "";
    UserInfo.instance.mblNo = prefs.getString("mblNo") ?? "";
    UserInfo.instance.userName = prefs.getString("userName") ?? "";
    UserInfo.instance.name = prefs.getString("name") ?? "";
    UserInfo.instance.isRealName = prefs.getString("isRealName") ?? "";
    UserInfo.instance.roleCode = prefs.getString("roleCode") ?? "";
    UserInfo.instance.userLogo = prefs.getString("userLogo") ?? "";
    UserInfo.instance.sex = prefs.getString("sex") ?? "";
    UserInfo.instance.sex = prefs.getString("idNo") ?? "";
    UserInfo.instance.sex = prefs.getString("id") ?? "";
    return tokenId.isNotEmpty;
  }
}