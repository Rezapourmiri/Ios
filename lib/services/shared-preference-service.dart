import 'package:optima_soft/models/login_information/extra_info.model.dart';
import 'package:optima_soft/models/login_information/login_information.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static final SharedPreferenceService _instance =
      SharedPreferenceService._internal();

  factory SharedPreferenceService() {
    return _instance;
  }

  SharedPreferenceService._internal();

  Future saveMissoniId(int personTourId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('PersonTourId', personTourId);
  }

  Future<int> getMissoniId() async {
    final prefs = await SharedPreferences.getInstance();
    var res = prefs.getInt('PersonTourId') ?? 0;
    return res;
  }

  Future saveAlwaysSendLocation(bool inputAlwaysSendLocation) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('AlwaysSendLocation', inputAlwaysSendLocation);
  }

  Future<bool> getAlwaysSendLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('AlwaysSendLocation') ?? false;
  }

  Future saveLoginAccessData(String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('LoginData', data);
  }

  Future<LoginInformation?> getLoginAccessData() async {
    final prefs = await SharedPreferences.getInstance();
    var res = prefs.getString('LoginData');
    return res != null ? LoginInformation.fromJson(res) : null;
  }

  Future<String> getRefreshToken() async {
    final loginInfo = await getLoginAccessData();
    return loginInfo?.refreshToken ?? "";
  }

  Future<String> getToken() async {
    final loginInfo = await getLoginAccessData();
    return loginInfo?.token ?? "";
  }

  Future saveToken(String token) async {
    final loginInfo = await getLoginAccessData();
    loginInfo?.token = token;
    saveLoginAccessData(loginInfo?.toJson() ?? "");
  }

  Future<String> getUserName() async {
    final loginInfo = await getLoginAccessData();
    return loginInfo?.userName ?? "";
  }

  Future<String> getPassword() async {
    final loginInfo = await getLoginAccessData();
    return loginInfo?.password ?? "";
  }

  Future saveExraInfo(List<ExtraInfo> extraInfo) async {
    final loginInfo = await getLoginAccessData();
    loginInfo?.extraInfo = extraInfo;
    saveLoginAccessData(loginInfo?.toJson() ?? "");
  }

  Future saveTimeZone(String timeZone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('timeZone', timeZone);
  }

  Future<String> getTimeZone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('timeZone') ?? "America/Vancouver";
  }

  Future<String?> getSetting(String settingName) async {
    final loginInfo = await getLoginAccessData();
    var res = loginInfo?.extraInfo
        ?.where((element) => element.workSettingType == settingName)
        .first
        .value;
    return res;
  }

  Future saveHtmlVersion(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('HtmlVersion', version);
  }

  Future<String> getHtmlVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('HtmlVersion') ?? "0";
  }

  Future<void> saveLastLocationSave() async {
    var stringList = DateTime.now().toIso8601String().split(RegExp(r"[T\.]"));
    var createLocationAt = "${stringList[0]} ${stringList[1]}";
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('LastLocationSave', createLocationAt);
  }

  Future<DateTime> getLastLocationSave() async {
    final prefs = await SharedPreferences.getInstance();

    var stringList = DateTime.now()
        .add(const Duration(days: -1))
        .toIso8601String()
        .split(RegExp(r"[T\.]"));
    var defalutDatetime = "${stringList[0]} ${stringList[1]}";

    return DateTime.parse(
        prefs.getString('LastLocationSave') ?? defalutDatetime);
  }

  Future<void> saveFirebaseToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('FirebaseToken', token);
  }

  Future<String> getFirebaseToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('FirebaseToken') ?? "";
  }

  Future<String?> getUserLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('UserLanguage');
  }

  Future<void> saveUserLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('UserLanguage', languageCode);
  }

  Future<void> saveTenant(String companyId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('TenantName', companyId);
  }

  Future<String> getTenant() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('TenantName') ?? "";
  }

  Future<void> saveUserCountry(String selectedLocation) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('UserCountry', selectedLocation);
  }

  Future<String?> getUserCountry() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('UserCountry');
  }

  Future<String> getTLD() async {
    final prefs = await SharedPreferences.getInstance();
    var res = prefs.getString('UserCountry') ?? "other";
    if (res == "Iran") {
      return "ir";
    }
    return "ca";
  }

  setLoginStatus(bool bool) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('LoginStatus', bool);
  }

  Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('LoginStatus') ?? false;
  }
}
