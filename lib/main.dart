import 'package:flutter/material.dart';
import 'package:forum_app/routes/login.dart';
import 'package:forum_app/routes/member_profile.dart';
import 'package:forum_app/routes/user.dart';
import 'package:forum_app/state/comment_model.dart';
import 'package:forum_app/state/user_model.dart';
import 'home_page.dart';
import 'package:provider/provider.dart';
import 'package:forum_app/state/post_model.dart';
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
        ChangeNotifierProvider(create: (_) => CommentsModel()),
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
        home: ChangeNotifierProvider(
            create: (_) => UserModel(),
            child: MyHomePage(title: 'Jenna\'s Forum')),
        routes: {
          '/login': (context) => ChangeNotifierProvider(
              create: (_) => UserModel(), child: LoginPage()),
          '/user': (context) => ChangeNotifierProvider(
              create: (_) => UserModel(), child: UserProfilePage()),
          '/member_profile': (context) {
            final routeArgs = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>;
            return MemberProfile(userId: routeArgs['userId']);
          },
        },
      ),
    );
  }
}
