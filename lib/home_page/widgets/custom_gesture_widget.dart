import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomGesture extends StatelessWidget {
  final VoidCallback onDoubleTap;
  final VoidCallback onTripleTap;
  final Widget child;
  const CustomGesture(
      {super.key,
      required this.onDoubleTap,
      required this.onTripleTap,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        SerialTapGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<SerialTapGestureRecognizer>(
          () => SerialTapGestureRecognizer(),
          (SerialTapGestureRecognizer instance) {
            instance.onSerialTapDown = (SerialTapDownDetails details) {
              if (details.count == 2) {
                onDoubleTap();
              } else if (details.count == 3) {
                onTripleTap();
              }
            };
          },
        )
      },
      child: child,
    );
  }
}
