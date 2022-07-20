import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sabia_app/components/form/ensure_visible_when_focused.dart';

class InputText extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final IconData icon;
  final String label;
  final String errorText;
  final String helperText;
  final String hintText;
  final String value;
  final bool multiline;
  final bool withListTile;
  final bool isDisabled;
  final bool autofocus;
  final bool autoCorrect;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final int maxLength;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final Widget prefixIconWidget;
  final Widget suffixIconWidget;
  final List<TextInputFormatter> inputFormatters;
  final String Function(String) validator;
  final void Function() onTap;
  final void Function(String) onChanged;
  final void Function(String) onSaved;
  final VoidCallback onEditingComplete;

  const InputText({
    Key key,
    this.controller,
    this.focusNode,
    this.value,
    this.validator,
    this.onTap,
    this.onChanged,
    this.onSaved,
    this.onEditingComplete,
    this.prefixIcon,
    this.prefixIconWidget,
    this.suffixIcon,
    this.suffixIconWidget,
    this.inputFormatters,
    this.icon,
    this.label,
    this.errorText,
    this.helperText,
    this.hintText,
    this.multiline = false,
    this.withListTile = true,
    this.isDisabled = false,
    this.autofocus = false,
    this.autoCorrect = true,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.sentences,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textField = TextFormField(
      autofocus: autofocus,
      readOnly: isDisabled,
      textCapitalization: textInputType == TextInputType.emailAddress
          ? TextCapitalization.none
          : textCapitalization ?? TextCapitalization.sentences,
      keyboardType: textInputType,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      autocorrect: autoCorrect,
      controller: this.controller,
      focusNode: this.focusNode,
      maxLength: this.maxLength,
      maxLines: this.multiline ? null : 1,
      style: TextStyle(fontSize: 18),
      onTap: onTap,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        helperText: helperText,
        prefixIcon: prefixIconWidget != null
            ? prefixIconWidget
            : prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIconWidget != null
            ? suffixIconWidget
            : suffixIcon != null ? Icon(suffixIcon) : null,
        hintText: hintText,
        labelText: label,
        errorText: errorText,
      ),
      validator: this.validator,
      initialValue: this.value,
      onChanged: this.onChanged,
      onSaved: this.onSaved,
      onEditingComplete: onEditingComplete,
    );

    final widget = this.focusNode != null
        ? EnsureVisibleWhenFocused(
            child: textField,
            focusNode: this.focusNode,
          )
        : textField;

    if (withListTile) {
      return ListTile(
        leading: icon != null ? Icon(icon) : null,
        title: widget,
      );
    }

    return widget;
  }
}
