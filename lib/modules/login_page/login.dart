import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localization/localization.dart';
import 'package:optima_soft/helpers/environment_helpers.dart';
import 'package:optima_soft/models/login_information/login_information.model.dart';
import 'package:optima_soft/modules/login_page/letter_group.dart';
import 'package:optima_soft/modules/login_page/login_input_view_model.dart';
import 'package:optima_soft/services/full-mission-permission.dart';
import 'package:optima_soft/services/http-service.dart';
import 'package:optima_soft/services/shared-preference-service.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginDemoState createState() => _LoginDemoState();
}

List<LetterGroup> locationList = [
  LetterGroup(key: "Iran", value: "Iran".i18n()),
  LetterGroup(key: "Canada", value: "Canada".i18n()),
  LetterGroup(key: "Other", value: "Other".i18n()),
];
List<LetterGroup> languageList = [
  LetterGroup(key: "fa_IR", value: "فارسی (ایران)"),
  LetterGroup(key: "en_US", value: "English (united states)"),
];
String? selectedLocation;
String selectedLanguage = "en_US";
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController tenantController = TextEditingController();

Future<String> getCurrentLanguage(BuildContext context) async {
  var res = Localizations.localeOf(context).toString();
  selectedLanguage = res;
  return res;
}

Future<String?> initUniLinks() async {
  try {
    final initialLink = await getInitialLink();
    if (initialLink != null &&
        initialLink.toLowerCase().contains("/pr") &&
        initialLink.length > 1) {
      var removeSchema = initialLink.toLowerCase().split("://");
      var path = removeSchema.length == 2
          ? removeSchema[1]
          : initialLink.toLowerCase();
      var pathSp = path.split("/");
      if (pathSp.length < 3) {
        return null;
      }
      var companyCode = pathSp[1];
      return companyCode;
    }
    return null;
  } on PlatformException {
    return null;
  }
}

Future<void> initialLoginData() async {
  var loginAccessData = await SharedPreferenceService().getLoginAccessData();
  emailController =
      TextEditingController(text: loginAccessData?.userName ?? "");
  passwordController =
      TextEditingController(text: loginAccessData?.password ?? "");
  tenantController = TextEditingController(
      text:
          await initUniLinks() ?? await SharedPreferenceService().getTenant());
  selectedLocation = await SharedPreferenceService().getUserCountry();
}

