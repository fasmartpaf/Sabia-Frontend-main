// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FeedStore on _FeedStoreBase, Store {
  Computed<List<FeedModel>> _$feedItemsListComputed;

  @override
  List<FeedModel> get feedItemsList => (_$feedItemsListComputed ??=
          Computed<List<FeedModel>>(() => super.feedItemsList,
              name: '_FeedStoreBase.feedItemsList'))
      .value;

  final _$searchStringAtom = Atom(name: '_FeedStoreBase.searchString');

  @override
  String get searchString {
    _$searchStringAtom.reportRead();
    return super.searchString;
  }

  @override
  set searchString(String value) {
    _$searchStringAtom.reportWrite(value, super.searchString, () {
      super.searchString = value;
    });
  }

  final _$isFetchingAtom = Atom(name: '_FeedStoreBase.isFetching');

  @override
  bool get isFetching {
    _$isFetchingAtom.reportRead();
    return super.isFetching;
  }

  @override
  set isFetching(bool value) {
    _$isFetchingAtom.reportWrite(value, super.isFetching, () {
      super.isFetching = value;
    });
  }

  final _$usersOnFeedListAtom = Atom(name: '_FeedStoreBase.usersOnFeedList');

  @override
  ObservableList<UserModel> get usersOnFeedList {
    _$usersOnFeedListAtom.reportRead();
    return super.usersOnFeedList;
  }

  @override
  set usersOnFeedList(ObservableList<UserModel> value) {
    _$usersOnFeedListAtom.reportWrite(value, super.usersOnFeedList, () {
      super.usersOnFeedList = value;
    });
  }

  final _$_FeedStoreBaseActionController =
      ActionController(name: '_FeedStoreBase');

  @override
  dynamic setSearchString(String newValue) {
    final _$actionInfo = _$_FeedStoreBaseActionController.startAction(
        name: '_FeedStoreBase.setSearchString');
    try {
      return super.setSearchString(newValue);
    } finally {
      _$_FeedStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsFetching(bool newValue) {
    final _$actionInfo = _$_FeedStoreBaseActionController.startAction(
        name: '_FeedStoreBase.setIsFetching');
    try {
      return super.setIsFetching(newValue);
    } finally {
      _$_FeedStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUsersOnFeedList(List<UserModel> newList) {
    final _$actionInfo = _$_FeedStoreBaseActionController.startAction(
        name: '_FeedStoreBase.setUsersOnFeedList');
    try {
      return super.setUsersOnFeedList(newList);
    } finally {
      _$_FeedStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchString: ${searchString},
isFetching: ${isFetching},
usersOnFeedList: ${usersOnFeedList},
feedItemsList: ${feedItemsList}
    ''';
  }
}
