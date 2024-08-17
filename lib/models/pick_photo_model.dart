// import 'package:flutter/material.dart';
// import 'package:optima_soft/helpers/string_helpers.dart';
// import 'package:optima_soft/modules/photo_picker_screen/photo_picker_bloc.dart';

// class PickPhotoModel {
//   final String token;
//   final int taskId;
//   final List<PictureSide> pictures;
//   PickPhotoModel(
//       {required this.taskId, required this.token, required this.pictures});

//   PickPhotoModel.fromJson(Map<String, dynamic> json)
//       : token = json["token"],
//         taskId = json["taskId"],
//         pictures = getPictureSides(json["pictures"]);

//   ///
//   /// Converts list of string picture sides to `PictureSide object.
//   ///
//   @visibleForTesting
//   static List<PictureSide> getPictureSides(List<dynamic> pictures) {
//     List<String> pictureStrings = pictures.map((var item) => "$item").toList();
//     return pictureStrings
//         .map((String picture) => StringHelper.stringToPictureSide(picture))
//         .toList();
//   }
// }
