import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../configs/app_color.dart';
class RingLoading extends StatelessWidget {
  const RingLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(

          child: SpinKitRing(
            color: AppColor.blue,
            lineWidth: 5,
            size: 25,
            duration: Duration(seconds: 1),
          )),
    );
  }
}
