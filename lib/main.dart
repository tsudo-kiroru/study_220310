import 'dart:js';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_sample/provider/count_store.dart';
import './page/my_home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Count1Store(value: 10)),
        ChangeNotifierProvider(create: (context) => Count2Store()),
        ChangeNotifierProvider(create: (context) => Count3Store()),
        // ChangeNotifierProxyProvider<Count1Store, Count2Store>(
        //   create: (context) => Count2Store(),
        //   update: (context, count1, count2) => count2!..update(count1),
        // ),
        // ChangeNotifierProxyProvider2<Count1Store, Count2Store, Count3Store>(
        //   create: (context) => Count3Store(),
        //   update: (context, count1, count2, count3) => count3!..update(count1, count2),
        // ),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
