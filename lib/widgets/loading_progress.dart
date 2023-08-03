import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../configs/app_color.dart';
class LoadingProgress extends StatelessWidget {
  const LoadingProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
          child: SpinKitCircle(
            color: AppColor.blue,
            size: 50.0,
            duration: Duration(seconds: 1),
          )),
    );
  }
}
