import 'package:optima_soft/models/user_photo_model.dart';

class PosePhotoModel {
  UserPhotoModel? top;
  UserPhotoModel? front;
  UserPhotoModel? left;
  UserPhotoModel? right;

  PosePhotoModel({this.top, this.front, this.left, this.right});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'top': top?.toJson(),
      'front': front?.toJson(),
      'left': left?.toJson(),
      'right': right?.toJson(),
    };
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
