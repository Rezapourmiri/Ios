import 'package:flutter/material.dart';
import 'package:optima_soft/helpers/colors.dart';
import 'package:optima_soft/helpers/environment_helpers.dart';
import 'package:optima_soft/helpers/platform_helper.dart';
import 'package:optima_soft/helpers/string_helpers.dart';
import 'package:optima_soft/services/shared-preference-service.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BornaBackGroundColor,
      body: _mainContent(),
    );
  }

  Widget _mainContent() {
    return Stack(children: [
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin:
                  EdgeInsets.only(bottom: PlatformHelper.screenHeight * 0.05),
              width: PlatformHelper.screenWidth * 0.27,
              height: PlatformHelper.screenWidth * 0.27,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.fill)),
            ),
            FutureBuilder<String>(
              future: SharedPreferenceService().getTenant(),
              builder: (context, snapshot) => Text(
                snapshot.data ?? "",
                style: TextStyle(
                    fontSize: StringHelper.generateProportionateFontSize(30),
                    color: const Color(0xFF222222)),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: PlatformHelper.screenHeight * 0.1),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Image.asset(
            "assets/images/loading_white.gif",
            width: PlatformHelper.screenWidth * 0.25,
          ),
        ),
      ),
    ]);
  }
}
