import 'dart:io';
import 'dart:ui';
import 'package:mockito/mockito.dart';

class PlatformHelper {
  ///
  /// Whether the operating system is a version of Android.
  ///
  get isAndroid => Platform.isAndroid;

  ///
  /// Whether the operating system is a version of iOS.
  ///
  get isIOS => Platform.isIOS;

  ///
  /// Device screen width based on pixel ratio.
  ///
  static double get screenWidth =>
      window.physicalSize.width / window.devicePixelRatio;

  ///
  /// Device screen height based on pixel ratio.
  ///
  static double get screenHeight =>
      window.physicalSize.height / window.devicePixelRatio;
}

class PlatformHelperMock extends Fake implements PlatformHelper {
  final bool _isAndroid;
  final bool _isIOS;

  PlatformHelperMock.implementAndroid()
      : _isAndroid = true,
        _isIOS = false;

  PlatformHelperMock.implementIOS()
      : _isAndroid = false,
        _isIOS = true;

  @override
  get isAndroid => _isAndroid;

  @override
  get isIOS => _isIOS;
}
