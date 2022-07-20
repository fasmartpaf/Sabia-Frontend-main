import 'package:flutter/material.dart';
import '../components/icon/app_icon.dart';
import 'package:oktoast/oktoast.dart';

import "../extensions/string_extension.dart";
import "../extensions/container_extension.dart";

enum NOTIFICATION_TYPE { primary, info, success, danger, warning }

class NotificationsService {
  Color _getColorForType(NOTIFICATION_TYPE type) {
    switch (type) {
      case NOTIFICATION_TYPE.info:
        return Colors.lightBlue;
      case NOTIFICATION_TYPE.success:
        return Colors.green;
      case NOTIFICATION_TYPE.warning:
        return Colors.orange;
      case NOTIFICATION_TYPE.danger:
        return Colors.red;

      case NOTIFICATION_TYPE.primary:
      default:
        return Colors.blue;
    }
  }

  Widget _roundedContainer({
    Color color,
    Widget child,
    double padding = 4,
  }) =>
      Container(
        color: color,
        padding: EdgeInsets.all(padding),
        child: child,
      ).rounded();

  _notify(
    String message, {
    String title,
    IconData icon = NotificationIcon,
    NOTIFICATION_TYPE type = NOTIFICATION_TYPE.primary,
    int timeout = 3,
    Function onTap,
  }) {
    final textColor = Colors.white;
    final backgroundColor = _getColorForType(type);
    final bool hasTitle = title?.isNotEmpty ?? false;

    showToastWidget(
      Material(
        color: Colors.transparent,
        child: Container(
          width: double.maxFinite,
          color: Colors.transparent,
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          child: InkWell(
            onTap: () {
              dismissAllToast(showAnim: true);
              if (onTap != null) onTap();
            },
            child: Stack(children: [
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.all(8),
                child: _roundedContainer(
                  color: backgroundColor,
                  padding: 8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (hasTitle)
                        Text(
                          title.maxLength(26),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                          ),
                        ),
                      Text(
                        message.maxLength(120),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: textColor,
                          fontSize: hasTitle ? 14 : 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (icon != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: _roundedContainer(
                    color: backgroundColor,
                    padding: 1,
                    child: _roundedContainer(
                      color: Colors.white,
                      child: Icon(
                        icon,
                        color: backgroundColor,
                        size: 18,
                      ),
                    ),
                  ),
                ),
            ]),
          ),
        ),
      ),
      handleTouch: true,
      duration: Duration(seconds: timeout ?? 3),
    );
  }

  notify(
    String message, {
    String title,
    IconData icon,
    int timeout,
    Function onTap,
  }) {
    this._notify(
      message,
      title: title,
      icon: icon,
      type: NOTIFICATION_TYPE.primary,
      timeout: timeout,
      onTap: onTap,
    );
  }

  notifyInfo(
    String message, {
    String title,
    IconData icon,
    int timeout,
    Function onTap,
  }) {
    this._notify(
      message,
      title: title,
      icon: icon,
      type: NOTIFICATION_TYPE.info,
      timeout: timeout,
      onTap: onTap,
    );
  }

  notifySuccess(
    String message, {
    String title,
    IconData icon,
    int timeout,
    Function onTap,
  }) {
    this._notify(
      message,
      title: title,
      icon: icon,
      type: NOTIFICATION_TYPE.success,
      timeout: timeout,
      onTap: onTap,
    );
  }

  notifyWarning(
    String message, {
    String title,
    int timeout,
    Function onTap,
  }) {
    this._notify(
      message,
      title: title,
      icon: ExclamationTriangleIcon,
      type: NOTIFICATION_TYPE.warning,
      timeout: timeout,
      onTap: onTap,
    );
  }

  notifyDanger(
    String message, {
    String title,
    int timeout,
    Function onTap,
  }) {
    this._notify(
      message,
      title: title,
      icon: ExclamationTriangleIcon,
      type: NOTIFICATION_TYPE.danger,
      timeout: timeout,
      onTap: onTap,
    );
  }

  notifyError(
    String message, {
    String title,
    int timeout,
    Function onTap,
  }) {
    this.notifyDanger(
      message,
      title: title,
      timeout: timeout,
      onTap: onTap,
    );
  }
}
