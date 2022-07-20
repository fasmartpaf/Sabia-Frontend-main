import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sabia_app/components/sorting/sort_button.dart';

import '../../../components/loading/loading_view.dart';
import '../../../components/button/button.dart';
import '../../../components/book/book_list_item_widget.dart';
import '../../../components/icon/app_icon.dart';
import '../../../components/scaffold/app_scaffold.dart';
import '../../../components/search/input_search.dart';

import '../../../model/book/book_loan_model.dart';
import '../../../model/book/book_model.dart';
import '../../../model/user_model.dart';
import '../../../utils/book_utils.dart';
import '../../../utils/styles.dart';

import '../../../extensions/string_extension.dart';

import '../../../stores/book_store.dart';
import '../../../stores/book_loan_store.dart';
import '../../../stores/user_store.dart';

class UserLibraryPage extends StatefulWidget {
  final String userId;
  const UserLibraryPage(
    this.userId, {
    Key key,
  }) : super(key: key);

  @override
  _UserLibraryPageState createState() => _UserLibraryPageState();
}

class _UserLibraryPageState extends State<UserLibraryPage> {
  BookStore _bookStore;
  BookLoanStore _bookLoanStore;
  UserStore _userStore;

  TextEditingController _searchInputController =
      TextEditingController(text: "");
  bool _isSearching = false;

  SortOption _sortBy = SortOption.status;

  @override
  void initState() {
    super.initState();
    _userStore = Modular.get<UserStore>();

    _userStore.setUserId(this.widget.userId);

    this._bookStore = Modular.get<BookStore>();
    this._bookLoanStore = Modular.get<BookLoanStore>();

    _searchInputController.addListener(_inputSearchDidChange);
  }

  @override
  void dispose() {
    _searchInputController.removeListener(_inputSearchDidChange);
    super.dispose();
  }

  void _inputSearchDidChange() {
    setState(() {});
  }

  bool get _isCurrentUser => this._userStore.isCurrentUser;
  String get _searchString => this._searchInputController.text;

  List<BookModel> get _userBooksLibrary {
    final tempList = _userStore.booksLibrary;
    return sortBooksListWithBookLoan(
      _bookLoanStore.getBorrowedBookLoanOfBookIfExists,
      tempList,
    );
  }

  List<BookModel> get userBooksList {
    var tempList = [..._userBooksLibrary]
        .where((book) => _filterBookWithSearchString(
              book,
              _bookLoanStore.getLoanedBookLoanOfBookIfExists,
            ))
        .toList();

    if (_sortBy == SortOption.status) {
      return sortBooksListWithBookLoan(
        _bookLoanStore.getLoanedBookLoanOfBookIfExists,
        tempList,
      );
    }

    if (_sortBy == SortOption.titleDown) {
      tempList.sort((a, b) => a.title.compareTo(b.title));
    } else if (_sortBy == SortOption.titleUp) {
      tempList.sort((a, b) => b.title.compareTo(a.title));
    } else if (_sortBy == SortOption.createdAtDown) {
      tempList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } else if (_sortBy == SortOption.createdAtUp) {
      tempList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return tempList;
  }

  List<BookModel> get currentUserBorrowedBookLoans =>
      _bookLoanStore.currentUserBorrowedBookLoans.map((bookLoan) {
        final book = bookLoan.book;
        book.user = bookLoan.fromUser;

        return book;
      }).toList();

  List<BookModel> get bookLoanBooksList {
    final list = [...this.currentUserBorrowedBookLoans];
    return list
        .where((book) => _filterBookWithSearchString(
              book,
              _bookLoanStore.getBorrowedBookLoanOfBookIfExists,
            ))
        .toList();
  }

  bool _filterBookWithSearchString(
    BookModel book,
    BookLoanModel Function(String id) searchBookLoanFn,
  ) {
    final bookLoan = searchBookLoanFn(book.id);

    final matchTitle = book.title.searchContains(_searchString);
    final matchAuthors =
        book?.authors?.join(", ")?.searchContains(_searchString) ?? false;
    bool matchToUser = false;
    bool matchFromUser = false;

    if (bookLoan != null) {
      matchToUser =
          bookLoan.toUser?.name?.searchContains(_searchString) ?? false;
      matchFromUser =
          bookLoan.fromUser?.name?.searchContains(_searchString) ?? false;
    }

    return matchTitle || matchAuthors || matchToUser || matchFromUser;
  }

  void _setIsSearching(bool newValue) =>
      setState(() => _isSearching = newValue);

  void _setSortBy(SortOption newValue) => setState(() => _sortBy = newValue);

  Widget _renderUserBooksIsEmpty() => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: this._searchString.isNotEmpty
            ? Text("Nenhum resultado para a pesquisa atual.")
            : Column(
                children: [
                  Text(
                      "Isso aqui está muito vazio! Vamos adicionar seu primeiro livro?"),
                  SizedBox(height: 8),
                  Button(
                    label: "Cadastrar livro",
                    onPressed: () => _bookStore.setSelectedBookForFormId("new"),
                  ),
                ],
              ),
      );

