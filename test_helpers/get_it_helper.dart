// import 'package:get_it/get_it.dart';
// import 'package:optima_soft/api/cloud_functions_interface/cloud_functions_interface.dart';
// import 'package:optima_soft/api/local_cache_interface/local_cache_interface.dart';
// import 'package:optima_soft/helpers/platform_helper.dart';
// import 'package:optima_soft/services/navigation_service.dart';
// import 'cloud_functions_interface_mocks.dart';
// import 'shared_preferences_mock.dart';

// class GetItHelper {
//   static void setupTestDependencies(
//       {SharedPreferencesMock? sharedPreferencesMock,
//       PlatformHelperMock? platformHelperMock,
//       CloudFunctionsInterfaceMock? cloudFunctionsInterfaceMock}) {
//     GetIt getIt = GetIt.instance;
//     getIt.reset();
//     // getIt.registerLazySingleton<NavigationService>(
//     //     () => new NavigationService());

//     // Add navigation service to dependency tree
//     getIt.registerSingleton(NavigationService());

//     // Add local cache interface to dependency tree
//     getIt.registerSingleton(
//       LocalCacheInterface(
//           Future.value(sharedPreferencesMock ?? SharedPreferencesMock())),
//     );

//     // Add cloud function interface service to dependency tree
//     getIt.registerFactory<CloudFunctionsInterface>(
//         () => cloudFunctionsInterfaceMock ?? CloudFunctionsInterfaceMock());

//     // Add platform helper to dependency tree
//     getIt.registerFactory(() => platformHelperMock ?? PlatformHelper());
//   }
// }
