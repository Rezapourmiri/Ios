// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:optima_soft/helpers/platform_helper.dart';
// import 'package:optima_soft/modules/pdf_loader_screen/pdf_loader_bloc.dart';
// import 'package:optima_soft/widgets/floating_button.dart';

// class PDFLoaderScreen extends StatefulWidget {
//   static const routeName = "/PDFLoaderScreen";

//   @override
//   _PDFLoaderScreenState createState() => _PDFLoaderScreenState();
// }

// class _PDFLoaderScreenState extends State<PDFLoaderScreen> {
//   PDFLoaderBloc _bloc;

//   @override
//   void didChangeDependencies() async {
//     super.didChangeDependencies();
//     _bloc = Provider.of(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).backgroundColor,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             _buildPDFViewer(),
//             _buildCloseButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPDFViewer() {
//     return FutureBuilder(
//         future: _bloc.getRemotePDF,
//         builder: (_, AsyncSnapshot<PDFDocument> snapshot) {
//           if (snapshot.hasData) {
//             return PDFViewer(
//               document: snapshot.data,
//               indicatorPosition: IndicatorPosition.topLeft,
//             );
//           }
//           return Center(
//             child: CupertinoActivityIndicator(
//               animating: true,
//               radius: 20,
//             ),
//           );
//         });
//   }

//   Widget _buildCloseButton() {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//           horizontal: PlatformHelper.screenWidth * 0.05,
//           vertical: PlatformHelper.screenHeight * 0.02),
//       child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
//         FloatingButton(Icons.close, () {
//           Navigator.of(context).pop();
//         }),
//       ]),
//     );
//   }
// }
