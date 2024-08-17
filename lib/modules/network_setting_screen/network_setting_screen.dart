import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:optima_soft/helpers/colors.dart';
import 'package:optima_soft/helpers/platform_helper.dart';
import 'package:optima_soft/helpers/string_helpers.dart';
import 'package:optima_soft/modules/network_setting_screen/network_setting_bloc.dart';

class NetworkSettingScreen extends StatefulWidget {
  static const routeName = "/NetworkSettingScreen";

  const NetworkSettingScreen({Key? key}) : super(key: key);

  @override
  _NetworkSettingScreenState createState() => _NetworkSettingScreenState();
}

class _NetworkSettingScreenState extends State<NetworkSettingScreen> {
  late NetworkSettingBloc _bloc;

  TextStyle? get mainTextStyle => Theme.of(context)
      .textTheme
      .headline2
      ?.copyWith(fontSize: StringHelper.generateProportionateFontSize(17));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = Provider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _mainContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        "Network Setting",
        style: Theme.of(context).textTheme.headline1,
      ),
      leadingWidth: PlatformHelper.screenWidth * 0.24,
      leading: CupertinoButton(
          child: Text(
            "Close",
            style: Theme.of(context)
                .textTheme
                .headline2
                ?.copyWith(color: CupertinoColors.activeBlue),
          ),
          onPressed: () {
            _bloc.closePage();
          }),
      actions: [
        CupertinoButton(
            key: const Key("saveButton"),
            child: Text(
              "Save",
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  ?.copyWith(color: CupertinoColors.activeBlue),
            ),
            onPressed: _bloc.saveChanges)
      ],
    );
  }

  Widget _mainContent() {
    return Container(
        color: Theme.of(context).backgroundColor,
        child: ListView(
          children: [
            ListTile(
              leading: Text(
                "Custom Frontend",
                style: mainTextStyle,
              ),
            ),
            _inputListTile("Domain", "Default To Stage Environment",
                _bloc.frontEndTextController,
                textFieldKey: const Key("frontendInput")),
            _hintTextBox(
              "Used for PWA address to load app data.",
            ),
            ListTile(
              leading: Text(
                "Custom Backend",
                style: mainTextStyle,
              ),
            ),
            _inputListTile("Domain", "Default To Stage Environment",
                _bloc.backEndTextController,
                textFieldKey: const Key("backendInput")),
            _hintTextBox(
                "Used for api calls like picture upload or doctor on call form submit."),
            _listTileButton(
                "Reset To Prod Setting", _bloc.resetToProdEnvironment),
            Divider(
              color: Theme.of(context).backgroundColor,
              height: 1.0,
            ),
            _listTileButton(
                "Reset To Stage Setting", _bloc.resetToStageEnvironment),
            ListTile(
              leading: Text(
                "Frontend Domain:",
                style: mainTextStyle,
              ),
            ),
            _futureBuilderHintBox(_bloc.getAppURL),
            ListTile(
              leading: Text(
                "Backend Domain:",
                style: mainTextStyle,
              ),
            ),
            _futureBuilderHintBox(_bloc.getBackendURL),
          ],
        ));
  }

  Widget _inputListTile(
      String title, String placeholder, TextEditingController controller,
      {required Key textFieldKey}) {
    return Container(
      height: PlatformHelper.screenHeight * 0.08,
      color: Colors.white,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: PlatformHelper.screenWidth * 0.05),
        child: Row(
          children: [
            Text(
              title,
              style: mainTextStyle,
            ),
            Container(
              width: PlatformHelper.screenWidth * 0.025,
            ),
            Expanded(
              child: TextFormField(
                key: textFieldKey,
                controller: controller,
                decoration: _defaultInputStyle(placeholder),
                style: mainTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _defaultInputStyle(String placeholder) {
    return InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding:
            EdgeInsets.only(left: PlatformHelper.screenWidth * 0.025),
        hintText: placeholder,
        hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: StringHelper.generateProportionateFontSize(15),
            fontWeight: FontWeight.w500));
  }

  Widget _hintTextBox(String title) {
    TextStyle? hintTextStyle = Theme.of(context).textTheme.headline2?.copyWith(
        fontSize: StringHelper.generateProportionateFontSize(15),
        color: corduroy);
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: PlatformHelper.screenHeight * 0.02,
          horizontal: PlatformHelper.screenWidth * 0.05),
      child: Text(
        title,
        style: hintTextStyle,
      ),
    );
  }

  Widget _listTileButton(String title, GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: PlatformHelper.screenHeight * 0.08,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: PlatformHelper.screenWidth * 0.05),
          child: Row(children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: StringHelper.generateProportionateFontSize(17),
                  color: CupertinoColors.activeBlue),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _futureBuilderHintBox(Future<String> future) {
    return FutureBuilder(
        future: future,
        builder: (_, AsyncSnapshot<String> snapshot) {
          return _hintTextBox(
              snapshot.hasData == true ? (snapshot.data ?? "") : "");
        });
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }
}
