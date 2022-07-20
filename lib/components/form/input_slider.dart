import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

import 'package:sabia_app/utils/styles.dart';

class InputSlider extends StatelessWidget {
  final String maxLabel;
  final double max;
  final String minLabel;
  final double min;
  final double value;
  final IconData icon;
  final Function(double) format;
  final void Function(double) onChanged;

  const InputSlider({
    Key key,
    this.maxLabel,
    this.max = 100,
    this.minLabel,
    this.min = 0,
    this.value,
    this.icon,
    this.format,
    this.onChanged,
  }) : super(key: key);

  Widget _renderLabel(String label) => Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w300,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final input = FlutterSlider(
      min: min,
      max: max,
      values: [value],
      fixedValues: [],
      handler: FlutterSliderHandler(
          child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border.all(
              width: 4,
              color: kSuccessColor,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      )),
      handlerHeight: 20,
      handlerWidth: 20,
      trackBar: FlutterSliderTrackBar(
        activeTrackBarHeight: 4,
        inactiveTrackBarHeight: 4,
        activeTrackBar: BoxDecoration(
          color: kSuccessColor,
          borderRadius: BorderRadius.circular(20),
        ),
        inactiveTrackBar: BoxDecoration(
          color: kGrayInactiveColor,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      tooltip: FlutterSliderTooltip(
        custom: (value) => Container(
          decoration: BoxDecoration(
            color: kSuccessColor,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          child: Text(
            format != null ? format(value) : "$value",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        alwaysShowTooltip: true,
      ),
      onDragging: (handlerIndex, lowerValue, upperValue) {
        onChanged(lowerValue);
      },
    );
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Stack(children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: input,
        ),
        if (minLabel != null)
          Positioned(
            bottom: 10,
            left: 22,
            child: _renderLabel(minLabel),
          ),
        if (maxLabel != null)
          Positioned(
            bottom: 10,
            right: 22,
            child: _renderLabel(maxLabel),
          ),
      ]),
    );
  }
}
