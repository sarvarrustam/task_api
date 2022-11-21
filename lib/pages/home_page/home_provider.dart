import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task_api/models/post_model.dart';
import 'package:task_api/service/api_servise.dart';

class HomeProvider with ChangeNotifier {
  late final connectivity;
  late final StreamSubscription subscription;
  Post? post;
  late BuildContext context;
  HomeProvider(this.context) {
    connectivity = Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen(connectivityListener);
  }
  void onDowlander() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final externalDir = await getExternalStorageDirectory();

      final id = await FlutterDownloader.enqueue(
        url:
            'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        savedDir: externalDir!.path,
        fileName: 'download',
        showNotification: true,
        openFileFromNotification: true,
      );
    } else {
      print('permission deined');
    }
  }

  connectivityListener(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.bluetooth:
        // TODO: Handle this case.
        break;
      case ConnectivityResult.wifi:
        assert(post == null);
        post = await DioServise.getPostResponse();
        // ignore: use_build_context_synchronously
        show(context);
        // ignore: use_build_context_synchronously
        notifyListeners();
        break;
      case ConnectivityResult.ethernet:
        // TODO: Handle this case.
        break;
      case ConnectivityResult.mobile:
        assert(post == null);
        post = await DioServise.getPostResponse();
        // ignore: use_build_context_synchronously
        show(context);
        notifyListeners();
        break;
      case ConnectivityResult.none:
        // TODO: Handle this case.
        break;
      case ConnectivityResult.vpn:
        // TODO: Handle this case.
        break;
    }
  }

  void show(BuildContext context) {
    assert(post != null);
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: const Text('text'),
              children: [
                CachedNetworkImage(
                  imageUrl: post!.urls!.small!,
                  placeholder: (context, url) => const SizedBox(),
                  errorWidget: (context, url, error) =>
                      const Text('You have an error'),
                  width: 200,
                  height: 100,
                ),
              ],
            ));
  }

  void close() {
    subscription.cancel();
    notifyListeners();
  }
}
