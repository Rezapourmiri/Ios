import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mockito/mockito.dart';

class InAppWebViewMock extends Fake implements InAppWebViewController {
  late Function(String handlerName) onAddJavaScriptHandler;
  late Function(String source) onEvaluateJavascript;
  late Function onClearCache;
  late Function onClearSessionStorage;
  late Function onClearLocalStorage;
  late Function(URLRequest urlRequest) onLoadURL;
  late Function onStopLoading;

  @override
  WebStorage get webStorage =>
      WebStorageMock(onClearSessionStorage, onClearLocalStorage);

  @override
  void addJavaScriptHandler(
      {required String handlerName,
      required JavaScriptHandlerCallback callback}) {
    onAddJavaScriptHandler(handlerName);
  }

  @override
  Future evaluateJavascript(
      {required String source, ContentWorld? contentWorld}) async {
    onEvaluateJavascript(source);
    return Future.value(null);
  }

  @override
  Future<void> clearCache() {
    onClearCache();
    return Future.value(null);
  }

  // @override
  // Future<void> loadUrl(
  //     {required URLRequest urlRequest, Uri? iosAllowingReadAccessTo}) {
  //   onLoadURL(urlRequest);
  //   return Future.value(null);
  // }

  @override
  Future<void> stopLoading() {
    onStopLoading();
    return Future.value(null);
  }
}

class WebStorageMock extends Fake implements WebStorage {
  final Function onSessionStorageCleared;
  final Function onLocalStorageCleared;

  WebStorageMock(this.onSessionStorageCleared, this.onLocalStorageCleared);

  @override
  SessionStorage get sessionStorage =>
      SessionStorageMock(onSessionStorageCleared);
  @override
  LocalStorage get localStorage => LocalStorageMock(onLocalStorageCleared);

  @override
  set localStorage(LocalStorage _localStorage) {}

  @override
  set sessionStorage(SessionStorage _sessionStorage) {}
}

class SessionStorageMock extends Fake implements SessionStorage {
  final Function onClear;

  SessionStorageMock(this.onClear);

  @override
  Future<void> clear() {
    onClear();
    return Future.value(null);
  }
}

class LocalStorageMock extends Fake implements LocalStorage {
  final Function onClear;

  LocalStorageMock(this.onClear);

  @override
  Future<void> clear() {
    onClear();
    return Future.value(null);
  }
}
