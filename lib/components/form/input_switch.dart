import 'package:flutter/material.dart';
import '../icon/app_icon.dart';

class InputSwitch extends StatelessWidget {
  final String label;
  final bool isChecked;
  final ValueChanged<bool> onChanged;

  const InputSwitch({
    Key key,
    this.isChecked,
    this.onChanged,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        isChecked ? CheckIcon : CloseIcon,
        color: isChecked ? Colors.green : Colors.red,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isChecked ? FontWeight.bold : FontWeight.w300,
        ),
      ),
      trailing: Switch(value: isChecked, onChanged: onChanged),
      onTap: () => onChanged(!isChecked),
    );
  }
}
