import 'dart:io';

import 'package:app_installer/app_installer.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_autoupdate/flutter_autoupdate.dart';
import 'package:localization/localization.dart';
import 'package:optima_soft/helpers/environment_helpers.dart';
import 'package:optima_soft/services/context_builder.dart';
import 'package:optima_soft/services/path_utility.service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

class UpdaterService {
  static Future<void> checkUpdate(bool mounted, BuildContext? context) async {
    UpdateResult? result;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    if (Platform.isAndroid || Platform.isIOS) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      status = await Permission.mediaLibrary.status;
      if (!status.isGranted) {
        await Permission.mediaLibrary.request();
      }
    }

    if (!Platform.isAndroid) return;

    /// Android/Windows
    var manager = UpdateManager(
        versionUrl: EnvironmentHelpers.getUpdateServerEnvironment());

    /// iOS
    // var manager = UpdateManager(appId: 1500009417, countryCode: 'my');
    try {
      result = await manager.fetchUpdates();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      String version = packageInfo.version;
      if (result != null && Version.parse(version) < result.latestVersion) {
        var fileName =
            PathUtilityService.getFileNameFromUrl(result.downloadUrl);
        var downloadPath = await PathUtilityService().getDownloadPath();
        if (downloadPath == null) {
          return;
        }
        var filePath = "$downloadPath/$fileName";
        var file = File(filePath);
        try {
          if (await file.exists()) {
            var bytes = await file.readAsBytes();
            var sha512 = crypto.sha512.convert(bytes);
            if (sha512.toString() == result.sha512) {
              _showInstallAction(result, context, filePath);
              return;
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
        _showUpdateAction(result, context);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static _showInstallAction(
      UpdateResult updateRes, BuildContext? context, String filePath) async {
    context ??= ContextBuilderSaver().context;
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK".i18n()),
      onPressed: () async {
        if (Platform.isAndroid) {
          AppInstaller.installApk(filePath);
        }
        Navigator.of(context!).pop();
      },
    );
    Widget laterButton = TextButton(
      child: Text("InstallLater".i18n()),
      onPressed: () async {
        Navigator.of(context!).pop();
      },
    );
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("UpdateTitle".i18n()),
      content: Text(
          "${"UpdateExistOnPhoneMessage".i18n()}\n${"currentVertion".i18n()}${packageInfo.version}\n${"NewVersion".i18n()}${updateRes.latestVersion}"),
      actions: [okButton, laterButton],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static _showUpdateAction(
      UpdateResult updateRes, BuildContext? context) async {
    context ??= ContextBuilderSaver().context;
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK".i18n()),
      onPressed: () async {
        _externalDownload(updateRes);
        Navigator.of(context!).pop();
      },
    );
    Widget laterButton = TextButton(
      child: Text("UpdateLater".i18n()),
      onPressed: () async {
        Navigator.of(context!).pop();
      },
    );
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("UpdateTitle".i18n()),
      content: Text(
          "${"UpdateOnServerMessage".i18n()}\n${"currentVertion".i18n()}${packageInfo.version}\n${"NewVersion".i18n()}${updateRes.latestVersion}"),
      actions: [okButton, laterButton],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Future<void> _externalDownload(UpdateResult result) async {
    await launchUrl(Uri.parse(result.downloadUrl),
        mode: LaunchMode.externalApplication);
  }

  static Future<void> _innerUpdateAction(UpdateResult result) async {
    try {
      var controller = await result.initializeUpdate();
      controller.stream.listen((event) async {
        if (event.completed) {
          await controller.close();
          await result.runUpdate(event.path, autoExit: true);
        }
      });
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}

// certutil -hashfile "app-release.apk" SHA512
// adb -s emulator-5558 shell 'am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "https://hr.optimasoft.ir/borna/pr"'
// keytool -list -v -keystore C:/Users/Borna1056/upload-keystore.jks -alias upload -storepass borna68066 -keypass bornashop68066
