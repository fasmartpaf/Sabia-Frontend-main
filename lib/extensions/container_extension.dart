import 'package:flutter/material.dart';

extension ContainerExtension on Container {
  Widget rounded({double radius = 8}) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: this,
      );
}
