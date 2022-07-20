// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_form_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProfileFormStore on ProfileFormStoreBase, Store {
  Computed<bool> _$isValidNameComputed;

  @override
  bool get isValidName =>
      (_$isValidNameComputed ??= Computed<bool>(() => super.isValidName,
              name: 'ProfileFormStoreBase.isValidName'))
          .value;
  Computed<bool> _$isValidEmailComputed;

  @override
  bool get isValidEmail =>
      (_$isValidEmailComputed ??= Computed<bool>(() => super.isValidEmail,
              name: 'ProfileFormStoreBase.isValidEmail'))
          .value;
  Computed<String> _$validateNameMessageComputed;

  @override
  String get validateNameMessage => (_$validateNameMessageComputed ??=
          Computed<String>(() => super.validateNameMessage,
              name: 'ProfileFormStoreBase.validateNameMessage'))
      .value;
  Computed<String> _$validateEmailMessageComputed;

  @override
  String get validateEmailMessage => (_$validateEmailMessageComputed ??=
          Computed<String>(() => super.validateEmailMessage,
              name: 'ProfileFormStoreBase.validateEmailMessage'))
      .value;

  final _$nameAtom = Atom(name: 'ProfileFormStoreBase.name');

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

  final _$emailAtom = Atom(name: 'ProfileFormStoreBase.email');

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  final _$phoneAtom = Atom(name: 'ProfileFormStoreBase.phone');

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

  final _$locationAtom = Atom(name: 'ProfileFormStoreBase.location');

  @override
  String get location {
    _$locationAtom.reportRead();
    return super.location;
  }

  @override
  set location(String value) {
    _$locationAtom.reportWrite(value, super.location, () {
      super.location = value;
    });
  }

  final _$isPublicProfileAtom =
      Atom(name: 'ProfileFormStoreBase.isPublicProfile');

  @override
  bool get isPublicProfile {
    _$isPublicProfileAtom.reportRead();
    return super.isPublicProfile;
  }

  @override
  set isPublicProfile(bool value) {
    _$isPublicProfileAtom.reportWrite(value, super.isPublicProfile, () {
      super.isPublicProfile = value;
    });
  }

  final _$isWaitingFormAtom = Atom(name: 'ProfileFormStoreBase.isWaitingForm');

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

  final _$formWasSubmitAtom = Atom(name: 'ProfileFormStoreBase.formWasSubmit');

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

  final _$ProfileFormStoreBaseActionController =
      ActionController(name: 'ProfileFormStoreBase');

  @override
  dynamic setName(String newValue) {
    final _$actionInfo = _$ProfileFormStoreBaseActionController.startAction(
        name: 'ProfileFormStoreBase.setName');
    try {
      return super.setName(newValue);
    } finally {
      _$ProfileFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setEmail(String newValue) {
    final _$actionInfo = _$ProfileFormStoreBaseActionController.startAction(
        name: 'ProfileFormStoreBase.setEmail');
    try {
      return super.setEmail(newValue);
    } finally {
      _$ProfileFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPhone(String newValue) {
    final _$actionInfo = _$ProfileFormStoreBaseActionController.startAction(
        name: 'ProfileFormStoreBase.setPhone');
    try {
      return super.setPhone(newValue);
    } finally {
      _$ProfileFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setLocation(String newValue) {
    final _$actionInfo = _$ProfileFormStoreBaseActionController.startAction(
        name: 'ProfileFormStoreBase.setLocation');
    try {
      return super.setLocation(newValue);
    } finally {
      _$ProfileFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsPublicProfile(bool newValue) {
    final _$actionInfo = _$ProfileFormStoreBaseActionController.startAction(
        name: 'ProfileFormStoreBase.setIsPublicProfile');
    try {
      return super.setIsPublicProfile(newValue);
    } finally {
      _$ProfileFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsWaitingForm(bool newValue) {
    final _$actionInfo = _$ProfileFormStoreBaseActionController.startAction(
        name: 'ProfileFormStoreBase.setIsWaitingForm');
    try {
      return super.setIsWaitingForm(newValue);
    } finally {
      _$ProfileFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFormWasSubmit(bool newValue) {
    final _$actionInfo = _$ProfileFormStoreBaseActionController.startAction(
        name: 'ProfileFormStoreBase.setFormWasSubmit');
    try {
      return super.setFormWasSubmit(newValue);
    } finally {
      _$ProfileFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name},
email: ${email},
phone: ${phone},
location: ${location},
isPublicProfile: ${isPublicProfile},
isWaitingForm: ${isWaitingForm},
formWasSubmit: ${formWasSubmit},
isValidName: ${isValidName},
isValidEmail: ${isValidEmail},
validateNameMessage: ${validateNameMessage},
validateEmailMessage: ${validateEmailMessage}
    ''';
  }
}
