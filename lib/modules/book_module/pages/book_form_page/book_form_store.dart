import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../model/book/book_model.dart';
import '../../../../stores/book_store.dart';

part 'book_form_store.g.dart';

class BookFormStore = BookFormStoreBase with _$BookFormStore;

enum BookFormStoreView {
  isbn,
  confirmMetadata,
  notFoundByIsbn,
  metadata,
  images,
}

abstract class BookFormStoreBase extends Disposable with Store {
  final BookStore _bookStore;

  BookFormStoreBase(this._bookStore) {
    if (this._bookStore.selectedBook != null) {
      final book = this._bookStore.selectedBook;
      this.setTitle(book.title);
      this.setAuthors(book.authors.join(", "));
      this.setIsbn(book.isbn);
      this.setStatus(book.status);
    }
  }

  @override
  dispose() {}

  @observable
  String isbn = "";
  @observable
  String title = "";
  @observable
  String authors = "";
  @observable
  String coverUrl = "";

  @observable
  BookStatus status = BookStatus.available;

  @observable
  bool isManualIsbn = false;
  @observable
  bool isSearchingBook = false;
  @observable
  ObservableList<dynamic> images = ObservableList<dynamic>();

  @observable
  BookFormStoreView view = BookFormStoreView.isbn;

  @observable
  bool isWaitingForm = false;
  @observable
  bool formWasSubmit = false;

  String lastNotFoundIsbn = "";

  @action
  setIsbn(String newValue) => this.isbn = newValue;
  @action
  setTitle(String newValue) => this.title = newValue;

  @action
  setAuthors(String newValue) => this.authors = newValue;
  @action
  setCoverUrl(String newValue) => this.coverUrl = newValue;
  @action
  setStatus(BookStatus newValue) => this.status = newValue;
  @action
  setIsManualIsbn(bool newValue) => this.isManualIsbn = newValue;
  @action
  setIsSearchingBook(bool newValue) => this.isSearchingBook = newValue;
  @action
  setImages(List<dynamic> newList) => this.images = newList.asObservable();
  @action
  addImage(dynamic newFile) => this.images.add(newFile);
  @action
  removeImage(int indexToRemove) => this.images.removeAt(indexToRemove);

  @action
  setIsWaitingForm(bool newValue) => this.isWaitingForm = newValue;
  @action
  setFormWasSubmit(bool newValue) => this.formWasSubmit = newValue;

  Map<String, dynamic> bookMetadataFromIsbn = {};

  @action
  _setView(BookFormStoreView newValue) {
    this.formWasSubmit = false;
    this.view = newValue;
  }

  @action
  _resetMetadata() {
    this.title = "";
    this.authors = "";
    this.images.clear();
    this.coverUrl = "";
  }

  @computed
  bool get isValidImages => this.images.isNotEmpty;
  @computed
  bool get isValidAuthors => this.authors.length > 2;
  @computed
  bool get isValidIsbn => this.isbn.length == 10 || this.isbn.length == 13;
  @computed
  bool get isValidTitle => this.title.length > 2;

  @computed
  bool get isIsbnView => this.view == BookFormStoreView.isbn;
  @computed
  bool get isConfirmMetadataView =>
      this.view == BookFormStoreView.confirmMetadata;
  @computed
  bool get isNotFoundByIsbnView =>
      this.view == BookFormStoreView.notFoundByIsbn;
  @computed
  bool get isMetadataView => this.view == BookFormStoreView.metadata;
  @computed
  bool get isImagesView => this.view == BookFormStoreView.images;

  @computed
  String get validateImagesMessage => this.formWasSubmit
      ? this.isValidImages ? null : "Envie pelo menos uma foto do seu livro!"
      : null;
  @computed
  String get validateIsbnMessage => this.formWasSubmit
      ? this.isValidIsbn ? null : "Código ISBN inválido."
      : null;

  @computed
  String get validateTitleMessage => this.formWasSubmit
      ? isValidTitle ? null : "Informe título com pelo menos 3 caracteres."
      : null;
  @computed
  String get validateAuthorsMessage => this.formWasSubmit
      ? isValidAuthors ? null : "Informe o nome do Autor."
      : null;

