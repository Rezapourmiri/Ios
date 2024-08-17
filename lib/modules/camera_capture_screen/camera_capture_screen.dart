// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:optima_soft/helpers/platform_helper.dart';
// import 'package:optima_soft/helpers/string_helpers.dart';
// import 'package:optima_soft/modules/camera_capture_screen/camera_capture_bloc.dart';
// import 'package:optima_soft/widgets/circle_painter.dart';
// import 'package:optima_soft/widgets/floating_button.dart';
// import 'package:optima_soft/widgets/shape_painter.dart';

// class CameraCaptureScreen extends StatefulWidget {
//   static const routeName = "/CameraCaptureScreen";

//   const CameraCaptureScreen({Key? key}) : super(key: key);

//   @override
//   _CameraCaptureScreenState createState() => _CameraCaptureScreenState();
// }

// class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
//   late CameraCaptureBloc _bloc;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _bloc = Provider.of(context);
//     _bloc.initializeCamera();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Theme.of(context).backgroundColor,
//         body: mainContainer());
//   }

//   Widget mainContainer() {
//     return Stack(
//       children: [
//         buildCameraPreview(),
//         overlayBuilder(),
//         buildOverlayContent(),
//       ],
//     );
//   }

//   Widget overlayBuilder() {
//     return SizedBox(
//       height: PlatformHelper.screenHeight,
//       width: PlatformHelper.screenWidth,
//       child: CustomPaint(
//         painter: ShapePainter(
//             opacity: 0.5,
//             rect: Rect.fromLTWH(
//                 PlatformHelper.screenWidth * 0.04,
//                 PlatformHelper.screenHeight * 0.19,
//                 PlatformHelper.screenWidth * 0.92,
//                 PlatformHelper.screenHeight * 0.5),
//             color: Colors.black),
//       ),
//     );
//   }

//   Widget buildCameraPreview() {
//     return StreamBuilder(
//         stream: _bloc.cameraControllerStream,
//         builder: (_, AsyncSnapshot<CameraController> snapshot) {
//           if (snapshot.hasData) {
//             return Container(
//               height: PlatformHelper.screenHeight,
//               color: Colors.black,
//               child: CameraPreview(snapshot.data),
//             );
//           }
//           return Container(
//             height: PlatformHelper.screenHeight,
//             color: Colors.black,
//             child: const Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         });
//   }

//   Widget buildOverlayContent() {
//     return Padding(
//       padding:
//           EdgeInsets.symmetric(horizontal: PlatformHelper.screenWidth * 0.04),
//       child: Column(children: [
//         headerTitle(),
//         bodyText(),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [closeButton(), captureButton(), switchCameraButton()],
//         )
//       ]),
//     );
//   }

//   Widget headerTitle() {
//     return Padding(
//       padding: EdgeInsets.only(
//           top: PlatformHelper.screenHeight * 0.1,
//           bottom: PlatformHelper.screenHeight * 0.05),
//       child: Text(
//         "${_bloc.pictureSide} photo".toSentenceCaseAll,
//         style: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.w500,
//           fontSize: StringHelper.generateProportionateFontSize(34),
//         ),
//       ),
//     );
//   }

//   Widget bodyText() {
//     return Padding(
//       padding: EdgeInsets.only(
//           top: PlatformHelper.screenHeight * 0.52,
//           bottom: PlatformHelper.screenHeight * 0.05),
//       child: Text(
//         "Please use the camera button below to take a photo.",
//         textAlign: TextAlign.center,
//         style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w500,
//             fontSize: StringHelper.generateProportionateFontSize(18)),
//       ),
//     );
//   }

//   Widget captureButton() {
//     double buttonSize = PlatformHelper.screenWidth * 0.18;
//     return GestureDetector(
//         onTap: _bloc.captureButtonPressed,
//         child: Container(
//           width: buttonSize,
//           height: buttonSize,
//           decoration:
//               const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
//           child: CustomPaint(
//             painter: CirclePainter(
//                 color: Colors.black,
//                 strokeWidth: 1,
//                 size: Size(buttonSize * 0.7, buttonSize * 0.7)),
//           ),
//         ));
//   }

//   Widget closeButton() {
//     return FloatingButton(
//       Icons.close_outlined,
//       _bloc.closeButtonPressed,
//       buttonShape: FloatingButtonShape.circular,
//       isShadowEnabled: false,
//     );
//   }

//   Widget switchCameraButton() {
//     return FloatingButton(
//       Icons.cameraswitch_sharp,
//       _bloc.switchCameraPressed,
//       buttonShape: FloatingButtonShape.circular,
//       isShadowEnabled: false,
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _bloc.dispose();
//   }
// }
