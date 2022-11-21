import 'dart:isolate';
import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:task_api/pages/home_page/home_provider.dart';
import 'package:task_api/pages/home_page/widgets/lesson_widget.dart';
import 'package:task_api/service/video_src.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final VidService? vidService;

  int progres = 0;

  final ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    SendPort? sendPort = IsolateNameServer.lookupPortByName('downloading');

    sendPort!.send([id, status, progress]);
  }

  @override
  void initState() {
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, 'downloading');

    _receivePort.listen((message) {
      setState(() {
        progres = message[2];
      });
    });

    context.read<HomeProvider>();
    vidService = VidService();
    FlutterDownloader.registerCallback(downloadingCallback);
    super.initState();
  }

  @override
  void dispose() {
    vidService!.dispose();
    super.dispose();
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
                          ),
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
                            onPressed: () async {
                              final status = await Permission.storage.request();
                              if (status.isGranted) {
                                final externalDir =
                                    await getExternalStorageDirectory();

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
                            },
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
                  child: Column(
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
                        child: Builder(builder: (context) {
                          return Container(
                            height: 160.h,
                            width: 344.w,
                            decoration: BoxDecoration(
                                color: Colors.red,
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
                          );
                        }),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onDoubleTap: () {},
                            child: LessonsWidget(
                              color: Colors.blue,
                              iconData: Icons.book_outlined,
                              label: 'Grammar',
                            ),
                          ),
                          LessonsWidget(
                            color: Colors.green,
                            iconData: Icons.menu_book_rounded,
                            label: 'Vocabulary',
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LessonsWidget(
                            color: Colors.deepPurple,
                            iconData: Icons.person_outline,
                            label: 'Speaking',
                          ),
                          LessonsWidget(
                            color: Colors.orange,
                            iconData: Icons.headphones,
                            label: 'Listening',
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Container(
                        height: 131.h,
                        width: 344.w,
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                                top: 0.0,
                                right: 0.0,
                                child: Image.asset('assets/images/naqsh.png')),
                            Padding(
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
