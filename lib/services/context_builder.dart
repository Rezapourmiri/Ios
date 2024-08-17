import 'package:flutter/widgets.dart';

class ContextBuilderSaver {
  static final ContextBuilderSaver _instance = ContextBuilderSaver._internal();
  create(BuildContext _context) {
    context = _context;
  }

  factory ContextBuilderSaver() {
    return _instance;
  }

  ContextBuilderSaver._internal();

  late BuildContext context;
}
