import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:provider/provider.dart';
import 'package:forum_app/state/post.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostsModel()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'AU'),
          Locale('zh', 'CN'),
        ],
        locale: Locale('en', 'AU'),
        title: 'Forum',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Jenna\'s Forum'),
      ),
    );
  }
}
