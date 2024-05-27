import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/db/task_model.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'home.dart';

import 'utils/colors.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());

  runApp(const Tasked());
}

class Tasked extends StatelessWidget {
  const Tasked({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'iA Writer Quattro',
          scaffoldBackgroundColor: RGBColors().bg,
          appBarTheme: AppBarTheme(backgroundColor: RGBColors().bg),
        ),
        home: const Home(),
      ),
    );
  }
}
