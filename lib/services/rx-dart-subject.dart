import 'package:rxdart/rxdart.dart';

class RxDartSubjectService {
  static final RxDartSubjectService _instance =
      RxDartSubjectService._internal();

  factory RxDartSubjectService() {
    return _instance;
  }

  RxDartSubjectService._internal();

  BehaviorSubject<String?> sendJsMessageSubject = BehaviorSubject.seeded(null);
  BehaviorSubject<void> reloadPageSubject = BehaviorSubject.seeded(null);

  void sendEventData(String eventName, dynamic data) {
    sendJsMessageSubject
        .add('var event = new CustomEvent("$eventName", { "detail": $data });'
            'document.dispatchEvent(event);');
  }

  void callReloadPage() {
    reloadPageSubject.add(null);
  }
}
