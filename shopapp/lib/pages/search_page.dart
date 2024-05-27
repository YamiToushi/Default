import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/products.dart';
import '../provider/shop_provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopProvider>(builder: (context, shopProvider, child) {
      return Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'Search by name or category',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {
                  shopProvider.updateSearchQuery(value);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: shopProvider.filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = shopProvider.filteredProducts[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text(product.category),
                    trailing: Text('\$${product.cost}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Products(
                            item: product,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
