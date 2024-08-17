import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:optima_soft/helpers/environment_helpers.dart';
import 'package:optima_soft/helpers/string_helpers.dart';
import 'package:optima_soft/services/navigation_service.dart';

class NetworkSettingBloc {
  final NavigationService _navigationService =
      GetIt.instance.get<NavigationService>();

  final Function onSettingSelected;
  @visibleForTesting
  final bool isTesting;

  NetworkSettingBloc({required this.onSettingSelected, this.isTesting = false});

  TextEditingController frontEndTextController = TextEditingController();
  TextEditingController backEndTextController = TextEditingController();

  Future<String> get getAppURL async {
    return await EnvironmentHelpers.getCurrentServer();
  }

  Future<String> get getBackendURL async {
    return await EnvironmentHelpers.getCurrentBackend();
  }

  ///
  /// Saves custom frontend and backend urls and reload app with `Environment.STAGE` environment value.
  ///
  Future<void> saveChanges() async {
    String frontEnd = frontEndTextController.text;
    String backend = backEndTextController.text;
    await EnvironmentHelpers.setAppEnvironment(Environment.STAGE);

    if (!StringHelper.isEmptyOrNull(frontEnd)) {
      await EnvironmentHelpers.setCustomFrontEnd(frontEnd);
    }
    if (!StringHelper.isEmptyOrNull(backend)) {
      await EnvironmentHelpers.setCustomBackEnd(backend);
    }
    onSettingSelected();
    closePage();
  }

  void closePage() {
    if (!isTesting) {
      _navigationService.pop();
    }
  }

  Future<void> resetToProdEnvironment() async {
    await EnvironmentHelpers.setAppEnvironment(Environment.PROD);
    onSettingSelected();
    closePage();
  }

  Future<void> resetToStageEnvironment() async {
    await EnvironmentHelpers.setAppEnvironment(Environment.STAGE);
    onSettingSelected();
    closePage();
  }

  void dispose() {
    frontEndTextController.dispose();
    backEndTextController.dispose();
  }
}
