import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../button/button.dart';
import '../../modal/modal.dart';

import '../../../utils/constants.dart';

import '../../icon/app_icon.dart';
import 'input_select_modal.dart';
import 'input_select_option.dart';
import 'input_select_store.dart';

class InputSelect extends StatefulWidget {
  final String label;
  final List<InputSelectOption> selectedOptions;
  final bool isMultiple;
  final IconData icon;
  final List<InputSelectOption> items;
  final void Function(List<InputSelectOption>) onChange;
  final InputSelectOption Function(String) didAdd;

  InputSelect({
    Key key,
    this.label,
    this.selectedOptions,
    this.isMultiple = false,
    this.icon,
    this.items,
    this.onChange,
    this.didAdd,
  }) : super(key: key);

  @override
  _InputSelectState createState() => _InputSelectState();
}

class _InputSelectState extends State<InputSelect> {
  ScrollController _scrollController;
  InputSelectStore _store;

  @override
  void initState() {
    super.initState();

    this._store = InputSelectStore(
      isMultiple: this.widget.isMultiple,
      didAdd: this.widget.didAdd,
      items: this.widget.items,
      onChange: this.widget.onChange,
      selectedOptions: this.widget.selectedOptions,
    );

    _scrollController = ScrollController(initialScrollOffset: 0);
  }

  didSave() {
    Modular.to.pop();
    _store.didSave();
  }

  didCancel() {
    Modular.to.pop();
    _store.didCancel();
  }

  didOpenModal(BuildContext context) {
    Modal.custom(
      content: InputSelectModal(
        scrollController: _scrollController,
        store: _store,
      ),
      cancelButton: FlatButton(
        child: Text("Cancelar"),
        onPressed: this.didCancel,
      ),
      confirmButton: Button(
        label: "Salvar",
        icon: SaveIcon,
        onPressed: this.didSave,
      ),
    );
  }

  String selectedValueLabel(
    bool isMultiple,
    List<InputSelectOption> selectedOptions,
  ) {
    if (isMultiple) {
      if (selectedOptions.isEmpty) return TEXT_PLACEHOLDER;
      String result = "";
      for (var i = 0; i < selectedOptions.length; i++) {
        final option = selectedOptions[i];
        if (i == 0) {
          result = option.label;
        } else if (i == selectedOptions.length - 1) {
          result += " e ${option.label}";
        } else {
          result += ", ${option.label}";
        }
      }
      return result;
    }

    return selectedOptions.isNotEmpty
        ? selectedOptions.first.label
        : TEXT_PLACEHOLDER;
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return ListTile(
          leading: this.widget.icon != null ? Icon(this.widget.icon) : null,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                this.widget.label,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                selectedValueLabel(_store.isMultiple, _store.selectedOptions),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          trailing: Icon(ChevronDownIcon),
          onTap: () => this.didOpenModal(context),
        );
      },
    );
  }
}
