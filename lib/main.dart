import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_firebase/providers/auth.dart';
import 'package:to_do_list_firebase/providers/task_data.dart';
import 'package:to_do_list_firebase/screens/home_screen.dart';
import 'package:to_do_list_firebase/screens/login_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskData(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: MyAppMaterial(),
    );
  }
}

class MyAppMaterial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<bool> isAuth =
        Provider.of<AuthProvider>(context, listen: false).isAuth;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        unselectedWidgetColor: Colors.white,
      ),
      home: GetPage(isAuth),
      routes: {
        HomeScreen.id: (_) => HomeScreen(),
        LoginScreen.id: (_) => LoginScreen(),
      },
    );
  }
}

class GetPage extends StatelessWidget {
  Future<bool> isAuth;
  GetPage(this.isAuth);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: isAuth,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data == true) {
            return HomeScreen();
          } else if (snapshot.data == false) {
            return LoginScreen();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
