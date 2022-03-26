import 'package:flutter/material.dart';

class CustomAnimatedBottomBar extends StatelessWidget {
  const CustomAnimatedBottomBar({
    Key? key,
    this.selectedIndex = 0,
    this.iconSize = 24,
    this.backgroundColor,
    this.showElevation = true,
    this.animationDuration = const Duration(milliseconds: 270),
    required this.items,
    required this.onItemSelected,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.itemCornerRadius = 50,
    this.containerCornerRadius = 0,
    this.containerHeight = 56,
    this.curve = Curves.linear,
  })  : assert(items.length >= 2 && items.length <= 5),
        super(key: key);

  final int selectedIndex;
  final double iconSize;
  final Color? backgroundColor;
  final bool showElevation;
  final Duration animationDuration;
  final List<BottomNavyBarItem> items;
  final ValueChanged<int> onItemSelected;
  final MainAxisAlignment mainAxisAlignment;
  final double itemCornerRadius;
  final double containerCornerRadius;
  final double containerHeight;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Theme.of(context).bottomAppBarColor;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(containerCornerRadius),
        boxShadow: [
          if (showElevation)
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
            )
        ],
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: containerHeight,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            children: items.map((item) {
              var index = items.indexOf(item);
              return GestureDetector(
                onTap: () => onItemSelected(index),
                child: _ItemWidget(
                  item: item,
                  iconSize: iconSize,
                  isSelected: index == selectedIndex,
                  backgroundColor: bgColor,
                  itemCornerRadius: itemCornerRadius,
                  animationDuration: animationDuration,
                  curve: curve,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final double iconSize;
  final bool isSelected;
  final BottomNavyBarItem item;
  final Color backgroundColor;
  final double itemCornerRadius;
  final Duration animationDuration;
  final Curve curve;

  const _ItemWidget({
    Key? key,
    required this.iconSize,
    required this.isSelected,
    required this.item,
    required this.backgroundColor,
    required this.itemCornerRadius,
    required this.animationDuration,
    required this.curve,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      selected: isSelected,
      child: AnimatedContainer(
        width: isSelected ? 130 : 50,
        height: double.maxFinite,
        duration: animationDuration,
        curve: curve,
        decoration: BoxDecoration(
          color:
              isSelected ? item.activeColor.withOpacity(0.2) : backgroundColor,
          borderRadius: BorderRadius.circular(itemCornerRadius),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
            width: isSelected ? 130 : 50,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconTheme(
                  data: IconThemeData(
                    size: iconSize,
                    color: isSelected
                        ? item.activeColor.withOpacity(1)
                        : item.inactiveColor ?? item.activeColor,
                  ),
                  child: item.icon,
                ),
                if (isSelected)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: DefaultTextStyle.merge(
                        child: item.title,
                        style: TextStyle(
                          color: item.activeColor,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        textAlign: item.textAlign,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavyBarItem {
  final Widget icon;
  final Widget title;
  final Color activeColor;
  final Color? inactiveColor;
  final TextAlign? textAlign;

  BottomNavyBarItem({
    required this.icon,
    required this.title,
    this.activeColor = Colors.blue,
    this.inactiveColor,
    this.textAlign,
  });
}
