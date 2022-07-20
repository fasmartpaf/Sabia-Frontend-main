import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:sabia_app/utils/date_utils.dart';

import 'model_utils.dart';

enum NotificationModelType {
  plain,
  boolean,
  link,
  message,
}

extension NotificationModelTypeExtension on NotificationModelType {
  String get value => this.toString().split(".").last;
}

NotificationModelType notificationTypeFromString(String type) =>
    NotificationModelType.values.firstWhere(
      (e) => e.value == type,
      orElse: () => NotificationModelType.plain,
    );

class NotificationModel {
  String id;
  String title;
  String subtitle;
  String value;
  bool isRead;
  bool isEnabled;
  int createdAt;
  int updatedAt;
  NotificationModelType type;

  NotificationModel({
    this.id,
    this.title,
    this.subtitle,
    this.value,
    this.isRead,
    this.isEnabled,
    this.createdAt,
    this.updatedAt,
    this.type,
  });

  bool get isPlain {
    return this.type == NotificationModelType.plain;
  }

  bool get isBoolean {
    return this.type == NotificationModelType.boolean;
  }

  bool get isLink {
    return this.type == NotificationModelType.link;
  }

  bool get isMessage {
    return this.type == NotificationModelType.message;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'value': value,
      'isRead': isRead,
      'isEnabled': isEnabled,
      'createdAt': createdAt,
      'type': type.value,
    };
  }

  static NotificationModel fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    return NotificationModel(
      id: map['id'],
      type: notificationTypeFromString(map["type"]),
      title: map['title'],
      subtitle: map['subtitle'] ?? "",
      value: map['value'],
      isRead: map['isRead'] ?? false,
      isEnabled: map['isEnabled'] ?? false,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'] ?? map['createdAt'],
    );
  }

  static NotificationModel fromSnapshot(DataSnapshot snapshot) {
    if (snapshot == null) return null;
    return NotificationModel.fromMap(mapFromSnapshot(snapshot));
  }

  String toJson() => json.encode(toMap());

  static NotificationModel fromJson(String source) =>
      fromMap(json.decode(source));

  bool get isUnread => !this.isRead;

  String get createdDate => this.createdAt == null
      ? ""
      : formattedDayAndHourFromFirebaseTimestamp(this.createdAt);
  String get updatedDate => this.updatedAt == null
      ? this.createdDate
      : formattedDayAndHourFromFirebaseTimestamp(this.updatedAt);
}

final tempNotification1 = NotificationModel(
  id: "notif1",
  title: "Ei Darlan. Já recebeu o livro?",
  subtitle: "Design pra quem não é designer",
  value: "loan_book1",
  isRead: false,
  type: NotificationModelType.boolean,
);
final tempNotification2 = NotificationModel(
  id: "notif2",
  title: "Megan Estrada quer um livro!",
  subtitle: "Design pra quem não é designer",
  value: "book1",
  isRead: false,
  type: NotificationModelType.link,
);
final tempNotification3 = NotificationModel(
  id: "notif3",
  title: "Ei Darlan. Já devolveu o livro?",
  subtitle: "Design pra quem não é designer",
  value: "return_book1",
  isRead: false,
  type: NotificationModelType.boolean,
);
final tempNotification4 = NotificationModel(
  id: "notif4",
  title: "Megan Estrada não confirmou a troca",
  subtitle:
      "Poxa, acho que a Megan desistiu de emprestar o livro e vai lê-lo novamente.",
  isRead: false,
  type: NotificationModelType.plain,
);
final tempNotification5 = NotificationModel(
  id: "notif5",
  title: "Tá chegando a hora de devolver o livro!",
  subtitle: "E ai Darlan? Já terminou de ler o livro? *Faltam 5 dias!*",
  isRead: false,
  type: NotificationModelType.plain,
);
final tempNotification6 = NotificationModel(
  id: "notif6",
  title: "Miroslav Silva quer um livro!",
  subtitle: "Geração de valor 1",
  value: "book6",
  isRead: false,
  type: NotificationModelType.link,
);
final tempNotification7 = NotificationModel(
  id: "notif7",
  title: "Miroslav Silva confirmou a troca",
  subtitle: "Agora é só marcar o local de troca e aproveitar a leitura.",
  value: "userId1",
  isRead: false,
  type: NotificationModelType.message,
);
