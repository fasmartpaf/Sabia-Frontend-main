import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../button/button.dart';

import 'modal.dart';

class ImagePickerModal {
  static open({
    @required Function(int) didSelect,
    bool isNewImage = true,
  }) {
    Modal.custom(
      barrierDismissible: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: isNewImage
            ? [
                SizedBox(height: 20),
                Button(
                  label: "Câmera",
                  fullWidth: true,
                  icon: Icons.camera_alt,
                  onPressed: () {
                    Modular.to.pop();
                    didSelect(0);
                  },
                ),
                SizedBox(height: 20),
                Button(
                  label: "Biblioteca",
                  fullWidth: true,
                  icon: Icons.photo_library,
                  onPressed: () {
                    Modular.to.pop();
                    didSelect(1);
                  },
                ),
              ]
            : [
                SizedBox(height: 20),
                Button(
                  label: "Remover imagem",
                  fullWidth: true,
                  icon: Icons.delete,
                  onPressed: () {
                    Modular.to.pop();
                    didSelect(-1);
                  },
                ),
              ],
      ),
    );
  }
}