bool isNumeric(String? s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

Future<bool> goToApp(BuildContext context, String email, String password,
    String companyId, String? selectedLocation) async {
  if (selectedLocation == null) {
    Fluttertoast.showToast(
        msg: "SelectCountry".i18n(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);

    return false;
  }

  var loginAccessData = await SharedPreferenceService().getLoginAccessData();
  loginAccessData ??= LoginInformation(
      activities: null,
      expirationDate: null,
      extraInfo: null,
      isActive: null,
      password: null,
      refreshToken: null,
      requestedAt: null,
      roles: null,
      token: null,
      userName: null);
  loginAccessData.userName = email;
  loginAccessData.password = password;
  await SharedPreferenceService().saveLoginAccessData(loginAccessData.toJson());
  await SharedPreferenceService().saveTenant(companyId);

  final String url =
      "${await EnvironmentHelpers.getCurrentBackend()}/api/Login/Login";
  var data = LoginInputViewModel(
      email: isNumeric(email) ? null : email,
      phoneNumber: isNumeric(email) ? email : null,
      password: password);
  var reqRes = await HttpService().postData(url, data.toMap(), null, true);

  if(reqRes?.statusCode == 200){
    var data = json.decode(reqRes!.body) as Map<String, dynamic>;
    loginAccessData.refreshToken = data['refreshToken'];
  }
  await SharedPreferenceService().saveLoginAccessData(loginAccessData.toJson());
  
  if (reqRes?.statusCode != 200) {
    Fluttertoast.showToast(
        msg: "authenticationfieled".i18n(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
    return false;
  }
  await SharedPreferenceService().setLoginStatus(true);
  Navigator.pushReplacementNamed(context, "/app");
  return true;
}

bool pressButton = false;

class _LoginDemoState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    getMissionPermission(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: false, title: const LanguageDropDown()),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: SizedBox(
                    width: 260,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('assets/images/logo-name.png')),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.left,
                style: const TextStyle(height: 1, fontSize: 15),
                controller: emailController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3))),
                  labelText: 'EmailOrPhoneNumber'.i18n(),
                  // hintText: 'Entervalidemailorphonenumber'.i18n(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.left,
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(height: 1, fontSize: 15),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3))),
                  labelText: 'Password'.i18n(),
                  // hintText: 'Enteryourpassword'.i18n(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.left,
                controller: tenantController,
                style: const TextStyle(height: 1, fontSize: 15),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3))),
                  labelText: 'Company'.i18n(),
                  // hintText: 'Entercompany'.i18n(),
                ),
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: FullDropdownButton(),
            ),
            Container(
              height: 43,
              width: 100,
              margin:
                  const EdgeInsets.only(left: 0, right: 0, top: 25, bottom: 0),
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: pressButton
                        ? MaterialStateProperty.all<Color>(Colors.grey)
                        : MaterialStateProperty.all<Color>(Colors.blue)),
                onPressed: () async {
                  if (pressButton == true) return;
                  setState(() {
                    pressButton = true;
                  });
                  EasyLoading.show(
                      status: 'pleasewait'.i18n(), dismissOnTap: false);
                  await goToApp(
                      context,
                      emailController.text,
                      passwordController.text,
                      tenantController.text,
                      selectedLocation);
                  EasyLoading.dismiss();
                  setState(() {
                    pressButton = false;
                  });
                },
                child: Text(
                  'Login'.i18n(),
                  style: const TextStyle(
                      color: Colors.white, fontSize: 18, height: 1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: InkWell(
                onTap: () {
                  launchUrl(
                      Uri.parse(
                          "https://hr.optimasoft.ir/assets/video/install-optimasoft.mp4"),
                      mode: LaunchMode.inAppWebView);
                },
                child: Text("showHelpVideo".i18n(),
                    style: const TextStyle(color: Colors.blue)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageDropDown extends StatefulWidget {
  const LanguageDropDown({Key? key}) : super(key: key);

  @override
  State<LanguageDropDown> createState() => _LanguageDropDown();
}

class _LanguageDropDown extends State<LanguageDropDown> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getCurrentLanguage(context),
      builder: (_, snapshot) {
        return DropdownButton<String>(
          value: selectedLanguage,
          icon: const Icon(Icons.keyboard_arrow_down),
          onChanged: (String? value) async {
            await SharedPreferenceService().saveUserLanguage(value!);
            Phoenix.rebirth(context);
          },
          items:
              languageList.map<DropdownMenuItem<String>>((LetterGroup value) {
            return DropdownMenuItem<String>(
              value: value.key,
              child: Text(value.value),
            );
          }).toList(),
        );
      },
    );
  }
}

class FullDropdownButton extends StatefulWidget {
  const FullDropdownButton({Key? key}) : super(key: key);

  @override
  State<FullDropdownButton> createState() => _FullDropdownButton();
}

class _FullDropdownButton extends State<FullDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: .5, color: Colors.black12),
        ),
      ),
      child: InputDecorator(
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            labelText: "Country".i18n(),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(3)))),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<String>(
              isExpanded: true,
              style: const TextStyle(fontSize: 15, color: Colors.black),
              value: selectedLocation,
              icon: const Icon(Icons.keyboard_arrow_down),
              onChanged: (String? value) async {
                // This is called when the user selects an item.
                setState(() {
                  selectedLocation = value;
                });
                await SharedPreferenceService().saveUserCountry(value!);
              },
              hint: Text("Selectyourcountry".i18n()),
              menuMaxHeight: 320,
              items: locationList
                  .map<DropdownMenuItem<String>>((LetterGroup value) {
                return DropdownMenuItem<String>(
                  value: value.key,
                  child: Text(value.value),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
