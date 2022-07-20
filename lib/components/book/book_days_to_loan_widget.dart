import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../button/button.dart';
import '../icon/app_icon.dart';
import '../modal/modal.dart';

import '../../model/book/book_loan_model.dart';

import '../../stores/book_loan_store.dart';
import '../../utils/styles.dart';
import '../../utils/date_time_util.dart';

import '../form/input_slider.dart';

class BookDaysToLoanWidget extends StatelessWidget {
  final double value;
  final Function(double) onChanged;

  const BookDaysToLoanWidget({
    @required this.value,
    @required this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputSlider(
      value: this.value,
      max: 60,
      maxLabel: "60 dias",
      min: 7,
      minLabel: "7 dias",
      format: (value) => "$value dias".replaceAll(".0", ""),
      onChanged: this.onChanged,
    );
  }
}

class BookDaysToLoanModal {
  static open(
    BuildContext context,
    BookLoanStore _bookLoanStore,
    BookLoanModel _bookLoan,
  ) {
    final textTheme = Theme.of(context).textTheme;
    Modal.custom(
      barrierDismissible: true,
      title: "Por quanto tempo você quer emprestar o livro?",
      content: Observer(
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BookDaysToLoanWidget(
                value: _bookLoanStore.daysToLoan,
                onChanged: _bookLoanStore.setDaysToLoan,
              ),
              Text(
                "até:",
                textAlign: TextAlign.center,
                style: textTheme.subtitle2,
              ),
              Text(
                DateTime.now()
                    .addDays(_bookLoanStore.daysToLoan.round())
                    .display(),
                textAlign: TextAlign.center,
                style: textTheme.subtitle1.copyWith(
                  fontSize: 16,
                  color: kSuccessColor,
                ),
              ),
            ],
          );
        },
      ),
      cancelButton: Button(
        label: "Cancelar",
        flat: true,
        onPressed: () {
          Modular.to.pop();
          _bookLoanStore.setDaysToLoan(30);
        },
      ),
      confirmButton: Button(
        label: "CONFIRMAR",
        icon: CheckIcon,
        labelColor: Colors.white,
        onPressed: () => _bookLoanStore.didApproveLoan(_bookLoan),
      ),
    );
  }
}
