import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/firebase_options.dart';
import 'package:instagram_app/pages/login.dart';
import 'package:instagram_app/pages/mobile.dart';
import 'package:instagram_app/pages/responsive.dart';
import 'package:instagram_app/pages/web.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_app/provider/googleSignin.dart';
import 'package:instagram_app/provider/usersProvider.dart';
import 'package:instagram_app/shared/snackBar.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyAE8H1UdZo_JAXpVWVpAJC7QyFmGIG7UTg",
      authDomain: "instagram-68229.firebaseapp.com",
      projectId: "instagram-68229",
      storageBucket: "instagram-68229.appspot.com",
      messagingSenderId: "21100726058",
      appId: "1:21100726058:web:3a5d9f8fbc492b53570053",
    ));
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return userProvider();
        }),
        ChangeNotifierProvider(create: (context) {
          return GoogleSignInProvider();
        }),
      ],
      child: MaterialApp(
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else if (snapshot.hasError) {
              ShowSnackBar(context, "obs something went wrong ", 0xFF49B369);
              return const Text("");
            } else if (snapshot.hasData) {
              return const responsive(
                myMobileScreen: mobileScreen(),
                myWebScreen: webPage(),
              );
            } else {
              return const login();
            }
          },
        ),
      ),
    );
  }
}
