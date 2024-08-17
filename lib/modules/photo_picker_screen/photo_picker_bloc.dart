// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:rxdart/subjects.dart';
// import 'package:optima_soft/api/cloud_functions_interface/cloud_functions_interface.dart';
// import 'package:optima_soft/helpers/string_helpers.dart';
// import 'package:optima_soft/models/capture_photo_model.dart';
// import 'package:optima_soft/models/pick_photo_model.dart';
// import 'package:optima_soft/models/pose_photo_model.dart';
// import 'package:optima_soft/models/user_photo_model.dart';
// import 'package:optima_soft/modules/camera_capture_screen/camera_capture_bloc.dart';
// import 'package:optima_soft/modules/camera_capture_screen/camera_capture_screen.dart';
// import 'package:optima_soft/services/navigation_service.dart';

// enum PictureSide { front, top, right, left }

// class PhotoPickerBloc {
//   final NavigationService _navigationService =
//       GetIt.instance.get<NavigationService>();
//   final CloudFunctionsInterface _cloudFunctionsInterface =
//       GetIt.instance.get<CloudFunctionsInterface>();

//   @visibleForTesting
//   final bool isTesting;
//   final PickPhotoModel pickPhotoModel;
//   final Function(bool) onPhotoFinishedUploading;
//   PhotoPickerBloc(this.pickPhotoModel,
//       {required this.onPhotoFinishedUploading, this.isTesting = false});

//   final BehaviorSubject<List<CapturePhotoModel>> _capturedImagesController =
//       BehaviorSubject.seeded([]);

//   List<PictureSide> get requestedSides => pickPhotoModel.pictures;

//   int get numberOfRequestedImages => requestedSides.length;

//   String get requestedSidesDescription {
//     String body = "";
//     for (int index = 0; index < requestedSides.length; index++) {
//       body = body + StringHelper.pictureSideToString(requestedSides[index]);
//       if (index == requestedSides.length - 1) {
//         body = body + (requestedSides.length == 1 ? " photo" : " photos");
//       } else {
//         body = body + " and ";
//       }
//     }
//     return body;
//   }

//   Future<PosePhotoModel> get currentPosePhotoModel async {
//     PosePhotoModel model = PosePhotoModel();

//     for (CapturePhotoModel captureModel in _capturedImagesController.value) {
//       String imageBase64Format =
//           "data:image/jpeg;base64," + await captureModel.imageBase64();

//       switch (captureModel.side) {
//         case PictureSide.front:
//           model.front = UserPhotoModel(imageBase64Format);
//           break;
//         case PictureSide.right:
//           model.right = UserPhotoModel(imageBase64Format);
//           break;
//         case PictureSide.left:
//           model.left = UserPhotoModel(imageBase64Format);
//           break;
//         case PictureSide.top:
//           model.top = UserPhotoModel(imageBase64Format);
//           break;
//         default:
//       }
//     }
//     return model;
//   }

//   Stream<List<CapturePhotoModel>> get capturedImagesStream =>
//       _capturedImagesController.stream;

//   Future<void> onTookPhoto(CapturePhotoModel capturePhotoModel) async {
//     List<CapturePhotoModel> images = _capturedImagesController.value;

//     /// We remove previous image if exist to prevent duplicate
//     int index = images.indexWhere((CapturePhotoModel photoModel) =>
//         photoModel.side == capturePhotoModel.side);
//     if (index != -1) {
//       images.removeAt(index);
//     }
//     images.add(capturePhotoModel);
//     _capturedImagesController.add(images);
//   }

//   XFile? imageForSide(PictureSide side, List<CapturePhotoModel> models) {
//     List<CapturePhotoModel> matchedModels =
//         models.where((CapturePhotoModel model) => model.side == side).toList();
//     if (matchedModels.isNotEmpty) {
//       return matchedModels.first.image;
//     }
//     return null;
//   }

//   void gotoCaptureScreen(PictureSide side) {
//     CameraCaptureBloc bloc = CameraCaptureBloc(onTookPhoto, side);
//     _navigationService.pushNamed(CameraCaptureScreen.routeName,
//         arguments: bloc);
//   }

//   Future<void> submitButtonPressed() async {
//     PosePhotoModel posePhotoModel = await currentPosePhotoModel;
//     if (!isTesting) {
//       _navigationService.pop();
//     }
//     bool result = await _cloudFunctionsInterface.uploadPhotos(
//         posePhotoModel, pickPhotoModel);
//     onPhotoFinishedUploading(result);
//   }

//   void dispose() {
//     _capturedImagesController.close();
//   }
// }
