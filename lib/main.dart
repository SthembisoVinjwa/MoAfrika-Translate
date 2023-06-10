import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:moafrika_translate/provider/provider.dart';
import 'package:provider/provider.dart';
import 'home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainProvider>(
      create: (context) => MainProvider(),
      child: Consumer<MainProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MoAfrika-Translate',
            theme: ThemeData(
              fontFamily: '',
              brightness: provider.isDarkMode ? Brightness.dark : Brightness.light,
              primarySwatch: Colors.green,
              primaryColor: Colors.green,
              accentColor: Colors.green,
              canvasColor: provider.isDarkMode ? const Color(0xFF303030) : Colors.green,
            ),
            home: const Home(),
          );
        },
      ),
    );
  }
}
