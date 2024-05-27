import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/categories.dart';
import '../components/products.dart';

import '../provider/shop_provider.dart';
import '../utils/color.dart';

class BrowsePage extends StatelessWidget {
  const BrowsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopProvider>(
      builder: (context, shopProvider, child) {
        final categories =
            shopProvider.shopdb.map((item) => item.category).toSet().toList();

        final categoryItems = categories.map((category) {
          return shopProvider.shopdb
              .firstWhere((item) => item.category == category);
        }).toList();

        return ListView(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Browse by Categories:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryItems.length,
                    itemBuilder: (context, index) {
                      final item = categoryItems[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryPage(
                                category: item.category,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 160,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: RgbColors().secondary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Image.asset(
                                  item.imagePath,
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  item.category,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Divider(color: Colors.grey[200]),
                const SizedBox(height: 40),
                const Text(
                  'Browse Products:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 400,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: shopProvider.shopdb.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 3 / 2,
                    ),
                    itemBuilder: (context, index) {
                      final item = shopProvider.shopdb[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Products(
                                item: item,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: RgbColors().secondary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            
                            title: Text(item.name),
                            trailing: Text('\$${item.cost}'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
