// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// class DowlanderSrc {
//   void dowlander() async {
//     final status = await Permission.storage.request();

//     if (status.isGranted) {
//       final externalDir = await getExternalStorageDirectory();

//       final id = await FlutterDownloader.enqueue(
//         url:
//             'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
//         savedDir: externalDir!.path,
//         fileName: 'download',
//         showNotification: true,
//         openFileFromNotification: true,
//       );
//     } else {
//       print('permission deined');
//     }
//   }
// }
