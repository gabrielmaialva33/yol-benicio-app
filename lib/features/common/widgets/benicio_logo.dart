import 'package:flutter/material.dart';

class BenicioLogo extends StatelessWidget {
  final double? width;
  final double? height;

  const YolLogo({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 40,
      height: height ?? 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(
          image: AssetImage('assets/images/yol_logo_circle_orange.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
