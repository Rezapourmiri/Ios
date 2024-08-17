// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:optima_soft/helpers/colors.dart';
// import 'package:optima_soft/helpers/platform_helper.dart';
// import 'package:optima_soft/helpers/string_helpers.dart';
// import 'package:optima_soft/models/capture_photo_model.dart';
// import 'package:optima_soft/modules/photo_picker_screen/photo_picker_bloc.dart';
// import 'package:optima_soft/widgets/floating_button.dart';

// class PhotoPickerScreen extends StatefulWidget {
//   static const routeName = "/PhotoPickerScreen";

//   const PhotoPickerScreen({Key? key}) : super(key: key);

//   @override
//   _PhotoPickerScreenState createState() => _PhotoPickerScreenState();
// }

// class _PhotoPickerScreenState extends State<PhotoPickerScreen> {
//   late PhotoPickerBloc _bloc;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _bloc = Provider.of(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: Theme.of(context).backgroundColor,
//           elevation: 0,
//           title: pageTitle(),
//           actions: [
//             _buildCloseButton(),
//           ],
//         ),
//         backgroundColor: Theme.of(context).backgroundColor,
//         body: mainContent());
//   }

//   Widget pageTitle() {
//     return Text(
//       "Photos",
//       style: TextStyle(
//           color: Colors.black,
//           fontSize: StringHelper.generateProportionateFontSize(20),
//           fontWeight: FontWeight.w500),
//     );
//   }

//   Widget _buildCloseButton() {
//     return Padding(
//       padding: EdgeInsets.only(right: PlatformHelper.screenWidth * 0.03),
//       child: FloatingButton(
//         Icons.close,
//         () {
//           Navigator.of(context).pop();
//         },
//         color: borderColor,
//         iconColor: corduroy,
//         buttonShape: FloatingButtonShape.circular,
//         isShadowEnabled: false,
//       ),
//     );
//   }

//   Widget mainContent() {
//     return Padding(
//       padding:
//           EdgeInsets.symmetric(horizontal: PlatformHelper.screenWidth * 0.03),
//       child: Column(
//         children: [
//           header(),
//           bodyText(),
//           buildPhotoGrid(),
//           buildSubmitButton(),
//         ],
//       ),
//     );
//   }

//   Widget header() {
//     return Text(
//       "Your doctor has requested photos",
//       style: TextStyle(
//           fontSize: StringHelper.generateProportionateFontSize(24),
//           fontWeight: FontWeight.w600),
//     );
//   }

//   Widget bodyText() {
//     return Padding(
//       padding: EdgeInsets.only(
//           top: PlatformHelper.screenHeight * 0.03,
//           bottom: PlatformHelper.screenHeight * 0.02),
//       child: Text(
//         "Let’s take the ${_bloc.requestedSidesDescription} as requested by your doctor. Only your doctors will be able to access these photos.",
//         style: TextStyle(
//             fontSize: StringHelper.generateProportionateFontSize(17),
//             fontWeight: FontWeight.normal),
//       ),
//     );
//   }

//   Widget buildPhotoGrid() {
//     return StreamBuilder(
//         stream: _bloc.capturedImagesStream,
//         builder: (_, AsyncSnapshot<List<CapturePhotoModel>> snapshot) {
//           /// This implementation only supports 2 columns.
//           /// code should be updated if more needed.
//           List<Widget> photoBoxes = buildPhotoBoxes(snapshot);
//           List<Row> rows = buildRows(photoBoxes);

//           return SizedBox(
//             height: PlatformHelper.screenHeight * 0.52,
//             child: Column(children: rows),
//           );
//         });
//   }

//   List<Widget> buildPhotoBoxes(
//       AsyncSnapshot<List<CapturePhotoModel>> snapshot) {
//     return _bloc.requestedSides.map((PictureSide side) {
//       ImageProvider? image;

//       if (snapshot.hasData && (snapshot.data?.length ?? 0) > 0) {
//         XFile? imageFile = _bloc.imageForSide(side, snapshot.data ?? []);
//         if (imageFile != null) {
//           image = FileImage(File(imageFile.path));
//         }
//       }
//       return buildEachPhotoBox(
//           side, image ?? const AssetImage("assets/images/camera.png"));
//     }).toList();
//   }

//   List<Row> buildRows(List<Widget> photoBoxes) {
//     int numberOfRows = (_bloc.numberOfRequestedImages / 2).round();
//     return List.generate(numberOfRows, (index) {
//       ///
//       /// If is first row start from zero else
//       ///  start from 3 since number of columns is 2.
//       ///
//       int startRange = index == 1 ? 2 : 0;
//       int endRange = _bloc.numberOfRequestedImages;
//       if (index == 0) {
//         // Max 2 column in a row.
//         endRange = endRange > 2 ? 2 : endRange;
//       } else if (index == 1) {
//         endRange = endRange == startRange ? endRange + 1 : endRange;
//       }
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: photoBoxes.getRange(startRange, endRange).toList(),
//       );
//     });
//   }

//   Widget buildEachPhotoBox(
//     PictureSide side,
//     ImageProvider imageProvider,
//   ) {
//     double containerSize = PlatformHelper.screenWidth * 0.45;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//             padding: EdgeInsets.symmetric(
//                 vertical: PlatformHelper.screenHeight * 0.02),
//             child: Text(StringHelper.pictureSideToString(side).toSentenceCase,
//                 style: TextStyle(
//                     fontSize: StringHelper.generateProportionateFontSize(17),
//                     fontWeight: FontWeight.normal))),
//         GestureDetector(
//             onTap: () {
//               _bloc.gotoCaptureScreen(side);
//             },
//             child: Container(
//               constraints: BoxConstraints(
//                 maxWidth: containerSize,
//                 maxHeight: containerSize,
//               ),
//               width: containerSize,
//               height: containerSize * 0.7,
//               decoration: BoxDecoration(
//                 color: borderColor,
//                 borderRadius: BorderRadius.circular(10),
//                 image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
//               ),
//             )),
//       ],
//     );
//   }

//   Widget buildSubmitButton() {
//     return Padding(
//       padding: EdgeInsets.only(top: PlatformHelper.screenHeight * 0.02),
//       child: GestureDetector(
//         onTap: _bloc.submitButtonPressed,
//         child: Container(
//           height: PlatformHelper.screenHeight * 0.08,
//           width: double.infinity,
//           decoration: BoxDecoration(
//               color: Colors.black, borderRadius: BorderRadius.circular(8)),
//           child: Align(
//             alignment: Alignment.center,
//             child: Text(
//               "Submit",
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: StringHelper.generateProportionateFontSize(17),
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _bloc.dispose();
//   }
// }
