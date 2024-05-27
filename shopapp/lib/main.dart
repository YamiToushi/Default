import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'pages/search_page.dart';
import 'pages/shop_page.dart';
import 'pages/welcome.dart';
import 'provider/shop_provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ShopProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Welcome(),
      routes: {
        '/welcome':(context)=>const Welcome(),
        '/home':(context)=>const HomePage(),
        '/shop':(context)=>const ShopPage(),
        '/search':(context)=>const SearchPage(),
      },
    );
  }
}
