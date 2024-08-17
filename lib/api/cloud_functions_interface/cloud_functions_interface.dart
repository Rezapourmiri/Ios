import 'package:http/http.dart' show Response;

class CloudFunctionsInterface {
  ///
  /// Returns true if response indicates success, false if it indicates failure.
  ///
  static bool isSuccessResponseCode(Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  ///
  /// Uploads `PosePhotoModel` to the server.
  ///
  // Future<bool> uploadPhotos(
  //     PosePhotoModel posePhotoModel, PickPhotoModel pickPhotoModel) async {
  //   String endpoint =
  //       Endpoints.submitTaskForm + "?TaskId=${pickPhotoModel.taskId}";
  //   String urlString =
  //       await EnvironmentHelpers.backendUrlFromEndpoint(endpoint);
  //   if (kDebugMode) {
  //     print("upload photo to: $urlString");
  //   }
  //   Response response = await http.post(
  //     Uri.parse(urlString),
  //     headers: {
  //       HttpHeaders.authorizationHeader: "Bearer ${pickPhotoModel.token}",
  //       HttpHeaders.contentTypeHeader: "application/json"
  //     },
  //     body: jsonEncode(posePhotoModel),
  //   );
  //   if (kDebugMode) {
  //     print("resquest response code:${response.statusCode}");
  //   }
  //   Map<String, dynamic> responseJson = jsonDecode(response.body);
  //   List<dynamic> validationErrors = responseJson["validationErrors"];

  //   return isSuccessResponseCode(response) && (validationErrors.isEmpty);
  // }
}
