
import '../helpers/cache_helper.dart';

class UrlsStrings {
  static String cachedUrl = CacheHelper.get(key: "cached_url") ?? baseUrl;
  static String baseUrl = "http://209.250.237.58:3058";

  static String loginUrl = "$cachedUrl/auth/login";
  static String profileUrl = "$cachedUrl/auth/profile";
  static String verifyCodeUrl = "$cachedUrl/serials";
  static String checkCodeUrl = "$cachedUrl/serials/authorized";
}
