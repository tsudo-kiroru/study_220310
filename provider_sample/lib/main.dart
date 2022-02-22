import 'dart:js';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_sample/provider/count_store.dart';
import './page/my_home_page.dart';
import 'package:provider_sample/provider/profile_change_notifier.dart';
import 'package:provider_sample/provider/post_change_notifier.dart';
import 'package:provider_sample/provider/auth_change_notifier.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileChangeNotifier()),
        ChangeNotifierProvider(create: (context) => PostChangeNotifier()),
        ChangeNotifierProvider(create: (context) => AuthChangeNotifier()),
        ChangeNotifierProxyProvider<AuthChangeNotifier, PostChangeNotifier>(
          create: (context) => PostChangeNotifier(),
          update: (context, auth, post) => post!..updateVisibility(auth),
        ),
        ChangeNotifierProxyProvider2<AuthChangeNotifier, PostChangeNotifier, ProfileChangeNotifier>(
          create: (context) => ProfileChangeNotifier(),
          update: (context, auth, post, profile) => profile!..update(auth, post),
        ),
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
