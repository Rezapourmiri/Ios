import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:path_provider/path_provider.dart';

class PathUtilityService {
  Future<String?> getDownloadPath() async {
    try {
      if (Platform.isIOS) {
        return (await getApplicationDocumentsDirectory()).path;
      } else {
        return await AndroidPathProvider.downloadsPath;
      }
    } catch (err) {
      print("Cannot get download folder path");
    }
    return null;
  }

  static String getFileNameFromUrl(String downloadUrl) {
    var urlContent = downloadUrl.split('/');
    if (urlContent.isEmpty) {
      throw Exception("The download URL may be invalid.");
    }
    return urlContent[urlContent.length - 1];
  }

  Future<String?> getAppPath(String fileName) async {
    if (!Platform.isAndroid && !Platform.isWindows) return null;

    var dir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getTemporaryDirectory();
    // Split a URL and retrieve the file name
    return '${dir!.path}/$fileName';
  }
}
