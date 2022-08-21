import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: 45,
        height: 60,
        child: LoadingIndicator(
          indicatorType: Indicator.ballBeat,
          pathBackgroundColor: Theme.of(context).primaryColor,
        ));
  }
}
