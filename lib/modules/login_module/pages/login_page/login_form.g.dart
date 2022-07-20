// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_form.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginForm on LoginFormBase, Store {
  Computed<String> _$purePhoneNumberComputed;

  @override
  String get purePhoneNumber => (_$purePhoneNumberComputed ??= Computed<String>(
          () => super.purePhoneNumber,
          name: 'LoginFormBase.purePhoneNumber'))
      .value;
  Computed<bool> _$isValidNameComputed;

  @override
  bool get isValidName =>
      (_$isValidNameComputed ??= Computed<bool>(() => super.isValidName,
              name: 'LoginFormBase.isValidName'))
          .value;
  Computed<bool> _$isValidPhoneComputed;

  @override
  bool get isValidPhone =>
      (_$isValidPhoneComputed ??= Computed<bool>(() => super.isValidPhone,
              name: 'LoginFormBase.isValidPhone'))
          .value;
  Computed<bool> _$isValidCodeComputed;

  @override
  bool get isValidCode =>
      (_$isValidCodeComputed ??= Computed<bool>(() => super.isValidCode,
              name: 'LoginFormBase.isValidCode'))
          .value;
  Computed<bool> _$isLoginViewComputed;

  @override
  bool get isLoginView =>
      (_$isLoginViewComputed ??= Computed<bool>(() => super.isLoginView,
              name: 'LoginFormBase.isLoginView'))
          .value;
  Computed<bool> _$isValidateCodeViewComputed;

  @override
  bool get isValidateCodeView => (_$isValidateCodeViewComputed ??=
          Computed<bool>(() => super.isValidateCodeView,
              name: 'LoginFormBase.isValidateCodeView'))
      .value;
  Computed<bool> _$isRegisterViewComputed;

  @override
  bool get isRegisterView =>
      (_$isRegisterViewComputed ??= Computed<bool>(() => super.isRegisterView,
              name: 'LoginFormBase.isRegisterView'))
          .value;
  Computed<String> _$validatePhoneMessageComputed;

  @override
  String get validatePhoneMessage => (_$validatePhoneMessageComputed ??=
          Computed<String>(() => super.validatePhoneMessage,
              name: 'LoginFormBase.validatePhoneMessage'))
      .value;
  Computed<String> _$validateNameMessageComputed;

  @override
  String get validateNameMessage => (_$validateNameMessageComputed ??=
          Computed<String>(() => super.validateNameMessage,
              name: 'LoginFormBase.validateNameMessage'))
      .value;
  Computed<String> _$validateCodeMessageComputed;

  @override
  String get validateCodeMessage => (_$validateCodeMessageComputed ??=
          Computed<String>(() => super.validateCodeMessage,
              name: 'LoginFormBase.validateCodeMessage'))
      .value;
  Computed<String> _$submitButtonLabelComputed;

  @override
  String get submitButtonLabel => (_$submitButtonLabelComputed ??=
          Computed<String>(() => super.submitButtonLabel,
              name: 'LoginFormBase.submitButtonLabel'))
      .value;
  Computed<IconData> _$submitButtonIconComputed;

  @override
  IconData get submitButtonIcon => (_$submitButtonIconComputed ??=
          Computed<IconData>(() => super.submitButtonIcon,
              name: 'LoginFormBase.submitButtonIcon'))
      .value;
  Computed<bool> _$shouldDisplayBackButtonComputed;

  @override
  bool get shouldDisplayBackButton => (_$shouldDisplayBackButtonComputed ??=
          Computed<bool>(() => super.shouldDisplayBackButton,
              name: 'LoginFormBase.shouldDisplayBackButton'))
      .value;

  final _$nameAtom = Atom(name: 'LoginFormBase.name');

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  final _$phoneAtom = Atom(name: 'LoginFormBase.phone');

  @override
  String get phone {
    _$phoneAtom.reportRead();
    return super.phone;
  }

  @override
  set phone(String value) {
    _$phoneAtom.reportWrite(value, super.phone, () {
      super.phone = value;
    });
  }

  final _$codeAtom = Atom(name: 'LoginFormBase.code');

  @override
  String get code {
    _$codeAtom.reportRead();
    return super.code;
  }

  @override
  set code(String value) {
    _$codeAtom.reportWrite(value, super.code, () {
      super.code = value;
    });
  }

  final _$viewAtom = Atom(name: 'LoginFormBase.view');

  @override
  LoginFormType get view {
    _$viewAtom.reportRead();
    return super.view;
  }

  @override
  set view(LoginFormType value) {
    _$viewAtom.reportWrite(value, super.view, () {
      super.view = value;
    });
  }

  final _$isWaitingFormAtom = Atom(name: 'LoginFormBase.isWaitingForm');

  @override
  bool get isWaitingForm {
    _$isWaitingFormAtom.reportRead();
    return super.isWaitingForm;
  }

  @override
  set isWaitingForm(bool value) {
    _$isWaitingFormAtom.reportWrite(value, super.isWaitingForm, () {
      super.isWaitingForm = value;
    });
  }

  final _$isInvalidCodeAtom = Atom(name: 'LoginFormBase.isInvalidCode');

  @override
  bool get isInvalidCode {
    _$isInvalidCodeAtom.reportRead();
    return super.isInvalidCode;
  }

  @override
  set isInvalidCode(bool value) {
    _$isInvalidCodeAtom.reportWrite(value, super.isInvalidCode, () {
      super.isInvalidCode = value;
    });
  }

  final _$formWasSubmitAtom = Atom(name: 'LoginFormBase.formWasSubmit');

  @override
  bool get formWasSubmit {
    _$formWasSubmitAtom.reportRead();
    return super.formWasSubmit;
  }

  @override
  set formWasSubmit(bool value) {
    _$formWasSubmitAtom.reportWrite(value, super.formWasSubmit, () {
      super.formWasSubmit = value;
    });
  }

  final _$LoginFormBaseActionController =
      ActionController(name: 'LoginFormBase');

  @override
  dynamic setName(String newValue) {
    final _$actionInfo = _$LoginFormBaseActionController.startAction(
        name: 'LoginFormBase.setName');
    try {
      return super.setName(newValue);
    } finally {
      _$LoginFormBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPhone(String newValue) {
    final _$actionInfo = _$LoginFormBaseActionController.startAction(
        name: 'LoginFormBase.setPhone');
    try {
      return super.setPhone(newValue);
    } finally {
      _$LoginFormBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCode(String newValue) {
    final _$actionInfo = _$LoginFormBaseActionController.startAction(
        name: 'LoginFormBase.setCode');
    try {
      return super.setCode(newValue);
    } finally {
      _$LoginFormBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsWaitingForm(bool newValue) {
    final _$actionInfo = _$LoginFormBaseActionController.startAction(
        name: 'LoginFormBase.setIsWaitingForm');
    try {
      return super.setIsWaitingForm(newValue);
    } finally {
      _$LoginFormBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsInvalidCode(bool newValue) {
    final _$actionInfo = _$LoginFormBaseActionController.startAction(
        name: 'LoginFormBase.setIsInvalidCode');
    try {
      return super.setIsInvalidCode(newValue);
    } finally {
      _$LoginFormBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFormWasSubmit(bool newValue) {
    final _$actionInfo = _$LoginFormBaseActionController.startAction(
        name: 'LoginFormBase.setFormWasSubmit');
    try {
      return super.setFormWasSubmit(newValue);
    } finally {
      _$LoginFormBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic _setView(LoginFormType newValue) {
    final _$actionInfo = _$LoginFormBaseActionController.startAction(
        name: 'LoginFormBase._setView');
    try {
      return super._setView(newValue);
    } finally {
      _$LoginFormBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name},
phone: ${phone},
code: ${code},
view: ${view},
isWaitingForm: ${isWaitingForm},
isInvalidCode: ${isInvalidCode},
formWasSubmit: ${formWasSubmit},
purePhoneNumber: ${purePhoneNumber},
isValidName: ${isValidName},
isValidPhone: ${isValidPhone},
isValidCode: ${isValidCode},
isLoginView: ${isLoginView},
isValidateCodeView: ${isValidateCodeView},
isRegisterView: ${isRegisterView},
validatePhoneMessage: ${validatePhoneMessage},
validateNameMessage: ${validateNameMessage},
validateCodeMessage: ${validateCodeMessage},
submitButtonLabel: ${submitButtonLabel},
submitButtonIcon: ${submitButtonIcon},
shouldDisplayBackButton: ${shouldDisplayBackButton}
    ''';
  }
}
