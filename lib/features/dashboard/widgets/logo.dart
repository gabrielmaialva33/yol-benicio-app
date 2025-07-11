import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo YOL
        Image.asset(
          'assets/images/logo-yol.svg',
          width: 193,
          height: 42,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 193,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xFF1F2A37),
              ),
              child: const Center(
                child: Text(
                  'YOL',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}