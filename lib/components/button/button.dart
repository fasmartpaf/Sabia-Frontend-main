import 'package:flutter/material.dart';

import 'package:sabia_app/utils/styles.dart';

enum ButtonType {
  primary,
  success,
  info,
  warning,
  danger,
}

class Button extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget iconWidget;
  final bool isDisabled;
  final bool isLoading;
  final bool outlined;
  final bool uppercased;
  final bool fullWidth;
  final bool flat;
  final bool small;
  final bool square;
  final double fontSize;
  final Color labelColor;
  final EdgeInsets padding;
  final ButtonType type;
  final Function onPressed;

  const Button({
    Key key,
    this.onPressed,
    this.isDisabled = false,
    this.isLoading = false,
    this.outlined = false,
    this.uppercased = true,
    this.fullWidth = false,
    this.flat = false,
    this.small = false,
    this.square = false,
    this.type = ButtonType.primary,
    this.padding,
    this.labelColor,
    this.fontSize,
    this.label,
    this.icon,
    this.iconWidget,
  }) : super(key: key);

  ThemeData _defaultThemeWithColor(BuildContext context, Color color) =>
      ThemeData(
        buttonColor: color,
        buttonTheme: ButtonThemeData(
          buttonColor: color,
          textTheme: ButtonTextTheme.primary,
          colorScheme: Theme.of(context).colorScheme.copyWith(
                secondary: Colors.white,
              ),
        ),
      );

  ThemeData _themeForType(BuildContext context) {
    switch (type) {
      case ButtonType.success:
        return _defaultThemeWithColor(context, Colors.green);
      case ButtonType.warning:
        return _defaultThemeWithColor(context, Colors.orange);
      case ButtonType.danger:
        return _defaultThemeWithColor(context, Colors.red);
      case ButtonType.primary:
      default:
        return Theme.of(context);
    }
  }

  get roundedShape => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      );
  get squareShape => RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      );

  @override
  Widget build(BuildContext context) {
    final theme = _themeForType(context);
    final buttonColor = theme.buttonColor;
    final double buttonFontSize = fontSize != null ? fontSize : small ? 12 : 14;

    final Text labelText = Text(
      uppercased ? label.toUpperCase() : label,
      style: TextStyle(
        color: labelColor,
        fontSize: buttonFontSize,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
      maxLines: 3,
    );
    final Widget child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
              strokeWidth: 2,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              labelText,
              if (this.iconWidget != null || this.icon != null)
                SizedBox(width: 4),
              if (this.iconWidget != null)
                this.iconWidget
              else if (this.icon != null)
                Icon(
                  this.icon,
                  color: labelColor,
                  size: buttonFontSize + 1,
                ),
            ],
          );

    Widget buttonWidget;

    if (flat) {
      buttonWidget = FlatButton(
        child: child,
        textColor: buttonColor,
        padding: this.padding,
        onPressed: this.isDisabled ? null : this.onPressed,
      );
    } else if (outlined) {
      buttonWidget = FlatButton(
        child: child,
        color: buttonColor,
        shape: this.square ? squareShape : roundedShape,
        textColor: buttonColor,
        padding: this.padding,

        onPressed: this.isDisabled ? null : this.onPressed,
      );
    } else {
      buttonWidget = RaisedButton(
        child: child,
        color: buttonColor,
        padding: this.padding,
        shape: this.square ? squareShape : roundedShape,
        onPressed: this.isDisabled ? null : this.onPressed,
      );
    }

    if (this.fullWidth) {
      return SizedBox(
        width: double.infinity,
        child: buttonWidget,
      );
    }
    return buttonWidget;
  }
}

class SuccessButton extends Button {
  const SuccessButton({
    Function onPressed,
    bool isDisabled = false,
    bool outlined = false,
    String label,
    IconData icon,
  }) : super(
          icon: icon,
          type: ButtonType.success,
          onPressed: onPressed,
          isDisabled: isDisabled,
          outlined: outlined,
          label: label,
        );
}

class PrimaryButton extends Button {
  const PrimaryButton({
    Function onPressed,
    bool isDisabled = false,
    bool outlined = false,
    String label,
    IconData icon,
  }) : super(
          icon: icon,
          onPressed: onPressed,
          isDisabled: isDisabled,
          outlined: outlined,
          label: label,
        );
}

class WarningButton extends Button {
  const WarningButton({
    Function onPressed,
    bool isDisabled = false,
    bool outlined = false,
    String label,
    IconData icon,
  }) : super(
          type: ButtonType.warning,
          icon: icon,
          onPressed: onPressed,
          isDisabled: isDisabled,
          outlined: outlined,
          label: label,
        );
}

class DangerButton extends Button {
  const DangerButton({
    Function onPressed,
    bool isDisabled = false,
    bool outlined = false,
    bool flat = false,
    bool small = false,
    String label,
    IconData icon,
  }) : super(
          type: ButtonType.danger,
          icon: icon,
          onPressed: onPressed,
          isDisabled: isDisabled,
          flat: flat,
          small: small,
          labelColor: flat ? Colors.red : Colors.white,
          outlined: outlined,
          label: label,
          fullWidth: false,
        );
}

class OutlinedButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final bool small;
  final bool uppercased;
  const OutlinedButton({
    Key key,
    this.label,
    this.small = false,
    this.uppercased = true,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double buttonFontSize = small ? 12 : 14;

    return FlatButton(
      padding: small ? EdgeInsets.zero : null,
      child: Text(
        uppercased ? label.toUpperCase() : label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: buttonFontSize,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      textColor: kOrangeColor,
      // borderSide: BorderSide(
      //   color: kOrangeColor,
      //   width: 2,
      // ),
      onPressed: onPressed,
    );
  }
}
