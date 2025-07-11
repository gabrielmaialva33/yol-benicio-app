import 'package:flutter/material.dart';

class YolLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final bool showText;

  const YolLogo({
    Key? key,
    this.width,
    this.height,
    this.showText = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width ?? 40,
          height: height ?? 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: const DecorationImage(
              image: AssetImage('assets/images/yol_logo_circle_orange.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 12),
          Text(
            'YOL',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ],
    );
  }
}
