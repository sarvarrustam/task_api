import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class LessonsWidget extends StatelessWidget {
  Color? color;
  IconData? iconData;
  String? label;

  LessonsWidget({
    required this.color,
    required this.iconData,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 164.w,
      height: 164.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
      ),
      child: Stack(
        children: [
          Positioned(
              top: 0.0,
              right: 0.0,
              child: Image.asset('assets/images/naqsh.png')),
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  iconData,
                  color: Colors.white,
                  size: 37.sp,
                ),
                SizedBox(
                  height: 50.h,
                ),
                Text(
                  label!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 8.h,
                      width: 60.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          minHeight: 8.h,
                          value: 0.1,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const Text(
                      '0%',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
