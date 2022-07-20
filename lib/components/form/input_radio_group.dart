import 'package:flutter/material.dart';
import '../icon/app_icon.dart';

class InputRadio extends StatelessWidget {
  final String label;
  final dynamic value;
  final dynamic groupValue;
  final Function(dynamic) onChanged;

  const InputRadio({
    Key key,
    this.value,
    this.groupValue,
    this.onChanged,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Radio(
          value: this.value,
          groupValue: this.groupValue,
          onChanged: (_) => onChanged(value),
        ),
        InkWell(
          onTap: () => onChanged(value),
          child: Text(
            this.label,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }
}

class InputRadioOption {
  final String label;
  final dynamic value;

  InputRadioOption({this.label, this.value});
}

class InputRadioGroup extends StatelessWidget {
  final String label;
  final dynamic value;
  final List<InputRadioOption> options;
  final Function(dynamic) onChanged;

  const InputRadioGroup(
      {Key key, this.label, this.options, this.value, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(ArrowRightIcon),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            this.label,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
            ),
          ),
          ...?this.options.map(
                (option) => InputRadio(
                  label: option.label,
                  value: option.value,
                  groupValue: this.value,
                  onChanged: this.onChanged,
                ),
              )
        ],
      ),
    );
  }
}
