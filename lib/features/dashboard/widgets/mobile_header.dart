import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MobileHeader extends StatelessWidget {
  const MobileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/yol_logo_circle_orange.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'YOL',
                    style: TextStyle(
                      fontFamily: 'Roboto Mono',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF000000),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Container(
                    width: 26.36,
                    height: 18.35,
                    child: Stack(
                      children: [
                        Positioned(
                          child: Container(
                            width: 26.36,
                            height: 8.36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 4.5,
                          top: 6,
                          child: Container(
                            width: 17.17,
                            height: 6.4,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 9.19,
                          top: 9,
                          child: Container(
                            width: 7.98,
                            height: 5.94,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  Container(
                    width: 27.91,
                    height: 18.6,
                    child: SvgPicture.asset(
                      'assets/icons/user_icon.svg',
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF1E293B),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  Container(
                    width: 37.05,
                    height: 18.15,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF1E293B).withOpacity(0.35),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 5,
                          top: 4,
                          child: Container(
                            width: 20,
                            height: 10,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 6,
                          child: Container(
                            width: 2,
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B).withOpacity(0.4),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Container(
                width: 193,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'VIVO FIBRA',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/menu_icon.svg',
                    width: 30,
                    height: 30,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFA1A5B7),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/search_icon.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFA1A5B7),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
