import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/listening_effect_cubit/listening_effect_cubit.dart';
import '../../configs/app_color.dart';

class CircleButtonEffect extends StatelessWidget {
  const CircleButtonEffect(
      {Key? key, required this.icon, required this.color, required this.index})
      : super(key: key);
  final IconData icon;
  final Color color;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<ListeningEffectCubit>(context).updateEffect(index);
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColor.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0.0, 3.0),
              spreadRadius: 2,
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: 30,
        ),
      ),
    );
  }
}
