class UserPhotoModel {
  final String imageBinary;

  UserPhotoModel(this.imageBinary);

  Map<String, dynamic> toJson() =>
      {'originalPhotoURL': '', 'imageBinary': imageBinary, 'thumbnails': []};
}
