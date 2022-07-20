import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:build_context/build_context.dart';
import 'package:sabia_app/components/button/button.dart';
import 'package:sabia_app/components/general/empty_state_message.dart';
import 'package:sabia_app/components/general/unread_marker.dart';
import 'package:sabia_app/components/utility/visibility_detector_widget.dart';
import 'package:sabia_app/model/notification_model.dart';
import 'package:sabia_app/stores/notifications_store.dart';
import 'package:sabia_app/utils/styles.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key key}) : super(key: key);

  Widget _renderNotificationAction(
    NotificationModel notification,
    NotificationsStore _notificationsStore,
  ) {
    if (notification.isBoolean) {
      return Column(
        children: <Widget>[
          Button(
            label: "Sim",
            uppercased: false,
            small: true,
            fullWidth: false,
            onPressed: () => _notificationsStore.didSelect(notification),
          ),
          Button(
            label: "Não",
            uppercased: false,
            small: true,
            outlined: true,
            onPressed: () => _notificationsStore.didSelect(
              notification,
              isSecondaryAction: true,
            ),
          ),
        ],
      );
    }

    if (notification.isLink) {
      return Button(
        label: "Detalhes",
        uppercased: false,
        small: true,
        fullWidth: false,
        onPressed: () => _notificationsStore.didSelect(notification),
      );
    }

    return SizedBox();
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationModel notification,
    NotificationsStore _notificationsStore,
  ) {
    final textTheme = context.textTheme;
    return InkWell(
      onTap: () => _notificationsStore.didSelectAlreadyRead(notification),
      child: Card(
        margin: EdgeInsets.symmetric(
          vertical: 10,
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      if (notification.isUnread) UnreadMarker(),
                      if (notification.isUnread) SizedBox(width: 4),
                      Expanded(
                        child: AutoSizeText(
                          notification.title,
                          style: textTheme.subtitle1,
                          maxFontSize: textTheme.subtitle1.fontSize,
                          maxLines: 5,
                        ),
                      ),
                    ],
                  ),
                  if (notification.subtitle.isNotEmpty) SizedBox(height: 8),
                  if (notification.subtitle.isNotEmpty)
                    Text(
                      notification.subtitle,
                      maxLines: 4,
                      style: textTheme.subtitle2,
                    ),
                  SizedBox(height: 8),
                  Text(
                    notification.updatedDate,
                    style: textTheme.overline,
                  ),
                ],
              ),
            ),
            if (notification.isUnread) SizedBox(width: 6),
            if (notification.isUnread)
              _renderNotificationAction(notification, _notificationsStore),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _notificationsStore = Modular.get<NotificationsStore>();

    return Scaffold(
      backgroundColor: kGrayBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Notificações",
          maxLines: 2,
          style: context.textTheme.headline6.copyWith(
            fontSize: 22,
          ),
        ),
      ),
      body: Observer(
        builder: (_) {
          if (_notificationsStore.notificationsList.isEmpty) {
            return Center(
              child: EmptyStateMessage(),
            );
          }

          return ListView.builder(
            itemCount: _notificationsStore.notificationsList.length,
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            itemBuilder: (BuildContext context, int index) {
              final notification = _notificationsStore.notificationsList[index];

              final card = _buildNotificationCard(
                context,
                notification,
                _notificationsStore,
              );

              if (notification.isRead) {
                return card;
              }

              final inkWell = InkWell(
                onTap: notification.isBoolean
                    ? null
                    : () {
                        if (notification.isPlain) {
                          _notificationsStore.didRead(notification);
                        } else {
                          _notificationsStore.didSelect(notification);
                        }
                      },
                child: card,
              );

              if (notification.isPlain && !notification.isRead) {
                return VisibilityDetectorWidget(
                  key: Key("notification_$index"),
                  onChanged: (bool isVisible) {
                    if (isVisible) {
                      _notificationsStore.didRead(notification);
                    }
                  },
                  child: inkWell,
                );
              }

              return inkWell;
            },
          );
        },
      ),
    );
  }
}
