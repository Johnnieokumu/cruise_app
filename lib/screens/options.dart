import 'package:flutter/material.dart';
// import 'package:cruise_app/screens/driver/car_registartion.dart';
// import 'package:cruise_app/screens/passenger/homepage.dart';
import 'package:cruise_app/screens/passenger/register.dart';
import 'package:cruise_app/screens/driver/signup.dart';

class Options extends StatelessWidget {
  const Options({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Driver's registration page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Signup()),
                  );
                },
                child: const Text('Driver'),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              height: 40,
              width: 120,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Passenger's registration page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Register()),
                  );
                },
                child: const Text('User'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Options(),
    );
  }
}
