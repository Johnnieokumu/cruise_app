import 'package:flutter/material.dart';
// import 'package:cruise_app/screens/passenger/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'package:cruise_app/screens/passenger/homepage.dart';
import 'package:cruise_app/screens/options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CruiseApp());
}
  


class CruiseApp extends StatelessWidget {
  const CruiseApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cruise App',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const Options(),
    );
  }
}




