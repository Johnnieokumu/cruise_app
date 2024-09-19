import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cruise_app/screens/driver/car_registartion.dart';
import 'package:cruise_app/screens/driver/login.dart';
import 'package:cruise_app/screens/driver/car_registartion.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final emailController = TextEditingController();
  final drivernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool passwordObscure = true;
  bool confirmPasswordObscure = true;
  bool _isLoading = false;

  void navigateToCarRegistration() {
    if (formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: Color.fromARGB(255, 136, 112, 76),
          ),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CarRegistration(
            email: emailController.text,
            drivername: drivernameController.text,
            password: passwordController.text,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    drivernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                      "Sign up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Create your account",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (value) => value != null && value.isNotEmpty ? null : "Please enter a username",
                      controller: drivernameController,
                      decoration: InputDecoration(
                        hintText: "Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: const Color.fromARGB(255, 126, 60, 36).withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: const Color.fromARGB(255, 126, 60, 36).withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) => value != null && value.isNotEmpty ? null : "Please enter a password",
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: const Color.fromARGB(255, 126, 60, 36).withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              passwordObscure = !passwordObscure;
                            });
                          },
                          icon: Icon(passwordObscure ? Icons.visibility_off : Icons.visibility),
                        ),
                      ),
                      obscureText: passwordObscure,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) => value != null && value.isNotEmpty ? null : "Please confirm your password",
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: const Color.fromARGB(255, 126, 60, 36).withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              confirmPasswordObscure = !confirmPasswordObscure;
                            });
                          },
                          icon: Icon(confirmPasswordObscure ? Icons.visibility_off : Icons.visibility),
                        ),
                      ),
                      obscureText: confirmPasswordObscure,
                    ),
                  ],
                ),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                        padding: const EdgeInsets.only(top: 3, left: 3),
                        child: ElevatedButton(
                          onPressed: navigateToCarRegistration,
                          child: const Text(
                            "Next",
                            style: TextStyle(fontSize: 20),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color.fromARGB(255, 126, 60, 36),
                          ),
                        ),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => const DriverLogin()),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Color.fromARGB(255, 126, 60, 36)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
