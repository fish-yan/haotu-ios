
import 'bridge_util.dart';


class Config {

  static Config instance = Config();

  bool debug = true;

  bool isHome = true;

  static initConfig() {
    Config.instance.platform = getPlatform();
    Config.instance.statusBarHeight = getStatusBarHeight();
    Config.instance.bottomHeight = getBottomHeight();
    Config.instance.debug = false;
    print("platform:" + Config.instance.platform);
    print("environment:" + (Config.instance.debug ? "debug" : "release"));
  }

  static String get api {
    if (Config.instance.debug) {
      return "http://local.hotu.club:1234/api/v1.0/";
    } else {
      return "http://www.hotu.club:9595/api/v1.0/";
    }
  }

  static String imgPath(String name) {
    String url = getUrl().replaceFirst("/index.html", "/assets/res/$name");
    return  url;
  }


  double statusBarHeight = 20;

  double bottomHeight = 0;

  String platform = "";
}