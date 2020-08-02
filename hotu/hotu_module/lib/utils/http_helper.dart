import 'package:dio/dio.dart';
import '../model/user_info.dart';
import 'config.dart';


typedef HttpComplete = Function(bool);
class HttpHelper {

  HttpHelper() {
    configDio();
  }

  Dio dio = Dio();

  HttpComplete _onComplete;

  configDio() {
    BaseOptions options = BaseOptions(
      baseUrl: Config.api,
      connectTimeout: 60000,
      receiveTimeout: 60000,
      contentType: Headers.formUrlEncodedContentType,
    );
    dio.options = options;
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) async {
        return options;
      },
      onResponse: (Response response) async {
        print(response);
        var code = response.data["code"];
        if (code == "300") {

        }
        _onComplete(true);
        return response;
      },
      onError: (DioError error) async {
        print(error);
        _onComplete(false);
        return error;
      }
    ));
  }

  Future<Map<dynamic, dynamic>> post(String api, {Map<String, dynamic> params, HttpComplete onComplete}) async {
    _onComplete = onComplete ?? (b){};
    var par = {
      "user_token": UserInfo.instance.tokenId,
    };
    if (params != null) {
      par.addAll(params);
    }
    print(api);
    print(par);
    Response response = await dio.post(api,data: par);
    return response.data;
  }
}