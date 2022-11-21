import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VidService {
  late final VideoPlayerController? videoPlayerControler;

  static final _inctance = VidService._init();
  late final ChewieController? _chewie;
  VidService._init() {
    videoPlayerControler = VideoPlayerController.network(
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true));
    initialize();
    assert(videoPlayerControler != null);
    _chewie = ChewieController(
        videoPlayerController: videoPlayerControler!,
        autoPlay: true,
        looping: true);
    log('VIDEO PLAYER INITED');
  }

  factory VidService() => _inctance;

  void initialize() async {
    try {
      await videoPlayerControler!.initialize();
    } catch (e) {
      log(e.toString());
    }
  }

  ChewieController get chewie => _chewie!;

  void dispose() {
    videoPlayerControler!.dispose();
    _chewie!.dispose();
  }
}
