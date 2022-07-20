import 'package:firebase_database/firebase_database.dart';

import '../../utils/date_utils.dart';
import '../../utils/date_time_util.dart';
import './book_model.dart';
import '../model_utils.dart';
import '../user_model.dart';

enum BookLoanStatus {
  requested, // to requisitou o empréstimo
  toDelivery, // from aceitou emprestar e precisa entregar
  lend, // está emprestado
  canceled, // alguma das partes cancelou o empréstimo
  toReturn, // prazo de empréstimo expirou e precisa ser retornado
  returned, // livro foi devolvido
}

extension BookLoanStatusExtension on BookLoanStatus {
  String get value => this.toString().split(".").last;

  String get labelFrom {
    switch (this) {
      case BookLoanStatus.requested:
        return "Pediram emprestado";
      case BookLoanStatus.toDelivery:
        return "Entregar para o leitor.";
      case BookLoanStatus.lend:
        return "Está com o leitor.";
      case BookLoanStatus.canceled:
        return "Recusei o empréstimo";
      case BookLoanStatus.toReturn:
        return "Prazo de empréstimo expirou, combine com o leitor para pegar seu livro!";
      default:
        return "Estou com ele.";
    }
  }

  String get labelTo {
    switch (this) {
      case BookLoanStatus.requested:
        return "Pedi emprestado, aguardando...";
      case BookLoanStatus.toDelivery:
        return "Já posso pegar com o dono!";
      case BookLoanStatus.lend:
        return "Estou com ele.";
      case BookLoanStatus.canceled:
        return "Empréstimo recusado :(";
      case BookLoanStatus.toReturn:
        return "Hora de devolver!";
      default:
        return "Já devolvi ele";
    }
  }
}

BookLoanStatus bookStatusFromString(String status) =>
    BookLoanStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => BookLoanStatus.canceled,
    );

class BookLoanModel {
  String id;
  BookModel book;
  UserModel fromUser;
  UserModel toUser;
  int lendAt;
  int daysToLoan;
  int startedAt;
  BookLoanStatus status;
  bool toDeliveryOwnerAnswer;
  bool toDeliveryReaderAnswer;
  bool toReturnOwnerAnswer;
  bool toReturnReaderAnswer;

  BookLoanModel({
    this.id,
    this.book,
    this.fromUser,
    this.toUser,
    this.lendAt,
    this.daysToLoan,
    this.startedAt,
    this.status,
    this.toDeliveryOwnerAnswer,
    this.toDeliveryReaderAnswer,
    this.toReturnOwnerAnswer,
    this.toReturnReaderAnswer,
  });

  static BookLoanModel fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    return BookLoanModel(
      id: map['id'],
      book: BookModel.fromMap(map['book']),
      fromUser: UserModel.fromMap(map['from']),
      toUser: UserModel.fromMap(map['to']),
      lendAt: map['lendAt'],
      daysToLoan: map['daysToLoan'],
      startedAt: map['startedAt'],
      status: bookStatusFromString(map['status']),
      toDeliveryOwnerAnswer: map['toDeliveryOwnerAnswer'] ?? false,
      toDeliveryReaderAnswer: map['toDeliveryReaderAnswer'] ?? false,
      toReturnOwnerAnswer: map['toReturnOwnerAnswer'] ?? false,
      toReturnReaderAnswer: map['toReturnReaderAnswer'] ?? false,
    );
  }

  static BookLoanModel fromSnapshot(DataSnapshot snapshot) {
    if (snapshot == null) return null;
    return BookLoanModel.fromMap(mapFromSnapshot(snapshot));
  }

  String get expireDate {
    if (this.lendAt == null) {
      return "";
    }
    DateTime date = dateTimeFromFirebaseTimestamp(this.lendAt);
    return date.addDays(this.daysToLoan).display();
  }
}
