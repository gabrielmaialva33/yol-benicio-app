import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class BenicioBottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BenicioBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<BenicioBottomNavigation> createState() =>
      _BenicioBottomNavigationState();
}

class _BenicioBottomNavigationState extends State<BenicioBottomNavigation>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _bounceAnimations;

  @override
  void initState() {
    super.initState();
    _animationControllers = List.generate(
      6,
          (index) =>
          AnimationController(
            duration: AppTheme.animationMedium,
            vsync: this,
          ),
    );

    _scaleAnimations = _animationControllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 1.1).animate(
        CurvedAnimation(parent: controller, curve: AppTheme.animationCurve),
      );
    }).toList();

    _bounceAnimations = _animationControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: AppTheme.bounceCurve),
      );
    }).toList();

    // Animar o item atual na inicialização
    if (widget.currentIndex < _animationControllers.length) {
      _animationControllers[widget.currentIndex].forward();
    }
  }

  @override
  void didUpdateWidget(BenicioBottomNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      // Reset animação anterior
      if (oldWidget.currentIndex < _animationControllers.length) {
        _animationControllers[oldWidget.currentIndex].reverse();
      }
      // Animar novo item
      if (widget.currentIndex < _animationControllers.length) {
        _animationControllers[widget.currentIndex].forward();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.cardBackground.withOpacity(0.95),
            AppTheme.cardBackground,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.textSecondary.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: AppTheme.borderLight,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 76,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildEnhancedNavItem(
                index: 0,
                icon: Icons.dashboard_rounded,
                label: 'Dashboard',
                isActive: widget.currentIndex == 0,
              ),
              _buildEnhancedNavItem(
                index: 1,
                icon: Icons.search_rounded,
                label: 'Buscar',
                isActive: widget.currentIndex == 1,
              ),
              _buildEnhancedNavItem(
                index: 2,
                icon: Icons.analytics_rounded,
                label: 'Relatórios',
                isActive: widget.currentIndex == 2,
              ),
              _buildEnhancedNavItem(
                index: 3,
                icon: Icons.history_rounded,
                label: 'Histórico',
                isActive: widget.currentIndex == 3,
              ),
              _buildEnhancedNavItem(
                index: 4,
                icon: Icons.person_rounded,
                label: 'Perfil',
                isActive: widget.currentIndex == 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          widget.onTap(index);
          // Feedback háptico
          if (isActive) return;

          // Trigger animation
          _animationControllers[index].forward().then((_) {
            _animationControllers[index].reverse();
          });
        },
        onTapDown: (_) {
          if (!isActive && index < _animationControllers.length) {
            _animationControllers[index].forward();
          }
        },
        onTapUp: (_) {
          if (!isActive && index < _animationControllers.length) {
            _animationControllers[index].reverse();
          }
        },
        onTapCancel: () {
          if (!isActive && index < _animationControllers.length) {
            _animationControllers[index].reverse();
          }
        },
        child: AnimatedBuilder(
          animation: index < _animationControllers.length
              ? _animationControllers[index]
              : const AlwaysStoppedAnimation(0.0),
          builder: (context, child) {
            final scale = index < _scaleAnimations.length
                ? _scaleAnimations[index].value
                : 1.0;

            return Transform.scale(
              scale: scale,
              child: AnimatedContainer(
                duration: AppTheme.animationMedium,
                curve: AppTheme.animationCurve,
                padding: EdgeInsets.symmetric(
                  horizontal: isActive ? 16 : 8,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: isActive
                      ? LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.15),
                      AppTheme.primaryColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : null,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: isActive
                      ? Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    width: 1,
                  )
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow effect quando ativo
                        if (isActive)
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  AppTheme.primaryColor.withOpacity(0.3),
                                  AppTheme.primaryColor.withOpacity(0.1),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        Icon(
                          icon,
                          size: isActive ? 26 : 22,
                          color: isActive
                              ? AppTheme.primaryColor
                              : AppTheme.textSecondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    AnimatedDefaultTextStyle(
                      duration: AppTheme.animationMedium,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: isActive ? 11 : 10,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight
                            .w500,
                        color: isActive
                            ? AppTheme.primaryColor
                            : AppTheme.textSecondary,
                      ),
                      child: Text(label),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  label

      :

  '

  Relatórios

  '

  ,

  isActive

      :

  currentIndex

  ==

  2

  ,

  )

  ,

  _buildNavItem

  (

  context: context,
  index: 3,
  icon: Icons.history,
  label: 'Histórico',
  isActive: currentIndex == 3,
  ),
  _buildNavItem(
  context: context,
  index: 4,
  icon: Icons.person,
  label: 'Perfil',
  isActive: currentIndex == 4,
  ),
  ],
  ),

  )

  ,

  )

  ,

  );
}

Widget _buildNavItem({
  required BuildContext context,
  required int index,
  required IconData icon,
  required String label,
  required bool isActive,
}) {
  return GestureDetector(
    onTap: () => onTap(index),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF582FFF).withOpacity(0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color:
            isActive ? const Color(0xFF582FFF) : const Color(0xFF484C52),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isActive
                  ? const Color(0xFF582FFF)
                  : const Color(0xFF484C52),
            ),
          ),
        ],
      ),
    ),
  );
}}
