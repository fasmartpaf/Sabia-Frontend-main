import 'package:flutter/material.dart';
import 'package:sabia_app/components/button/submit_button.dart';

import 'app_card.dart';

class NoPopContainer extends StatelessWidget {
  final List<Widget> children;
  final String submitLabel;
  final Color backgroundColor;
  final Function onSubmit;

  const NoPopContainer({
    @required this.children,
    Key key,
    this.submitLabel,
    this.backgroundColor,
    this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () => Future(() => false),
      child: Container(
        color:
            backgroundColor != null ? backgroundColor : theme.backgroundColor,
        child: SafeArea(
          child: Column(children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: AppCard(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 50,
                        horizontal: 40.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: this.children,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (this.onSubmit != null)
              SubmitButton(
                label: this.submitLabel,
                onPressed: this.onSubmit,
              )
          ]),
        ),
      ),
    );
  }
}
