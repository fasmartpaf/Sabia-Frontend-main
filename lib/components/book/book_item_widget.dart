import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import "package:build_context/build_context.dart";

import '../user/user_feed_widget.dart';
import '../modal/book_collect_rating_modal.dart';
import '../book/book_image_widget.dart';
import '../button/button.dart';
import '../image/svg_image.dart';
import '../pagination/page_view_widget.dart';
import '../../model/book/book_model.dart';
import '../../stores/auth_store.dart';
import '../../stores/book_store.dart';
import '../../utils/styles.dart';

import 'book_status_widget.dart';

class BookItemWidget extends StatelessWidget {
  final BookModel book;
  final Function onTap;
  final String customStatus;
  final bool hideButton;
  final bool hideUser;
  final bool hideActionButtons;
  final bool displayAllImages;
  const BookItemWidget(
    this.book, {
    Key key,
    this.customStatus,
    this.hideButton = false,
    this.hideUser = false,
    this.hideActionButtons = false,
    this.displayAllImages = false,
    this.onTap,
  }) : super(key: key);

  Widget _renderExtraButton({
    String iconName,
    String label,
    bool isActive = false,
    Function onPressed,
  }) {
    final color = isActive ? kSuccessColor : kGrayActiveColor;
    return Opacity(
      opacity: isActive ? 1 : 0.4,
      child: FlatButton.icon(
        icon: SVGImage(
          iconName,
          color: color,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w300,
            fontSize: 12,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Column _renderBookMeta(BookModel book, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookStatusWidget(
          book.status,
          customStatus: this.customStatus,
        ),
        SizedBox(height: 4),
        Text(
          book.title,
          maxLines: 3,
          style: textTheme.headline5.copyWith(
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        Text(
          book.authors.join(", "),
          maxLines: 2,
          style: textTheme.headline5.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        if (book.publisherWithPublishedYear?.isNotEmpty ?? false)
          Text(
            book.publisherWithPublishedYear,
            maxLines: 2,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (book == null) {
      return SizedBox();
    }

    final textTheme = context.textTheme;
    final _authStore = Modular.get<AuthStore>();
    final _bookStore = Modular.get<BookStore>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!hideUser) UserFeedWidget(book.user),
        if (!hideUser) SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: Row(
            children: [
              if (displayAllImages)
                SizedBox(
                  width: 120,
                  child: PageViewWidget(
                    items: [
                      BookImageWidget(
                        imageUrl: book.coverUrl,
                        alt: book.title,
                        height: 200,
                        onErrorBookCoverUrl: (_) =>
                            _bookStore.onErrorBookCoverUrl(book),
                      ),
                      for (var image in book.imagesList)
                        BookImageWidget(
                          imageUrl: image.url,
                          alt: book.title,
                          height: 200,
                        ),
                    ],
                  ),
                )
              else
                InkWell(
                  onTap: onTap,
                  child: Observer(
                    builder: (_) => BookImageWidget(
                      imageUrl: book.coverUrl,
                      alt: book.title,
                      height: 200,
                      onErrorBookCoverUrl: (_) =>
                          _bookStore.onErrorBookCoverUrl(book),
                    ),
                  ),
                ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: onTap, child: _renderBookMeta(book, textTheme)),
                    if (!hideButton && book.status == BookStatus.available)
                      Button(
                        label: "Quero esse livro",
                        small: true,
                        onPressed: () =>
                            _bookStore.setSelectedBookForLoanId(book.id),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!hideActionButtons && (book.isbn?.isNotEmpty ?? false))
          Wrap(children: [
            Observer(
              builder: (_) {
                final didRead = _authStore.currentUserDidReadBook(
                  isbn: book.isbn,
                );
                return _renderExtraButton(
                  iconName: "heart",
                  label: "Já li",
                  isActive: didRead,
                  onPressed:
                      didRead ? null : () => BookCollectRatingModal.open(book),
                );
              },
            ),
            _renderExtraButton(
              iconName: "bookmark",
              label: "Ler depois",
              isActive: _authStore.currentUserDidWantToReadLaterBook(
                isbn: book.isbn,
              ),
              onPressed: () {},
            ),
            _renderExtraButton(
              iconName: "share",
              label: "Compartilhar",
              onPressed: () {},
            ),
          ]),
      ],
    );
  }
}
