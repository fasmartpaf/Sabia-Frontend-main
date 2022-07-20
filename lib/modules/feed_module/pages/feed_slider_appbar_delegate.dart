import 'package:flutter/material.dart';
import 'dart:math' as math;

class FeedSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;

  final Widget Function(BuildContext, double) builder;

  FeedSliverPersistentHeaderDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    this.builder,
  });
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) =>
      this.builder(context, shrinkOffset);

  @override
  bool shouldRebuild(FeedSliverPersistentHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        builder != oldDelegate.builder;
  }
}
