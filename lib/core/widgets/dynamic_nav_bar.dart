import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class DynamicNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const DynamicNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardSurface(context),
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(0, 0, 0, 0),
            blurRadius: 24,
            spreadRadius: 0,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Color.fromARGB(108, 0, 0, 0),
            blurRadius: 1,
            spreadRadius: 0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavBarItem(
            icon: Icons.radio_button_unchecked,
            label: 'FOCUS',
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
            activeColor: activeColor,
          ),
          _NavBarItem(
            icon: Icons.view_day,
            label: 'COURSES',
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
            activeColor: activeColor,
          ),
          _NavBarItem(
            icon: Icons.person,
            label: 'SETTINGS',
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
            activeColor: activeColor,
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? activeColor : AppColors.navInactive,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTextStyles.navLabel(
                color: isSelected ? activeColor : AppColors.navInactive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
