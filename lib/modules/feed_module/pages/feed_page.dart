import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sabia_app/components/loading/loading_view.dart';
import 'package:sabia_app/components/user/user_feed_widget.dart';

import '../../../components/book/book_item_widget.dart';
import '../../../components/container/rounded_bottom_container.dart';
import '../../../components/general/empty_state_message.dart';
import '../../../components/search/input_search.dart';
import '../../../stores/book_loan_store.dart';
import '../store/feed_store.dart';
import '../../../utils/styles.dart';

import 'feed_slider_appbar_delegate.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  TextEditingController _searchInputController =
      TextEditingController(text: "");
  FeedStore _feedStore;
  BookLoanStore _bookLoanStore;

  @override
  void initState() {
    super.initState();

    this._feedStore = Modular.get<FeedStore>();
    this._bookLoanStore = Modular.get<BookLoanStore>();

    if (this._feedStore.feedItemsList.isEmpty) {
      this._feedStore.getFeed();
    }

    _searchInputController.text = _feedStore.searchString;
    _searchInputController.addListener(_inputSearchDidChange);
  }

  @override
  void dispose() {
    _searchInputController.removeListener(_inputSearchDidChange);
    super.dispose();
  }

  void _inputSearchDidChange() {
    _feedStore.setSearchString(_searchInputController.text);
  }

  Widget _renderIsLastIndex() {
    return Opacity(
      opacity: 0.4,
      child: Stack(alignment: AlignmentDirectional.center, children: [
        Divider(
          color: kGrayActiveColor,
        ),
        Center(
          child: Container(
            color: kGrayBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: EmptyStateMessage(),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _renderFeedList() {
    return Observer(
      builder: (_) {
        if (_feedStore.isFetching) {
          return LoadingView();
        }
        return RefreshIndicator(
          onRefresh: () async => _feedStore.getFeed(),
          child: ListView.separated(
            separatorBuilder: (_, __) => SizedBox(height: 20),
            itemCount: _feedStore.feedItemsList.length + 1,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            itemBuilder: (BuildContext context, int index) {
              if (index >= _feedStore.feedItemsList.length) {
                return this._renderIsLastIndex();
              }

              Widget child;

              if (_feedStore.feedItemsList[index].isBook) {
                final book = _feedStore.feedItemsList[index].bookData;
                if (_bookLoanStore.currentUserBorrowedLoanedBooksList
                    .contains(book)) {
                  return Container();
                }
                final _didSelectBook =
                    () => _feedStore.setSelectedBookForDetailsId(book.id);

                child = BookItemWidget(book, onTap: _didSelectBook);
              }

              if (_feedStore.feedItemsList[index].isUser) {
                final user = _feedStore.feedItemsList[index].userData;
                child = UserFeedWidget(user);
              }

              return child == null
                  ? Container()
                  : Column(
                      children: [
                        child,
                        Divider(),
                      ],
                    );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.backgroundColor;

    return NestedScrollView(
      headerSliverBuilder: (_, __) => [
        SliverPersistentHeader(
          pinned: true,
          delegate: FeedSliverPersistentHeaderDelegate(
            minHeight: 80.0,
            maxHeight: 180.0,
            builder: (_, __) {
              return RoundedBottomContainer(
                cardColor: backgroundColor,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Spacer(),
                        Expanded(
                          child: Text(
                            "Sabiá",
                            style: theme.textTheme.headline6.copyWith(
                              fontSize: 28,
                            ),
                          ),
                        ),
                        InputSearch(
                          controller: _searchInputController,
                          label: "procure por pessoas ou livros...",
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
      body: _renderFeedList(),
    );
  }
}
