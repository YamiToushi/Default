import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/utils/color.dart';
import '../provider/shop_provider.dart';
import '../db/shop_model.dart';

class Products extends StatelessWidget {
  final Product item;

  const Products({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopProvider>(
      builder: (context, shopProvider, child) => Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_outlined),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        item.category + ':',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        item.name,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 60),
                      Text('Cost:'),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '\$${item.cost}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    child: Image.asset(
                      item.imagePath,
                      width: 200,
                      height: 200,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 100,
              ),
              Text(
                item.description,
                style: const TextStyle(fontSize: 16),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(RgbColors().primary)),
                  onPressed: () {
                    shopProvider.addToCart(shopProvider.shopdb.indexOf(item));
                  },
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