  @computed
  bool get shouldDisplaySubmitButton {
    if (this.isIsbnView ||
        this.isConfirmMetadataView ||
        this.isNotFoundByIsbnView) {
      return false;
    }
    return true;
  }

  @computed
  String get submitButtonLabel {
    if (this.isImagesView) {
      return "Confirmar";
    }
    return "Próximo";
  }

  @computed
  IconData get submitButtonIcon {
    if (this.isImagesView) {
      return Icons.check;
    }
    return Icons.chevron_right;
  }

  backView() {
    if (this.isMetadataView) {
      this.setIsbnView();
    } else if (this.isImagesView) {
      this.setIsbnView();
    } else if (this.isNotFoundByIsbnView) {
      this.setIsbnView();
    }
  }

  setIsbnView() {
    this._setView(BookFormStoreView.isbn);
  }

  _setConfirmMetadataView() {
    this._setView(BookFormStoreView.confirmMetadata);
  }

  _setNotFoundByIsbnView() {
    this._setView(BookFormStoreView.notFoundByIsbn);
    this.lastNotFoundIsbn = this.isbn;
  }

  setMetadataView() {
    this._setView(BookFormStoreView.metadata);
  }

  setImagesView() {
    this._setView(BookFormStoreView.images);
  }

  void submit() async {
    this.setFormWasSubmit(true);

    if (isMetadataView && isValidTitle && isValidAuthors) {
      this.setImagesView();
    } else if (isImagesView && isValidImages) {
      this.setIsWaitingForm(true);
      try {
        final book = BookModel(
          isbn: this.isbn,
          title: this.title.trim(),
          authors: this.authors.trim().split(", "),
          publishedYear: this.bookMetadataFromIsbn.containsKey("publishedYear")
              ? this.bookMetadataFromIsbn["publishedYear"]
              : null,
          publisher: this.bookMetadataFromIsbn.containsKey("publisher")
              ? this.bookMetadataFromIsbn["publisher"]
              : "",
          status: BookStatus.available,
        );
        await this._bookStore.submitBook(
              book,
              images: this.images.whereType<File>().toList(),
            );
      } catch (e) {
        this.setIsWaitingForm(false);
        print("error while saving book $e");
      }
    }
  }

  tryToGetBookDataFromIsbn() async {
    if (this.isManualIsbn) {
      this.setFormWasSubmit(true);
    }
    if (!this.isValidIsbn) {
      this.setIsManualIsbn(true);
      return;
    }

    this._resetMetadata();
    this.setIsSearchingBook(true);

    if (this.isbn == this.lastNotFoundIsbn) {
      await Future.delayed(Duration(seconds: 1), this.setMetadataView);
      this.setIsSearchingBook(false);
      return;
    }

    debugPrint("tryToGetBookDataFromIsbn");

    try {
      this.bookMetadataFromIsbn = await this._bookStore.getBookData(this.isbn);

      if (bookMetadataFromIsbn != null) {
        if (bookMetadataFromIsbn.containsKey("title")) {
          this.setTitle(bookMetadataFromIsbn["title"]);
        }
        if (bookMetadataFromIsbn.containsKey("authors")) {
          this.setAuthors(bookMetadataFromIsbn["authors"].join(", "));
        }
        if (bookMetadataFromIsbn.containsKey("coverUrl")) {
          this.setCoverUrl(bookMetadataFromIsbn["coverUrl"]);
        }
        this._setConfirmMetadataView();
      } else {
        this.bookMetadataFromIsbn = {};
        this._setNotFoundByIsbnView();
      }

      this.setIsSearchingBook(false);
    } catch (e) {
      debugPrint("error in tryToGetBookDataFromIsbn $e");
      this.bookMetadataFromIsbn.clear();
      this._setNotFoundByIsbnView();
    }
  }

  void setIsbnIsWrong() {
    this._bookStore.setIsbnIsWrong(this.isbn);
    this.setMetadataView();
  }

  void update() {
    this._bookStore.updateBook(
          updatedStatus: this.status,
        );
  }
}
