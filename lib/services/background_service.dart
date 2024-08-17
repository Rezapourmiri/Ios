import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:workmanager/workmanager.dart';

const simplePeriodic1HourTask = "simplePeriodic1HourTask";

// class BackgroundService {
//   void callbackDispatcher() {
//     Workmanager().executeTask((task, inputData) async {
//       switch (task) {
//         case simplePeriodic1HourTask:
//           Position position = await Geolocator.getCurrentPosition(
//               desiredAccuracy: LocationAccuracy.high);
//           if (kDebugMode) {
//             print('${position.latitude}, ${position.longitude}');
//           }
//           break;
//       }

//       return Future.value(true);
//     });
//   }
// }
