import 'package:flutter/material.dart';

class BaseScrollableBottomSheet extends StatelessWidget {
  const BaseScrollableBottomSheet({required this.child, Key? key})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
              left: 24.0,
              right: 24.0,
              top: 16.0),
          child: child,
        ),
      ),
    );
  }
}
