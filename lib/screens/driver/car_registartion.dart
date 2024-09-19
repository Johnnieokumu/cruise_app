import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cruise_app/screens/driver/homepage.dart';
import 'package:cruise_app/screens/driver/signup.dart';

class CarRegistration extends StatefulWidget {
  final String email;
  final String drivername;
  final String password;

  const CarRegistration({
    required this.email,
    required this.drivername,
    required this.password,
    super.key,
  });

  @override
  State<CarRegistration> createState() => _CarRegistrationState();
}

class _CarRegistrationState extends State<CarRegistration> {
  final numberplateController = TextEditingController();
  final carmodelController = TextEditingController();
  final carmakeController = TextEditingController();
  final carcolorController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> registerCar() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential driverCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: widget.email,
          password: widget.password,
        );

        // Add user info to Firestore
        CollectionReference drivers = FirebaseFirestore.instance.collection('drivers');
        await drivers.doc(driverCredential.user!.uid).set({
          'email': widget.email,
          'drivername': widget.drivername,
          'carmake': carmakeController.text,
          'carmodel': carmodelController.text,
          'carcolor': carcolorController.text,
          'numberplate': numberplateController.text,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Welcome to Cruise App')),
          );

          // Navigate to the homepage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext context) => const Driverpage()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    numberplateController.dispose();
    carmodelController.dispose();
    carmakeController.dispose();
    carcolorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 60.0),
                    const Text(
                      "Car Registration",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Enter your car details",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (value) => value != null && value.isNotEmpty ? null : "Please enter the number plate",
                      controller: numberplateController,
                      decoration: InputDecoration(
                        hintText: "Number Plate",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: const Color.fromARGB(255, 126, 60, 36).withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.directions_car),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) => value != null && value.isNotEmpty ? null : "Please enter the car model",
                      controller: carmodelController,
                      decoration: InputDecoration(
                        hintText: "Car Model",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: const Color.fromARGB(255, 126, 60, 36).withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.model_training),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) => value != null && value.isNotEmpty ? null : "Please enter the car make",
                      controller: carmakeController,
                      decoration: InputDecoration(
                        hintText: "Car Make",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: const Color.fromARGB(255, 126, 60, 36).withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.local_car_wash),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) => value != null && value.isNotEmpty ? null : "Please enter the car color",
                      controller: carcolorController,
                      decoration: InputDecoration(
                        hintText: "Car Color",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: const Color.fromARGB(255, 126, 60, 36).withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.color_lens),
                      ),
                    ),
                  ],
                ),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                        padding: const EdgeInsets.only(top: 3, left: 3),
                        child: ElevatedButton(
                          onPressed: registerCar,
                          child: const Text(
                            "Register",
                            style: TextStyle(fontSize: 20),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color.fromARGB(255, 126, 60, 36),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
