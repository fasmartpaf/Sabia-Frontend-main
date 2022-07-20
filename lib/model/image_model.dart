import 'package:mobx/mobx.dart';
part 'image_model.g.dart';

class ImageModel = _ImageModelBase with _$ImageModel;

abstract class _ImageModelBase with Store {
  String id;
  String hash;

  @observable
  String url;

  _ImageModelBase({
    this.id,
    this.hash,
    this.url,
  });

  _ImageModelBase.fromMap(Map<dynamic, dynamic> map) {
    this.id = map['id'];
    this.hash = map['hash'];
    this.url = map['url'];
  }

  Map<dynamic, dynamic> toMap() => {
        "id": id,
        "hash": hash,
        "url": url,
      };

  @action
  setUrl(String newValue) => this.url = newValue;

  @computed
  bool get hasUrl => this.url != null && this.url.isNotEmpty;

  @computed
  bool get hasNoUrl => !this.hasUrl;
}
