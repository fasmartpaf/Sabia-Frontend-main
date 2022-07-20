import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import 'input_select_option.dart';
import '../../../extensions/string_extension.dart';

part 'input_select_store.g.dart';

class InputSelectStore = _InputSelectStoreBase with _$InputSelectStore;

abstract class _InputSelectStoreBase extends Disposable with Store {
  final bool isMultiple;
  final void Function(List<InputSelectOption>) onChange;
  final InputSelectOption Function(String) didAdd;

  final TextEditingController searchController =
      TextEditingController(text: "");

  _InputSelectStoreBase({
    @required List<InputSelectOption> items,
    @required List<InputSelectOption> selectedOptions,
    @required this.isMultiple,
    @required this.onChange,
    @required this.didAdd,
  }) {
    this.setOptionsList(items);
    this.setSelectedOptions(selectedOptions);

    searchController.addListener(_searchControllerListener);
  }

  @override
  dispose() {
    searchController.removeListener(_searchControllerListener);
  }

  @observable
  ObservableList<InputSelectOption> optionsList =
      ObservableList<InputSelectOption>();

  @observable
  ObservableList<InputSelectOption> selectedOptions =
      ObservableList<InputSelectOption>();

  @observable
  ObservableList<InputSelectOption> tempSelectedOptions =
      ObservableList<InputSelectOption>();

  @observable
  String searchString = "";

  @computed
  bool get canAdd => searchString.isNotEmpty && didAdd != null;

  @computed
  List<InputSelectOption> get filteredOptionsList {
    if (this.searchString.isNotEmpty) {
      return this
          .optionsList
          .where(
            (item) => item.label.searchContains(searchString),
          )
          .toList();
    }
    return this.optionsList;
  }

  @action
  void setOptionsList(List<InputSelectOption> newList) =>
      this.optionsList = newList.asObservable();

  @action
  void setSelectedOptions(List<InputSelectOption> newList) {
    this.selectedOptions = newList.toList().asObservable();

    this.tempSelectedOptions = newList.toList().asObservable();
  }

  @action
  void setSearchString(String newValue) => this.searchString = newValue;

  @action
  void didCancel() {
    this.tempSelectedOptions = selectedOptions.toList().asObservable();
    this.clearSearch();
  }

  @action
  void didSelect(InputSelectOption option) {
    if (tempSelectedOptions.contains(option)) {
      tempSelectedOptions.removeWhere(($0) => $0 == option);
    } else {
      if (!this.isMultiple) {
        this.tempSelectedOptions.clear();
      }
      tempSelectedOptions.add(option);
    }
  }

  _searchControllerListener() => this.setSearchString(searchController.text);

  void clearSearch() {
    searchController.text = "";
  }

  void didSave() {
    this.setSelectedOptions(this.tempSelectedOptions.toList());
    this.onChange(this.selectedOptions);

    this.clearSearch();
  }

  @action
  void didWantToAdd() {
    final newTag = this.didAdd(this.searchString);

    this.optionsList.add(newTag);
    this.optionsList.sort((a, b) => a.label.compareTo(b.label));

    this.clearSearch();
    this.tempSelectedOptions.add(newTag);
  }
}
