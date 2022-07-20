// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_select_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$InputSelectStore on _InputSelectStoreBase, Store {
  Computed<bool> _$canAddComputed;

  @override
  bool get canAdd => (_$canAddComputed ??= Computed<bool>(() => super.canAdd,
          name: '_InputSelectStoreBase.canAdd'))
      .value;
  Computed<List<InputSelectOption>> _$filteredOptionsListComputed;

  @override
  List<InputSelectOption> get filteredOptionsList =>
      (_$filteredOptionsListComputed ??= Computed<List<InputSelectOption>>(
              () => super.filteredOptionsList,
              name: '_InputSelectStoreBase.filteredOptionsList'))
          .value;

  final _$optionsListAtom = Atom(name: '_InputSelectStoreBase.optionsList');

  @override
  ObservableList<InputSelectOption> get optionsList {
    _$optionsListAtom.reportRead();
    return super.optionsList;
  }

  @override
  set optionsList(ObservableList<InputSelectOption> value) {
    _$optionsListAtom.reportWrite(value, super.optionsList, () {
      super.optionsList = value;
    });
  }

  final _$selectedOptionsAtom =
      Atom(name: '_InputSelectStoreBase.selectedOptions');

  @override
  ObservableList<InputSelectOption> get selectedOptions {
    _$selectedOptionsAtom.reportRead();
    return super.selectedOptions;
  }

  @override
  set selectedOptions(ObservableList<InputSelectOption> value) {
    _$selectedOptionsAtom.reportWrite(value, super.selectedOptions, () {
      super.selectedOptions = value;
    });
  }

  final _$tempSelectedOptionsAtom =
      Atom(name: '_InputSelectStoreBase.tempSelectedOptions');

  @override
  ObservableList<InputSelectOption> get tempSelectedOptions {
    _$tempSelectedOptionsAtom.reportRead();
    return super.tempSelectedOptions;
  }

  @override
  set tempSelectedOptions(ObservableList<InputSelectOption> value) {
    _$tempSelectedOptionsAtom.reportWrite(value, super.tempSelectedOptions, () {
      super.tempSelectedOptions = value;
    });
  }

  final _$searchStringAtom = Atom(name: '_InputSelectStoreBase.searchString');

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

  final _$_InputSelectStoreBaseActionController =
      ActionController(name: '_InputSelectStoreBase');

  @override
  void setOptionsList(List<InputSelectOption> newList) {
    final _$actionInfo = _$_InputSelectStoreBaseActionController.startAction(
        name: '_InputSelectStoreBase.setOptionsList');
    try {
      return super.setOptionsList(newList);
    } finally {
      _$_InputSelectStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedOptions(List<InputSelectOption> newList) {
    final _$actionInfo = _$_InputSelectStoreBaseActionController.startAction(
        name: '_InputSelectStoreBase.setSelectedOptions');
    try {
      return super.setSelectedOptions(newList);
    } finally {
      _$_InputSelectStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearchString(String newValue) {
    final _$actionInfo = _$_InputSelectStoreBaseActionController.startAction(
        name: '_InputSelectStoreBase.setSearchString');
    try {
      return super.setSearchString(newValue);
    } finally {
      _$_InputSelectStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void didCancel() {
    final _$actionInfo = _$_InputSelectStoreBaseActionController.startAction(
        name: '_InputSelectStoreBase.didCancel');
    try {
      return super.didCancel();
    } finally {
      _$_InputSelectStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void didSelect(InputSelectOption option) {
    final _$actionInfo = _$_InputSelectStoreBaseActionController.startAction(
        name: '_InputSelectStoreBase.didSelect');
    try {
      return super.didSelect(option);
    } finally {
      _$_InputSelectStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void didWantToAdd() {
    final _$actionInfo = _$_InputSelectStoreBaseActionController.startAction(
        name: '_InputSelectStoreBase.didWantToAdd');
    try {
      return super.didWantToAdd();
    } finally {
      _$_InputSelectStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
optionsList: ${optionsList},
selectedOptions: ${selectedOptions},
tempSelectedOptions: ${tempSelectedOptions},
searchString: ${searchString},
canAdd: ${canAdd},
filteredOptionsList: ${filteredOptionsList}
    ''';
  }
}
