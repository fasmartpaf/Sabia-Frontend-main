import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../../../../components/icon/app_icon.dart';
import '../../../../stores/auth_store.dart';
import "../../../../utils/validate_field_util.dart";

part 'login_form.g.dart';

class LoginForm = LoginFormBase with _$LoginForm;

enum LoginFormType { login, validateCode, register }

abstract class LoginFormBase with Store {
  final AuthStore _authStore;

  LoginFormBase(this._authStore) {
    reaction(
        (_) => [
              _authStore.smsAuthStatus,
              _authStore.authStatus,
            ], (_) {
      final smsAuthStatus = _authStore.smsAuthStatus;
      if (smsAuthStatus == SmsAuthStatus.waitingCode) {
        this.setIsWaitingForm(false);
        this.setValidateCodeView();
      } else if (smsAuthStatus == SmsAuthStatus.error) {
        this.setIsWaitingForm(false);
        _authStore.setSmsAuthStatus(SmsAuthStatus.initial);
      } else if (_authStore.authStatus == AuthStatus.missingName) {
        this.setIsWaitingForm(false);
        this.setRegisterView();
      }
    });
  }

  @observable
  String name = "";
  @observable
  String phone = "";
  @observable
  String code = "";

  @observable
  LoginFormType view = LoginFormType.login;

  @observable
  bool isWaitingForm = false;
  @observable
  bool isInvalidCode = false;
  @observable
  bool formWasSubmit = false;

  @action
  setName(String newValue) => this.name = newValue;
  @action
  setPhone(String newValue) => this.phone = newValue;
  @action
  setCode(String newValue) => this.code = newValue;

  @action
  setIsWaitingForm(bool newValue) => this.isWaitingForm = newValue;
  @action
  setIsInvalidCode(bool newValue) => this.isInvalidCode = newValue;
  @action
  setFormWasSubmit(bool newValue) => this.formWasSubmit = newValue;

  @action
  _setView(LoginFormType newValue) {
    this.view = newValue;
    this.formWasSubmit = false;
  }

  @computed
  String get purePhoneNumber {
    this.phone.replaceAll(RegExp(r"[^0-9]"), "");
    return '+${this.phone}';
  }

  @computed
  bool get isValidName {
    final split = this.name.trim().split(" ");
    return split.length > 1 && split.every((str) => str.isNotEmpty);
  }

  @computed
  bool get isValidPhone => isPhoneValid(this.purePhoneNumber);
  @computed
  bool get isValidCode => this.code.length == 6;

  @computed
  bool get isLoginView => this.view == LoginFormType.login;
  @computed
  bool get isValidateCodeView => this.view == LoginFormType.validateCode;
  @computed
  bool get isRegisterView => this.view == LoginFormType.register;

  @computed
  String get validatePhoneMessage =>
      this.formWasSubmit ? validatePhone(this.phone) : null;
  @computed
  String get validateNameMessage => this.formWasSubmit
      ? isValidName
          ? null
          : "Por favor insira seu nome completo."
      : null;
  @computed
  String get validateCodeMessage => this.formWasSubmit
      ? isValidCode
          ? null
          : "Informe o código com 6 dígitos."
      : null;

  @computed
  String get submitButtonLabel {
    if (this.isWaitingForm) return "aguarde...";
    switch (this.view) {
      case LoginFormType.login:
        return "Entrar";
      case LoginFormType.validateCode:
        return "Validar";
      case LoginFormType.register:
      default:
        return "Finalizar cadastro";
    }
  }

  @computed
  IconData get submitButtonIcon {
    switch (this.view) {
      case LoginFormType.login:
        return PhoneIcon;
      case LoginFormType.validateCode:
        return SMSIcon;
      case LoginFormType.register:
      default:
        return CheckIcon;
    }
  }

  @computed
  bool get shouldDisplayBackButton {
    if (this.isWaitingForm) return false;
    return this._authStore.smsAuthStatus == SmsAuthStatus.waitingCode;
  }

  void setLoginView() {
    _setView(LoginFormType.login);
    this.setCode("");
    this._authStore.setSmsAuthStatus(SmsAuthStatus.initial);
  }

  void setValidateCodeView() => _setView(LoginFormType.validateCode);
  void setRegisterView() => _setView(LoginFormType.register);

  void submit() async {
    this.setFormWasSubmit(true);

    if (isLoginView && isValidPhone) {
      this.setIsWaitingForm(true);
      await _authStore.submitLogin(phone: this.purePhoneNumber);
    } else if (isValidateCodeView && isValidCode) {
      this.setIsWaitingForm(true);
      final didSuccess = await _authStore.loginWithCode(this.code);
      if (!didSuccess) {
        this.setIsWaitingForm(false);
      }
    } else if (isRegisterView && isValidName) {
      this.setIsWaitingForm(true);
      await _authStore.updateProfile(name: this.name);
    }
  }
}
