import 'package:flutter/material.dart';

mixin BaseBottomSheetMixin {
  Widget build(BuildContext context);

  Future? show(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => build(context),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        )));
  }
}
