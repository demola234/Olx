import 'package:flutter/material.dart';
import '../../../authentication/presentation/view/setprofile/set_location.dart';

class SaveProduct extends StatelessWidget {
  const SaveProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: CustomAppBar(
          title: "Save Product",
          back: false,
        ),
      ),
      body: Column(
        children: const [],
      ),
    );
  }
}
