import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:pedantic/pedantic.dart';
import 'package:sabia_app/stores/auth_store.dart';

import '../../../interfaces/images_service_interface.dart';
import '../../../model/book/book_model.dart';
import '../../../model/user_model.dart';
import '../../../services/sabia_api_service.dart';
import '../../../stores/book_store.dart';
import '../../../utils/debounce.dart';

import '../model/feed_model.dart';

part 'feed_store.g.dart';

class FeedStore = _FeedStoreBase with _$FeedStore;

abstract class _FeedStoreBase extends Disposable with Store {
  List<ReactionDisposer> _disposersList;
  final SabiaApiService _sabiaApiService;
  final ImagesServiceInterface _imagesService;
  final AuthStore _authStore;
  final BookStore _bookStore;

  @observable
  String searchString = "";

  @observable
  bool isFetching = false;

  @observable
  ObservableList<UserModel> usersOnFeedList = ObservableList<UserModel>();

  _FeedStoreBase(
    this._authStore,
    this._bookStore,
    this._sabiaApiService,
    this._imagesService,
  ) {
    _disposersList ??= [
      reaction(
        (_) => this.searchString,
        (_) => this.getFeed(withDebouce: true),
      ),
      reaction((_) => this._authStore.isAuthenticated, (bool isAuthenticated) {
        if (!isAuthenticated) {
          this.clearStore();
        }
      })
    ];
  }

  @override
  void dispose() => _disposersList?.forEach((d) => d());

  @action
  setSearchString(String newValue) => this.searchString = newValue;

  @action
  setIsFetching(bool newValue) => this.isFetching = newValue;

  @action
  setUsersOnFeedList(List<UserModel> newList) {
    this.usersOnFeedList = newList.asObservable();
  }

  @computed
  List<FeedModel> get feedItemsList {
    return [
      ...this
          .usersOnFeedList
          .map((user) => FeedModel.user(data: user))
          .toList(),
      ...this
          ._bookStore
          .booksList
          .map((book) => FeedModel.book(data: book))
          .toList(),
    ];
  }

  void clearStore() {
    this.setUsersOnFeedList([]);
    this.setSearchString("");
  }

  void getFeed({bool withDebouce = false}) {
    this.setIsFetching(true);
    if (!withDebouce) {
      this._getFeed();
      return;
    }
    Debounce.seconds(1, () => this._getFeed());
  }

  Future<void> _getUserImage(UserModel user) {
    return this._imagesService.getUserImage(user);
  }

  Future<void> getBookCover(BookModel book) {
    return this._imagesService.getBookCover(book);
  }

  Future<void> _getFeed() async {
    this.setUsersOnFeedList([]);
    this._bookStore.setBooksList([]);

    final response = await this._sabiaApiService.getBooksForUserFeed(
          searchString: this.searchString,
        );

    if (response?.statusCode == 200) {
      List<BookModel> booksList = [];
      List<UserModel> usersList = [];
      List<dynamic> tempList = response.data;
      for (final item in tempList) {
        final itemMap = Map<String, dynamic>.from(item);
        if (itemMap != null) {
          final feedItem = FeedModel.fromMap(itemMap);

          if (feedItem != null && feedItem.isBook) {
            final book = feedItem.bookData;
            if (!book.hasCover && book.cover != null) {
              unawaited(this.getBookCover(book));
            }
            unawaited(this._getUserImage(book.user));

            booksList.add(book);
          } else if (feedItem != null && feedItem.isUser) {
            final user = feedItem.userData;
            unawaited(this._getUserImage(user));
            usersList.add(user);
          }
        }
      }

      this._bookStore.setBooksList(booksList);
      this.setUsersOnFeedList(usersList);
    }

    this.setIsFetching(false);
  }

  setSelectedBookForDetailsId(String id) {
    this._bookStore.setSelectedBookForDetailsId(id);
  }
}
