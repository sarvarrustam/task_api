import 'dart:isolate';
import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:task_api/home_page/home_provider.dart';
import 'package:task_api/home_page/widgets/custom_gesture_widget.dart';
import 'package:task_api/home_page/widgets/lesson_widget.dart';
import 'package:task_api/service/video_src.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final VidService? vidService;

  final ReceivePort _receivePort = ReceivePort();
  bool? isHomework;

  Future download(String url) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();

      await FlutterDownloader.enqueue(
        url: url,
        headers: {}, // optional: header send with url (auth token etc)
        savedDir: baseStorage!.path,
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
    }
  }

  final ReceivePort _port = ReceivePort();
  @override
  void initState() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      if (status == DownloadTaskStatus.complete) {
        print('Download complate');
      }
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
    context.read<HomeProvider>();
    vidService = VidService();
    super.initState();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    vidService!.dispose();
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        bottomOpacity: 0.0,
        title: Text(
          'ROUNDED TASK',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              SizedBox(height: 18.h),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                  image: AssetImage('assets/images/person.png'),
                                  fit: BoxFit.cover)),
                          width: 96.w,
                          height: 96.w,
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Lesson 2',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Text(
                                'How to talk about nation Asilbek Asqarov Asilbek',
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              side: BorderSide(width: 2.w, color: Colors.blue)),
                          child: SizedBox(
                            width: 143.w,
                            height: 40.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Saqlab qo\'yish ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.sp)),
                                const Icon(
                                  Icons.bookmark_border_outlined,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 160.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(15)),
                          child: TextButton(
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Yuklab olish ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      fontSize: 13.sp),
                                ),
                                const Icon(
                                  Icons.cloud_download_outlined,
                                  color: Colors.white,
                                )
                              ],
                            ),
                            onPressed: () => download(
                                'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24.h, bottom: 24.h),
                      child: const Divider(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Consumer<HomeProvider>(builder: (context, home, _) {
                    isHomework = home.isHomework;
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => SimpleDialog(
                                      children: [
                                        Card(
                                          child: SizedBox(
                                            height: 200,
                                            child: Chewie(
                                                controller: vidService!.chewie),
                                          ),
                                        ),
                                        FloatingActionButton(
                                          onPressed: () async {
                                            await vidService!.chewie.pause();
                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).pop();
                                          },
                                          mini: true,
                                          child: const Icon(Icons.exit_to_app),
                                        )
                                      ],
                                    ));
                          },
                          child: Container(
                            height: 160.h,
                            width: 344.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/children.png'),
                                    fit: BoxFit.cover)),
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.6),
                                      Colors.black.withOpacity(0.5),
                                      Colors.black.withOpacity(0.2),
                                    ],
                                    tileMode: TileMode.mirror,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 16.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'How to speak like a native',
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                    Icon(
                                      Icons.play_circle_outlined,
                                      color: Colors.white,
                                      size: 30.sp,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomGesture(
                              onDoubleTap: () => home.enableGrammer(false),
                              onTripleTap: () => home.enableGrammer(true),
                              child: LessonsWidget(
                                isBlock: !home.isGrammer,
                                color: Colors.blue,
                                iconData: Icons.book_outlined,
                                label: 'Grammar',
                              ),
                            ),
                            CustomGesture(
                              onDoubleTap: () => home.enableVoceblary(false),
                              onTripleTap: () => home.enableVoceblary(true),
                              child: LessonsWidget(
                                isBlock: home.isVocalbary,
                                color: Colors.green,
                                iconData: Icons.menu_book_rounded,
                                label: 'Vocabulary',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomGesture(
                              onDoubleTap: () => home.enableSpeaking(false),
                              onTripleTap: () => home.enableSpeaking(true),
                              child: LessonsWidget(
                                isBlock: home.isSpeaking,
                                color: Colors.deepPurple,
                                iconData: Icons.person_outline,
                                label: 'Speaking',
                              ),
                            ),
                            CustomGesture(
                              onDoubleTap: () => home.enableListening(false),
                              onTripleTap: () => home.enableListening(true),
                              child: LessonsWidget(
                                isBlock: home.isListening,
                                color: Colors.orange,
                                iconData: Icons.headphones,
                                label: 'Listening',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        CustomGesture(
                          onDoubleTap: () => home.enableHomework(false),
                          onTripleTap: () => home.enableHomework(true),
                          child: isHomework!
                              ? Container(
                                  width: 344.w,
                                  height: 131.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: const Color(0xFF27244b)),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                          top: 0.0,
                                          right: 0.0,
                                          child: Image.asset(
                                              'assets/images/naqsh.png')),
                                      Positioned(
                                          top: 25.h,
                                          right: 20.w,
                                          child: Image.asset(
                                              'assets/images/kubik.png')),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(14.w),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Homework',
                                                    style: TextStyle(
                                                        fontSize: 16.sp,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  SizedBox(
                                                    height: 8.h,
                                                  ),
                                                  Text(
                                                    'Bu joyda barcha ishtirokchilar \ndarajalari bilan tanishing',
                                                    style: TextStyle(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                    height: 14.h,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      SizedBox(
                                                        height: 8.h,
                                                        width: 100.w,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child:
                                                              LinearProgressIndicator(
                                                            minHeight: 8.h,
                                                            value: 0.0,
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                      ),
                                                      const Text(
                                                        ' 0%',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  )
                                                ]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  width: 344.w,
                                  height: 131.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: const Color(0xFF27244b)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withOpacity(1),
                                            Colors.black.withOpacity(1),
                                            Colors.black.withOpacity(1),
                                          ],
                                          // tileMode: TileMode.decal,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        image: const DecorationImage(
                                            image: AssetImage(
                                                'assets/images/crown.png'))),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                            top: 0.0,
                                            right: 0.0,
                                            child: Image.asset(
                                                'assets/images/naqsh.png')),
                                        Positioned(
                                            top: 25.h,
                                            right: 20.w,
                                            child: Image.asset(
                                                'assets/images/kubik.png')),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(14.w),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Homework',
                                                      style: TextStyle(
                                                          fontSize: 16.sp,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    SizedBox(
                                                      height: 8.h,
                                                    ),
                                                    Text(
                                                      'Bu joyda barcha ishtirokchilar \ndarajalari bilan tanishing',
                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white),
                                                    ),
                                                    SizedBox(
                                                      height: 14.h,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        SizedBox(
                                                          height: 8.h,
                                                          width: 100.w,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child:
                                                                LinearProgressIndicator(
                                                              minHeight: 8.h,
                                                              value: 0.0,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          ),
                                                        ),
                                                        const Text(
                                                          ' 0%',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )
                                                      ],
                                                    )
                                                  ]),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