  Widget renderSortButton() {
    return SortButton(
      this._sortBy,
      onPressed: this._setSortBy,
    );
  }

  Widget renderBody() {
    final textTheme = Theme.of(context).textTheme;
    return Observer(builder: (_) {
      if (_userStore.isFetching) {
        return LoadingView();
      }

      final listViewItemCount =
          (currentUserBorrowedBookLoans.isNotEmpty && bookLoanBooksList.isEmpty
                  ? 2
                  : bookLoanBooksList.length) +
              (userBooksList.isEmpty ? 1 : userBooksList.length) +
              (bookLoanBooksList.isEmpty ? 1 : 2);

      return ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        itemCount: listViewItemCount,
        itemBuilder: (BuildContext context, int index) {
          BookModel book;
          UserModel user;
          String sectionTitle;
          if (currentUserBorrowedBookLoans.isNotEmpty) {
            if (index == 0) {
              sectionTitle = bookLoanBooksList.length > 1
                  ? "Livros emprestados"
                  : "Livro emprestado";
            } else if (currentUserBorrowedBookLoans.isNotEmpty &&
                index == 1 &&
                bookLoanBooksList.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Text("Nenhum resultado para a pesquisa atual."),
              );
            } else if (index <= bookLoanBooksList.length) {
              book = bookLoanBooksList[index - 1];
              user = book.user;
            } else if ((bookLoanBooksList.isEmpty && index == 2) ||
                index == bookLoanBooksList.length + 1) {
              sectionTitle = "Meus livros";
            } else if (userBooksList.isEmpty) {
              return _renderUserBooksIsEmpty();
            } else {
              book = userBooksList[index -
                  2 -
                  (bookLoanBooksList.isEmpty ? 1 : bookLoanBooksList.length)];
            }
          } else {
            if (index == 0) {
              sectionTitle = "Meus livros";
            } else if (userBooksList.isEmpty) {
              return _renderUserBooksIsEmpty();
            } else {
              book = userBooksList[index - 1];
            }
          }
          if (sectionTitle != null) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index != 0) SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          sectionTitle,
                          style: textTheme.subtitle1.copyWith(
                            fontSize: 12,
                            color: kOrangeColor,
                          ),
                        ),
                      ),
                      this.renderSortButton(),
                    ],
                  ),
                  Divider(
                    height: 4,
                    color: kOrangeColor,
                    endIndent: 100,
                  ),
                  SizedBox(height: 6),
                ],
              ),
            );
          }
          if (book != null) {
            return BookListItemWidget(
              book,
              user: user,
              onTap: () => this._bookStore.setSelectedBookForDetailsId(book.id),
            );
          }
          return SizedBox();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: _isCurrentUser ? "Minha biblioteca" : "Biblioteca",
      titleWidget: this._isSearching
          ? InputSearch(
              controller: _searchInputController,
              label: "pesquise livros...",
            )
          : null,
      trailing: this._isSearching
          ? IconButton(
              icon: Icon(
                CloseIcon,
                color: kSuccessColor,
                size: 16,
              ),
              onPressed: () {
                this._setIsSearching(false);
                this._searchInputController.text = "";
              },
            )
          : Row(
              children: [
                Observer(
                  builder: (_) {
                    if (_userBooksLibrary.isNotEmpty) {
                      return IconButton(
                        icon: Icon(
                          SearchIcon,
                          color: kSuccessColor,
                        ),
                        iconSize: 16,
                        visualDensity: VisualDensity.compact,
                        onPressed: () => this._setIsSearching(true),
                      );
                    }
                    return SizedBox();
                  },
                ),
                IconButton(
                  icon: ClipOval(
                    child: Container(
                      width: 20,
                      height: 20,
                      color: kOrangeColor,
                      child: Center(
                        child: Icon(
                          AddIcon,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  color: kOrangeColor,
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _bookStore.setSelectedBookForFormId("new"),
                ),
              ],
            ),
      child: this.renderBody(),
    );
  }
}
