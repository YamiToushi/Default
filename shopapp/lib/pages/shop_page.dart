import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/shop_model.dart';
import '../provider/shop_provider.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopProvider>(
      builder: (context, shopProvider, child) {
        final cart = shopProvider.cartdb;

        
        final cartItems = <Product, int>{};
        for (var item in cart) {
          cartItems[item] = (cartItems[item] ?? 0) + 1;
        }

        return Scaffold(
          body: cartItems.isEmpty
              ? const Center(child: Text('Your cart is empty'))
              : ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems.keys.elementAt(index);
                    final quantity = cartItems[item]!;
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.description),
                      trailing: Text('$quantity x \$${item.cost}'),
                      onTap: () {
                        shopProvider
                            .removeFromCart(shopProvider.cartdb.indexOf(item));
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
