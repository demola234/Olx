import 'package:ecommerce/core/constants/colors.dart';
import 'package:flutter/material.dart';
import '../../../authentication/presentation/view/setprofile/set_location.dart';

class SaveProduct extends StatefulWidget {
  const SaveProduct({Key? key}) : super(key: key);

  @override
  State<SaveProduct> createState() => _SaveProductState();
}

class _SaveProductState extends State<SaveProduct> {
  TabController? _controller;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Color(0xFF8D8ECEA))),
                  child: TabBar(
                    indicator: BoxDecoration(
                        color: OlxColor.olxPrimary,
                        borderRadius: BorderRadius.circular(10.0)),
                    labelColor: Colors.white,
                    unselectedLabelColor: OlxColor.olxPrimary,
                    tabs: const [
                      Tab(
                        text: 'Bookmarked',
                      ),
                      Tab(
                        text: 'My Products',
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(
                  child: TabBarView(
                children: [
                  Center(
                    child: Text("Bookmarked"),
                  ),
                  Center(
                    child: Text("My Products"),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
