import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:track_my_wallet_finance_app/constants.dart';

class CustomBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onAddTap;

  const CustomBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 80, right: 80, bottom: 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 68, // Reduced height
            decoration: BoxDecoration(
               color: kWhiteColor.withValues(alpha: 0.6),
               borderRadius: BorderRadius.circular(50),
               border: Border.all(color: Colors.white, width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(0, FluentIcons.home_24_filled, FluentIcons.home_24_regular),
                _buildAddButton(),
                _buildNavItem(1, FluentIcons.learning_app_24_filled, FluentIcons.book_24_regular),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData selectedIcon, IconData unselectedIcon) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Icon(
        isSelected ? selectedIcon : unselectedIcon,
        color: isSelected ? kBlackColor : kBlackColor.withValues(alpha: 0.5),
        size: 24, // Adjusted size for Fluent Icons
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: onAddTap,
      child: Container(
        height: 54, // Reduced size
        width: 54,
        decoration: BoxDecoration(
          color: kOrangeColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3), // White border
          boxShadow: [
            BoxShadow(
              color: kOrangeColor.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            FluentIcons.add_24_filled,
            color: Colors.white,
            size: 24, // Adjusted size
          ),
        ),
      ),
    );
  }
}
