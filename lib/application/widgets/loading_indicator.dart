import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart' as indicator;

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          SizedBox(
              width: 200,
              height: 100,
              child: indicator.LoadingIndicator(
                  indicatorType: indicator.Indicator.lineScalePulseOut))
        ]);
  }
}
