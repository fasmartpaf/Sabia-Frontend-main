import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import "package:build_context/build_context.dart";
import 'package:sabia_app/services/payments_with_stores_service.dart';

import '../../../../components/button/button.dart';
import '../../../../components/container/rounded_top_container.dart';
import '../../../../components/form/input_text.dart';
import '../../../../components/loading/loading_view.dart';
import '../../../../stores/auth_store.dart';
import './login_form.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusScopeNode _focusNode = FocusScopeNode();
  final phoneController =
      MaskedTextController(mask: '+00 (00) 00000-0000', text: "+55");
  String paymentsStatus = "";
  final InAppPurchaseClass _inAppPurchaseClass = InAppPurchaseClass();

  LoginForm _loginForm;

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_phoneChangedListener);

    _loginForm = LoginForm(
      Modular.get<AuthStore>(),
    );
  }

  Future<void> checkPaymaents() async {
    if (_loginForm.isValidateCodeView) {
      try {
        await _inAppPurchaseClass.initInAppPurchase();
        await _inAppPurchaseClass.checkStatus();
        if (_inAppPurchaseClass.userPremium.value) {
          return _loginForm.submit();
        } else {
          await _inAppPurchaseClass.triggerOpenPurshase();
          await _inAppPurchaseClass.checkStatus();
          if (_inAppPurchaseClass.userPremium.value) {
            return _loginForm.submit();
          }
          return;
        }
      } catch (e) {
        log(e.toString());
      }
    } else {
      _loginForm.submit();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    phoneController.removeListener(_phoneChangedListener);
    super.dispose();
  }

  _phoneChangedListener() {
    _loginForm.setPhone(phoneController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _renderBody(),
    );
  }

  Widget _validateCodeInputs() {
    final width = context.mediaQuerySize.width;
    final bool isSmallScreen = width < 360;
    final bool isBigScreen = width > 400;
    final double codeBoxPadding = isBigScreen
        ? 6
        : isSmallScreen
            ? 2
            : 4;
    final double size = isBigScreen
        ? 52
        : isSmallScreen
            ? 44
            : 48;
    return PinCodeTextField(
      maxLength: 6,
      pinBoxHeight: size,
      pinBoxWidth: size,
      wrapAlignment: WrapAlignment.center,
      pinBoxRadius: 6,
      autofocus: true,
      pinBoxBorderWidth: 0.5,
      pinTextStyle: TextStyle(fontSize: 28),
      hasError: _loginForm.isInvalidCode,
      onTextChanged: _loginForm.setCode,
      pinBoxOuterPadding: EdgeInsets.all(
        codeBoxPadding,
      ),
    );
  }

  Widget _renderBody() {
    final _authStore = Modular.get<AuthStore>();
    return Observer(
      builder: (_) {
        return Column(children: [
          Expanded(
            flex: 1,
            child: Container(
              color: context.backgroundColor,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Sabiá",
                    style: context.textTheme.headline6.copyWith(
                      fontSize: 64,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: RoundedTopContainer(
              backgroundColor: context.backgroundColor,
              child: _authStore.isFetching ||
                      _authStore.authStatus == AuthStatus.authenticated
                  ? LoadingView()
                  : _renderForm(),
            ),
          ),
        ]);
      },
    );
  }

  Widget _renderForm() {
    return FocusScope(
      node: _focusNode,
      child: ListView(
        padding: const EdgeInsets.only(top: 100),
        children: [
          if (_loginForm.isLoginView)
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8),
                child: Text(
                  "Entre com o número do seu celular",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: InputText(
                controller: phoneController,
                withListTile: false,
                errorText: _loginForm.validatePhoneMessage,
                hintText: "+XX (XX) XXXXX-XXXX",
                textInputType: TextInputType.phone,
              ),
            ),
          if (_loginForm.isValidateCodeView)
            ListTile(
              title: Text(
                "Digite o código que te enviamos por SMS",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Column(
                  children: <Widget>[
                    _validateCodeInputs(),
                    if (_loginForm.validateCodeMessage != null)
                      Text(
                        _loginForm.validateCodeMessage,
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          if (_loginForm.isRegisterView)
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8),
                child: Text(
                  "Nome completo",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: InputText(
                withListTile: false,
                errorText: _loginForm.validateNameMessage,
                onChanged: _loginForm.setName,
                textCapitalization: TextCapitalization.words,
                autofocus: true,
                autoCorrect: false,
              ),
            ),
          SizedBox(height: 40),
          ListTile(
            title: Button(
              padding: EdgeInsets.symmetric(vertical: 20),
              fullWidth: true,
              label: _loginForm.submitButtonLabel,
              isDisabled: _loginForm.isWaitingForm,
              onPressed: checkPaymaents,
            ),
          ),
          if (_loginForm.shouldDisplayBackButton) SizedBox(height: 10),
          if (_loginForm.shouldDisplayBackButton)
            ListTile(
              title: Button(
                fullWidth: true,
                flat: true,
                small: true,
                label: "Alterar número",
                onPressed: _loginForm.setLoginView,
              ),
            ),
        ],
      ),
    );
  }
}
