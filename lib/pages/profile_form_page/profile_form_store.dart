import 'package:mobx/mobx.dart';
import 'package:sabia_app/routes/app_routes.dart';
import 'package:sabia_app/utils/validate_field_util.dart';
import '../../stores/auth_store.dart';
import '../../stores/routing_store.dart';

part 'profile_form_store.g.dart';

class ProfileFormStore = ProfileFormStoreBase with _$ProfileFormStore;

abstract class ProfileFormStoreBase with Store {
  final AuthStore _authStore;
  final RoutingStore _routingStore;

  ProfileFormStoreBase(
    this._authStore,
    this._routingStore,
  ) {
    final currentUser = _authStore.currentUser;
    if (currentUser != null) {
      this.setName(currentUser.name);
      this.setEmail(currentUser.email);
      this.setPhone(currentUser.phone);
      this.setLocation(currentUser.location);
      this.setIsPublicProfile(currentUser.isPublicProfile);
    }
  }

  @observable
  String name = "";
  @observable
  String email = "";
  @observable
  String phone = "";
  @observable
  String location = "";

  @observable
  bool isPublicProfile = true;

  @observable
  bool isWaitingForm = false;
  @observable
  bool formWasSubmit = false;

  @action
  setName(String newValue) => this.name = newValue;
  @action
  setEmail(String newValue) => this.email = newValue;
  @action
  setPhone(String newValue) => this.phone = newValue;
  @action
  setLocation(String newValue) => this.location = newValue;
  @action
  setIsPublicProfile(bool newValue) => this.isPublicProfile = newValue;

  @action
  setIsWaitingForm(bool newValue) => this.isWaitingForm = newValue;
  @action
  setFormWasSubmit(bool newValue) => this.formWasSubmit = newValue;

  @computed
  bool get isValidName {
    final split = this.name.trim().split(" ");
    return split.length > 1 && split.every((str) => str.isNotEmpty);
  }

  @computed
  bool get isValidEmail => isEmailValid(this.email);

  @computed
  String get validateNameMessage => this.formWasSubmit
      ? isValidName
          ? null
          : "Por favor insira seu nome completo."
      : null;
  @computed
  String get validateEmailMessage =>
      this.formWasSubmit ? validateEmail(this.email) : null;

  void submit() async {
    this.setFormWasSubmit(true);

    if (isValidEmail && isValidName) {
      this.setIsWaitingForm(true);
      await this._authStore.updateProfile(
            name: this.name,
            email: this.email,
            location: this.location,
            isPublicProfile: this.isPublicProfile,
          );

      Future.delayed(
        Duration(seconds: 2),
        () => this._routingStore.moveToMainRoute(APP_ROUTE.HOME.path),
      );
    }
  }
}
