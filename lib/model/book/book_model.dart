import 'package:mobx/mobx.dart';

import '../image_model.dart';
import '../user_model.dart';
import 'book_details_model.dart';

part 'book_model.g.dart';

enum BookStatus {
  available, // disponível para empréstimo
  lend, // emprestado
  library, // somente na biblioteca
  reading, // Está lendo
  donation, // para doação
}

extension BookStatusExtension on BookStatus {
  String get value => this.toString().split(".").last;

  String get label {
    switch (this) {
      case BookStatus.available:
        return "Para empréstimo";
      case BookStatus.lend:
        return "Está emprestado";
      case BookStatus.donation:
        return "Para doação";
      case BookStatus.reading:
        return "Estou lendo";
      case BookStatus.library:
      default:
        return "Indisponível";
    }
  }
}

BookStatus bookStatusFromString(String status) => BookStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => BookStatus.library,
    );

class BookModel = _BookModelBase with _$BookModel;

abstract class _BookModelBase with Store {
  String id;
  UserModel user;
  String isbn;
  String title;
  List<String> authors;
  int publishedYear;
  String publisher;
  int createdAt;
  @observable
  ImageModel cover;
  @observable
  List<ImageModel> imagesList;
  @observable
  BookDetailsModel details;
  BookStatus status;

  _BookModelBase({
    this.id,
    this.user,
    this.isbn,
    this.title,
    this.authors,
    this.publishedYear,
    this.publisher,
    this.createdAt,
    this.cover,
    this.imagesList,
    this.details,
    this.status,
  });

  _BookModelBase.fromMap(Map<dynamic, dynamic> map) {
    this.id = map['id'];
    this.user = map['user'] != null ? UserModel.fromMap(map['user']) : null;
    this.isbn = map['isbn'];
    this.title = map['title'];
    this.authors =
        map['authors'] != null ? List<String>.from(map['authors']) : [];
    this.publishedYear = map['publishedYear'];
    this.publisher = map['publisher'] ?? "";
    this.createdAt = map['createdAt'];
    this.cover = map['cover'] != null ? ImageModel.fromMap(map['cover']) : null;
    this.imagesList = [];
    this.details = map['details'] != null
        ? BookDetailsModel.fromMap(map['details'])
        : null;
    this.status = bookStatusFromString(map['status']);

    int index = 1;
    bool hasImageAtIndex = true;
    do {
      if (map["image$index"] != null) {
        this.imagesList.add(ImageModel.fromMap(map["image$index"]));
      } else {
        hasImageAtIndex = false;
      }
      index++;
    } while (hasImageAtIndex);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "user": user.toMapBasic(),
      "isbn": isbn,
      "title": title,
      "authors": authors,
      "publishedYear": publishedYear,
      "publisher": publisher,
      'createdAt': createdAt,
      "cover": cover != null ? cover.toMap() : null,
      "status": status.value,
    };
  }

  Map<String, dynamic> toMapBasic() {
    return {
      "id": id,
      "title": title,
    };
  }

  @override
  String toString() {
    return '_BookModelBase(id: $id, isbn: $isbn, title: $title)';
  }

  @action
  setCover(ImageModel newValue) => this.cover = newValue;

  @action
  setImage(ImageModel newValue, int index) {
    this.imagesList[index - 1] = newValue;
  }

  @action
  setDetails(BookDetailsModel newValue) => this.details = newValue;

  @computed
  bool get hasCover =>
      this.cover != null && this.cover.url != null && this.cover.url.isNotEmpty;

  @computed
  String get coverUrl => this.hasCover ? this.cover.url : null;

  @computed
  bool get hasDetails => this.details != null;

  @computed
  String get description => this.details?.description ?? "";

  String get publisherWithPublishedYear {
    if (this.publishedYear == null) return this.publisher;
    if (this.publisher.isEmpty) return "${this.publishedYear}";

    return "${this.publisher}, ${this.publishedYear}";
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is _BookModelBase && o.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  ImageModel getImageAtIndex(int imageIndex) {
    if (this.imagesList[imageIndex - 1] == null) {
      return null;
    }
    return this.imagesList[imageIndex - 1];
  }
}
