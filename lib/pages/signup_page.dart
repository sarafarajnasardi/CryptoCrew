import 'package:flutter/material.dart';
import 'home_page.dart'; // Ensure the correct path to HomePage is imported
import 'package:firebase_auth/firebase_auth.dart';

import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController(); // Renamed for clarity
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;

  void showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Text(
                  'CryptoCrew',
                  style: TextStyle(
                    color: const Color(0xFF10A37F),
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Create an Account",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  hint: "Enter your email",
                  label: "Email",
                  controller: emailController, // Updated to use emailController
                  isPassword: false,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  hint: "Enter your password",
                  label: "Password",
                  controller: passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  hint: "Confirm your password",
                  label: "Confirm Password",
                  controller: confirmPasswordController,
                  isPassword: true,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: isLoading ? null : _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10A37F),
                    minimumSize: const Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Navigate back to LoginPage
                  },
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(
                      color: Color(0xFF10A37F),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
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

  Widget _buildTextField({
    required String hint,
    required String label,
    required TextEditingController controller,
    required bool isPassword,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        filled: true,
        fillColor: Colors.blueGrey[700],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: Colors.white54),
        labelStyle: const TextStyle(color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Future<void> _signup() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    String email = emailController.text.trim(); // Get email
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // Validate input
    if (email.isEmpty) {
      showSnackBar("Please enter your email");
    } else if (password.isEmpty) {
      showSnackBar("Please enter your password");
    } else if (confirmPassword.isEmpty) {
      showSnackBar("Please confirm your password");
    } else if (password != confirmPassword) {
      showSnackBar("Passwords do not match");
    } else {
      try {
        // Create new account
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        // Simulate signup process
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } catch (e) {
        showSnackBar("Error creating account: ${e.toString()}");
      }
    }

    setState(() {
      isLoading = false; // Hide loading indicator
    });
  }
}