import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/browse_page.dart';
import 'provider/shop_provider.dart';
import 'pages/shop_page.dart';
import 'pages/search_page.dart';
import 'utils/color.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<Widget> _pages = <Widget>[
    BrowsePage(),
    SearchPage(),
    ShopPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopProvider>(
      builder: (context, shopProvider, child) {
        return Scaffold(
          appBar: AppBar(),
          drawer: const Drawer(
            child: Column(
              children: [
                DrawerHeader(child: Icon(Icons.shopping_cart_rounded))
              ],
            ),
          ),
          body: _pages[shopProvider.selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: shopProvider.selectedIndex,
            onTap: (index) {
              shopProvider.updateSelectedIndex(index);
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_cart,
                ),
                label: 'Cart',
              ),
            ],
            selectedItemColor: RgbColors().primary,
            unselectedItemColor: Colors.black,
          ),
        );
      },
    );
  }
}
