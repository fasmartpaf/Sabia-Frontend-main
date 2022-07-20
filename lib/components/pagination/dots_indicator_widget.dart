import 'dart:math';

import 'package:flutter/material.dart';

/// An indicator showing the currently selected page of a PageController
class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.selectedColor = Colors.black,
    this.inactiveColor = Colors.grey,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.black`.
  final Color selectedColor;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.grey`.
  final Color inactiveColor;

  // The base size of the dots
  static const double _kDotSize = 9.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 1.6;

  // The distance between the center of each dot
  static const double _kDotSpacing = 26.0;

  int get _currentPageIndex {
    if (!this.controller.hasClients) return 0;

    return this.controller.page?.round() ?? 0;
  }

  Widget _buildDot(int index) {
    double selectedNess = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedNess;
    return Container(
      width: _kDotSpacing,
      child: Center(
        child: Material(
          color: _currentPageIndex == index ? selectedColor : inactiveColor,
          type: MaterialType.circle,
          child: Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
