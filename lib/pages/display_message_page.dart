import 'package:flutter/material.dart';
import 'package:sabia_app/components/container/no_pop_container.dart';
import 'package:sabia_app/components/image/svg_image.dart';
import 'package:sabia_app/components/text/card_message_text.dart';
import 'package:sabia_app/components/text/section_title.dart';
import 'package:sabia_app/utils/styles.dart';

class DisplayMessagePage extends StatelessWidget {
  final String confirmLabel;
  final Function onConfirm;
  final Widget iconWidget;
  final String title;
  final List<Widget> children;
  const DisplayMessagePage({
    @required this.title,
    this.iconWidget,
    this.confirmLabel,
    this.onConfirm,
    this.children,
    Key key,
  }) : super(key: key);

  static DisplayMessagePage didConfirmBookReceived({
    @required String expireDay,
    Function onConfirm,
  }) {
    return DisplayMessagePage(
      title: "Obrigado por avisar!",
      iconWidget: SVGImage("checkmark", color: kSuccessColor),
      confirmLabel: "Voltar",
      onConfirm: onConfirm,
      children: [
        CardMessageText(
          "O seu tempo de empréstimo começa agora. Boa leitura ;)",
        ),
        SizedBox(height: 26),
        CardMessageText(
          "Tempo de empréstimo:",
        ),
        SizedBox(height: 6),
        CardMessageText(
          expireDay,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  static DisplayMessagePage toReturnBookToOwner({Function onConfirm}) {
    return DisplayMessagePage(
      title: "É hora do livro voltar para casa!",
      confirmLabel: "Combinar devolução",
      onConfirm: onConfirm,
      children: [
        CardMessageText(
          "O prazo de empréstimo acabou. Espero que tenha conseguido aproveita-lo! Combine agora a devolução dele :)",
        ),
      ],
    );
  }

  static DisplayMessagePage didConfirmLoanToReader({Function onConfirm}) {
    return DisplayMessagePage(
      title: "Legal, empréstimo confirmado!",
      iconWidget: SVGImage("checkmark", color: kSuccessColor),
      confirmLabel: "Combinar entrega",
      onConfirm: onConfirm,
      children: [
        CardMessageText(
          "Agora basta combinar como você vai pegar ele :)",
        ),
      ],
    );
  }

  static DisplayMessagePage didConfirmLoanToOwner({Function onConfirm}) {
    return DisplayMessagePage(
      title: "Legal!",
      iconWidget: SVGImage("checkmark", color: kSuccessColor),
      confirmLabel: "Combinar entrega",
      onConfirm: onConfirm,
      children: [
        CardMessageText(
          "Agora basta combinar a entrega do livro e confirmar o empréstimo :)",
        ),
      ],
    );
  }

  static DisplayMessagePage didRejectLoan({Function onConfirm}) {
    return DisplayMessagePage(
      title: "Poxa, que pena!",
      iconWidget: SVGImage("egg", color: kOrangeColor),
      confirmLabel: "Voltar para notificações",
      onConfirm: onConfirm,
      children: [
        CardMessageText(
          "Vamos avisar o interessado que não vai dar para emprestar dessa vez.",
        ),
      ],
    );
  }

  static DisplayMessagePage didNotReceivedBookLoan({Function onConfirm}) {
    return DisplayMessagePage(
      title: "Fique tranquilo!",
      iconWidget: SVGImage("egg", color: kOrangeColor),
      confirmLabel: "Entre em contato",
      onConfirm: onConfirm,
      children: [
        CardMessageText(
          "Vamos avisar o dono(a) do livro que ele não foi entregue. Você também pode combinar novamente a entrega.",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return NoPopContainer(
      submitLabel: this.confirmLabel,
      onSubmit: this.onConfirm,
      children: [
        if (this.iconWidget != null) this.iconWidget,
        SizedBox(height: 40),
        SectionTitle(
          this.title,
        ),
        SizedBox(height: 16),
        ...this.children,
      ],
    );
  }
}
