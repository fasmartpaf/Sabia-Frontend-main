import 'package:flutter/material.dart';
import 'package:sabia_app/utils/styles.dart';

import 'dots_indicator_widget.dart';

class PageViewWidget extends StatefulWidget {
  final List<Widget> items;
  final double viewportFraction;
  final int initialIndex;
  PageViewWidget({
    @required this.items,
    this.viewportFraction = 1.0,
    this.initialIndex = 0,
    Key key,
  }) : super(key: key);

  @override
  _PageViewWidgetState createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();

    this._pageController = PageController(
      initialPage: this.widget.initialIndex,
      viewportFraction: this.widget.viewportFraction,
    );

    this._pageController.addListener(_pageIndexListener);
  }

  @override
  dispose() {
    this._pageController.removeListener(_pageIndexListener);
    super.dispose();
  }

  int get _itemsCount {
    return this.widget.items.length;
  }

  void _pageIndexListener() {
    //
  }

  void onChangeCurrentPage(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxWidth: MediaQuery.of(context).size.width,
      maxHeight: 120,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: PageView.builder(
              itemBuilder: (context, index) {
                final item = this.widget.items[index];
                return ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: item,
                );
              },
              itemCount: _itemsCount,
              controller: this._pageController,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: DotsIndicator(
                controller: _pageController,
                itemCount: _itemsCount,
                onPageSelected: onChangeCurrentPage,
                selectedColor: kGrayActiveColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
