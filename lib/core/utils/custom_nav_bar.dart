import 'package:ecommerce/core/constants/colors.dart';
import 'package:ecommerce/core/constants/image_assets.dart';
import 'package:ecommerce/features/add_product/presentation/view/add_product.dart';
import 'package:ecommerce/features/profile/presentation/view/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../features/chat/presentation/view/message.dart';
import '../../features/save_product/presentation/view/save_product.dart';
import '../../features/shop/presentation/view/home.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late PageController pageController;
  int _page = 0;

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          children: const [
            Home(),
            Message(),
            AddProduct(),
            SaveProduct(),
            Profile(),
          ],
          onPageChanged: onPageChanged,
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(ImagesAsset.home,
                  height: 20,
                  width: 20,
                  allowDrawingOutsideViewBox: true,
                  color: Colors.grey),
              label: "Shop",
              activeIcon: SvgPicture.asset(ImagesAsset.home,
                  height: 20,
                  width: 20,
                  allowDrawingOutsideViewBox: true,
                  color: OlxColor.olxPrimary),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(ImagesAsset.chat,
                  height: 20, width: 20, allowDrawingOutsideViewBox: true),
              label: "Message",
              activeIcon: SvgPicture.asset(ImagesAsset.chat,
                  height: 20,
                  width: 20,
                  allowDrawingOutsideViewBox: true,
                  color: OlxColor.olxPrimary),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(ImagesAsset.add,
                  height: 38, width: 38, allowDrawingOutsideViewBox: true),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(ImagesAsset.bookmark,
                  height: 20, width: 20, allowDrawingOutsideViewBox: true),
              label: "Bookmark",
              activeIcon: SvgPicture.asset(ImagesAsset.bookmark,
                  height: 20,
                  width: 20,
                  allowDrawingOutsideViewBox: true,
                  color: OlxColor.olxPrimary),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(ImagesAsset.profile,
                  height: 20, width: 20, allowDrawingOutsideViewBox: true),
              label: "Profile",
              activeIcon: SvgPicture.asset(ImagesAsset.profile,
                  height: 20,
                  width: 20,
                  allowDrawingOutsideViewBox: true,
                  color: OlxColor.olxPrimary),
            )
          ],
          selectedItemColor: OlxColor.olxPrimary,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          onTap: navigationTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _page,
          iconSize: 20,
        ));
  }
}
