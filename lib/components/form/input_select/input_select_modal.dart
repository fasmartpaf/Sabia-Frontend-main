import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../button/button.dart';
import '../../icon/app_icon.dart';

import 'input_select_store.dart';

class InputSelectModal extends StatelessWidget {
  final ScrollController scrollController;
  final InputSelectStore store;

  const InputSelectModal({
    Key key,
    this.store,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (this.store.selectedOptions.isEmpty) return;
      var index = this
          .store
          .optionsList
          .indexWhere((item) => item == this.store.selectedOptions.first);
      if (index >= 0) {
        scrollController.animateTo(
          index * 30.0,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });

    return Observer(
      builder: (_) {
        final filteredList = store.filteredOptionsList;
        return Container(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              controller: store.searchController,
              decoration: InputDecoration(
                hintText: "pesquise...",
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                suffixIcon: store.searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(CloseIcon),
                        onPressed: store.clearSearch,
                      )
                    : null,
              ),
            ),
            Expanded(
              child: filteredList.isEmpty
                  ? Column(
                      children: <Widget>[
                        SizedBox(height: 16),
                        Text(
                          "nada encontrado",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                        SizedBox(height: 16),
                        if (store.canAdd)
                          Button(
                            label: "adicionar?",
                            onPressed: store.didWantToAdd,
                            flat: true,
                          )
                      ],
                    )
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: filteredList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Observer(
                          builder: (_) {
                            var item = filteredList[index];
                            final bool isSelected =
                                store.tempSelectedOptions.contains(item);

                            final Color textColor = isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey;
                            return InkWell(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      isSelected ? CheckSquareIcon : SquareIcon,
                                      size: 16,
                                      color: textColor,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        item.label,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () => store.didSelect(item),
                            );
                          },
                        );
                      },
                    ),
            ),
            Divider(),
          ]),
        );
      },
    );
  }
}
