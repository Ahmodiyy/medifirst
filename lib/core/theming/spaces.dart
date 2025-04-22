import 'package:flutter/material.dart';

class Spaces {}

extension PaddingHeight on num {
  SizedBox get pv => SizedBox(
        height: toDouble(),
      );
  SizedBox get ph => SizedBox(
        width: toDouble(),
      );
}

extension SidePadding on Widget {
  Padding sidePad(double p) => Padding(
        padding: EdgeInsets.symmetric(horizontal: p),
        child: this,
      );
  Padding topPad(double p) => Padding(
    padding: EdgeInsets.symmetric(vertical: p),
    child: this,
  );
}

extension AlignSide on Widget {
  Align alignLeft() => Align(
        alignment: Alignment.centerLeft,
        child: this,
      );
  Align alignRight() => Align(
        alignment: Alignment.centerRight,
        child: this,
      );
}
