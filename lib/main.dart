import 'package:corporate_manager/autherisation/LoginPage/MainDirector.dart';
import 'package:corporate_manager/providors/pageprovidor.dart';
import 'package:corporate_manager/providors/taskprovider.dart';
import 'package:corporate_manager/providors/taskstateprovider.dart';
import 'package:corporate_manager/providors/userprovider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => PageProvider()),
      ChangeNotifierProvider(create: (_) => TaskProvider()),
      ChangeNotifierProvider(
      create: (context) => TaskState(),),

    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Corporate Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: HexColor("fff8f5")),
        useMaterial3: true,
      ),
      home: const MainDirector(),
    );
  }
}
