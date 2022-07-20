import "package:flutter/material.dart";
import 'package:flutter_modular/flutter_modular.dart';
import '../button/button.dart';
import '../icon/app_icon.dart';

class Modal {
  static get shape => const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      );

  static get contentPadding => const EdgeInsets.fromLTRB(12, 12, 12, 12);

  static custom({
    @required Widget content,
    bool barrierDismissible = false,
    String title,
    Widget cancelButton,
    Widget confirmButton,
  }) {
    Modular.to.showDialog(
      barrierDismissible: barrierDismissible,
      child: AlertDialog(
        contentPadding: Modal.contentPadding,
        shape: Modal.shape,
        title: title != null
            ? Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
        content: content,
        actions: <Widget>[cancelButton, confirmButton],
      ),
    );
  }

  static withTextField({
    String title = "Insira o valor abaixo",
    String confirmLabel = "Confirmar",
    String initialValue = "",
    String inputLabel = "Valor",
    Function(String) onChanged,
    Function onConfirm,
  }) {
    Modal.custom(
      title: title,
      content: TextFormField(
        initialValue: initialValue,
        autofocus: true,
        onChanged: onChanged,
        decoration: InputDecoration(labelText: inputLabel),
      ),
      cancelButton: FlatButton(
        child: Text("Cancelar"),
        onPressed: () => Modular.to.pop(),
      ),
      confirmButton: Button(
        icon: CheckIcon,
        label: confirmLabel,
        onPressed: () {
          onConfirm();
          Modular.to.pop();
        },
      ),
    );
  }

  static info({
    String title,
    String message,
    Widget contentWidget,
  }) {
    Modal.custom(
      title: title,
      content: contentWidget != null
          ? contentWidget
          : Text(
              message,
              textAlign: TextAlign.center,
            ),
      confirmButton: PrimaryButton(
        icon: CheckIcon,
        label: "Ok",
        onPressed: () => Modular.to.pop(),
      ),
    );
  }

  static waiting({
    BuildContext context,
    String title = "Aguarde...",
  }) {
    Modal.custom(
      title: title,
      content: Container(
        margin: EdgeInsets.all(10.0),
        child: CircularProgressIndicator(),
      ),
      confirmButton: SuccessButton(
        icon: CheckIcon,
        label: "Ok",
        onPressed: () => Modular.to.pop(),
      ),
    );
  }

  static confirm({
    @required Function onConfirm,
    String title = "Confirme esta ação",
    String message = "Confirme para continuar",
    String confirmLabel = "Confirmar",
    String cancelLabel = "Cancelar",
  }) {
    Modal.custom(
      title: title,
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 14,
        ),
      ),
      cancelButton: FlatButton(
        child: Text(cancelLabel),
        onPressed: () => Modular.to.pop(),
      ),
      confirmButton: RaisedButton(
        child: Text(
          confirmLabel,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          onConfirm();
          Modular.to.pop();
        },
      ),
    );
  }

  static confirmDelete({
    @required Function onConfirm,
    String title = "Confirme esta ação",
    String message = "Esta ação não poderá ser desfeita.",
  }) {
    Modal.custom(
      title: title,
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 14,
        ),
      ),
      cancelButton: DangerButton(
        icon: DeleteIcon,
        label: "Apagar",
        onPressed: () {
          onConfirm();
          Modular.to.pop();
        },
      ),
      confirmButton: FlatButton(
        child: Text("Cancelar"),
        onPressed: () => Modular.to.pop(),
      ),
    );
  }
}
