import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BenicioBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BenicioBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F7),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              icon: FontAwesomeIcons.house,
              label: 'Home',
              isActive: currentIndex == 0,
            ),
            _buildNavItem(
              index: 1,
              icon: FontAwesomeIcons.folder,
              label: 'Pastas',
              isActive: currentIndex == 1,
            ),
            _buildNavItem(
              index: 2,
              icon: FontAwesomeIcons.magnifyingGlass,
              label: 'Buscar',
              isActive: currentIndex == 2,
            ),
            _buildNavItem(
              index: 3,
              icon: FontAwesomeIcons.chartPie,
              label: 'Relatórios',
              isActive: currentIndex == 3,
            ),
            _buildNavItem(
              index: 4,
              icon: FontAwesomeIcons.user,
              label: 'Perfil',
              isActive: currentIndex == 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () {
        onTap(index);
        HapticFeedback.lightImpact();
      },
      behavior: HitTestBehavior.translucent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF582FFF).withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              size: 20,
              color:
                  isActive ? const Color(0xFF582FFF) : const Color(0xFF484C52),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Row(
                children: [
                  if (isActive) ...[
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF582FFF),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
