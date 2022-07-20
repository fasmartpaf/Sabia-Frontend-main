import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sabia_app/components/button/button.dart';
import 'package:sabia_app/components/modal/modal.dart';
import 'package:sabia_app/utils/styles.dart';

enum SortOption {
  status,
  titleDown,
  titleUp,
  createdAtDown,
  createdAtUp,
}

class SortButton extends StatelessWidget {
  final SortOption sortBy;
  final Function(SortOption) onPressed;

  const SortButton(
    this.sortBy, {
    @required this.onPressed,
    Key key,
  }) : super(key: key);

  String get label {
    switch (this.sortBy) {
      case SortOption.status:
        return "Status";

      case SortOption.titleDown:
      case SortOption.titleUp:
        return "Título";

      case SortOption.createdAtDown:
      case SortOption.createdAtUp:
      default:
        return "Data";
    }
  }

  Icon get icon {
    IconData iconData;
    switch (this.sortBy) {
      case SortOption.status:
        iconData = FontAwesomeIcons.sort;
        break;

      case SortOption.titleDown:
      case SortOption.createdAtDown:
        iconData = FontAwesomeIcons.longArrowAltDown;
        break;

      case SortOption.titleUp:
      case SortOption.createdAtUp:
        iconData = FontAwesomeIcons.longArrowAltUp;
    }

    return Icon(
      iconData,
      size: 14,
    );
  }

  String fullLabelFor(SortOption option) {
    switch (option) {
      case SortOption.titleDown:
        return "Título ordem alfabética";

      case SortOption.titleUp:
        return "Título Z > A";

      case SortOption.createdAtDown:
        return "Mais antigos";

      case SortOption.createdAtUp:
        return "Mais recentes";

      case SortOption.status:
      default:
        return "Por status do livro";
    }
  }

  List<Widget> renderOptions() {
    List<Widget> list = [];
    for (var option in SortOption.values) {
      list.add(Button(
        outlined: true,
        fullWidth: true,
        uppercased: false,
        type: ButtonType.info,
        labelColor: option == this.sortBy ? kSuccessColor : kGrayInactiveColor,
        label: this.fullLabelFor(option),
        onPressed: () {
          Modular.to.pop();
          this.onPressed(option);
        },
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      textColor: kSuccessColor,
      visualDensity: VisualDensity.compact,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            this.label,
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 6.0),
          this.icon,
        ],
      ),
      onPressed: () {
        Modal.custom(
          barrierDismissible: true,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Ordenar por:",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              ...this.renderOptions(),
            ],
          ),
        );
      },
    );
  }
}
