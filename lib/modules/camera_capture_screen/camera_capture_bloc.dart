// import 'dart:async';

// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
// import 'package:get_it/get_it.dart';
// import 'package:rxdart/subjects.dart';
// import 'package:optima_soft/helpers/string_helpers.dart';
// import 'package:optima_soft/models/capture_photo_model.dart';
// import 'package:optima_soft/modules/photo_picker_screen/photo_picker_bloc.dart';
// import 'package:optima_soft/services/navigation_service.dart';

// class CameraCaptureBloc {
//   final NavigationService _navigationService =
//       GetIt.instance.get<NavigationService>();
//   final PictureSide requestedSide;
//   final Function(CapturePhotoModel) onTookPhoto;

//   CameraCaptureBloc(this.onTookPhoto, this.requestedSide);
//   final BehaviorSubject<CameraController> _cameraSubjectController =
//       BehaviorSubject();

//   Stream<CameraController> get cameraControllerStream =>
//       _cameraSubjectController.stream;

//   CameraController get _cameraController => _cameraSubjectController.value;

//   List<CameraDescription> _availableCameras = [];

//   ///
//   /// First available camera usually the rear camera.
//   ///
//   int _selectedCameraIndex = 0;

//   String get pictureSide => StringHelper.pictureSideToString(requestedSide);

//   ///
//   /// Initialize first available camera for page setup.
//   ///
//   void initializeCamera() async {
//     _availableCameras = await availableCameras();
//     await _setupCamera(_availableCameras[_selectedCameraIndex]);
//   }

//   Future<void> _setupCamera(CameraDescription camera) async {
//     CameraController cameraController =
//         CameraController(camera, ResolutionPreset.veryHigh);
//     cameraController.lockCaptureOrientation(DeviceOrientation.portraitUp);
//     try {
//       await cameraController.initialize();
//       _cameraSubjectController.add(cameraController);
//     } catch (exception) {
//       if (kDebugMode) {
//         print(exception);
//       }
//       return;
//     }
//   }

//   ///
//   /// Takes a photo and close the page.
//   ///
//   void captureButtonPressed() async {
//     try {
//       XFile image = await _cameraController.takePicture();
//       onTookPhoto(CapturePhotoModel(image, requestedSide));
//       closeButtonPressed();
//     } catch (error) {
//       if (kDebugMode) {
//         print(error);
//       }
//     }
//   }

//   void closeButtonPressed() {
//     _navigationService.pop();
//   }

//   ///
//   /// Switches between available cameras.
//   ///
//   void switchCameraPressed() async {
//     _cameraSubjectController.add(CameraController(
//         _availableCameras[_selectedCameraIndex], ResolutionPreset.veryHigh));
//     await _cameraController.dispose();
//     _selectedCameraIndex = _selectedCameraIndex < _availableCameras.length - 1
//         ? _selectedCameraIndex + 1
//         : 0;
//     await _setupCamera(_availableCameras[_selectedCameraIndex]);
//   }

//   dispose() {
//     _cameraController.dispose();
//     _cameraSubjectController.close();
//   }
// }
