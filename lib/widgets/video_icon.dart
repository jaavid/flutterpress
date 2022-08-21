import 'package:flutter/material.dart';
import 'package:kermaneno/config/wp_config.dart';

class VideoIcon extends StatelessWidget {
  final List? tags;
  final double iconSize;
  const VideoIcon({Key? key, required this.tags, required this.iconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tags == null || !tags!.contains(WpConfig.videoTagId))
      return Container();
    else
      return Align(
        alignment: Alignment.center,
        child: Icon(Icons.play_circle_fill_outlined,
            color: Colors.white, size: iconSize),
      );
  }
}
