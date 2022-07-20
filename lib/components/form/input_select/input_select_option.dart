class InputSelectOption {
  final String label;
  final dynamic value;

  InputSelectOption({this.label, this.value});

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is InputSelectOption && o.label == label && o.value == value;
  }

  @override
  int get hashCode => label.hashCode ^ value.hashCode;

  @override
  String toString() => 'InputSelectOption(label: $label, value: $value)';
}
