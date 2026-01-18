import 'package:package_info_plus/package_info_plus.dart';

class AppStrings {

  static const String logo = 'assets/images/logo.png';
  static const String profileImage = 'assets/images/profile_image.png';
  static late final String appName;
  static late final String appVersion;

  static Future getAppData() async {
    final getInfo = await PackageInfo.fromPlatform();
    appName = getInfo.appName;
    appVersion = getInfo.version;
  }

  static String get copyRightText => '\u00A9 2026 $appName Inc.';

}