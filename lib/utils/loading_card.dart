import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class LoadingCard extends StatelessWidget {
  final double? height;
  final Color? color;
  const LoadingCard({Key? key, required this.height, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: SkeletonAnimation(
        child: Container(
          decoration: BoxDecoration(
              color: color == null ? Theme.of(context).colorScheme.onBackground : color, 
              borderRadius: BorderRadius.circular(5)),
          height: height,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}