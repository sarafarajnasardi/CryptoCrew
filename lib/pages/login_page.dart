import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'home_page.dart'; // Ensure the correct path to HomePage is imported
import 'signup_page.dart'; // Import the SignupPage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController(); // Renamed to emailController
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false; // Track loading state
  final FocusNode emailFocusNode = FocusNode(); // Updated focus node name
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Focus on the email field when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(emailFocusNode);
    });
  }

  void showSnackBar(BuildContext context, String message) {
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
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    'CryptoCrew',
                    style: TextStyle(
                      color: const Color(0xFF10A37F),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: const Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeInLeft(
                  duration: const Duration(milliseconds: 1000),
                  child: _buildTextField(
                    hint: "Enter your email",
                    label: "Email",
                    isPassword: false,
                    focusNode: emailFocusNode,
                    controller: emailController,
                  ),
                ),
                const SizedBox(height: 10),
                FadeInRight(
                  duration: const Duration(milliseconds: 1000),
                  child: _buildTextField(
                    hint: "Enter your password",
                    label: "Password",
                    controller: passwordController,
                    isPassword: true,
                    focusNode: passwordFocusNode,
                  ),
                ),
                const SizedBox(height: 32),
                BounceInUp(
                  duration: const Duration(milliseconds: 1400),
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _login,
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
                      "Login",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                FadeInUp(
                  duration: const Duration(milliseconds: 2000),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(
                        color: Color(0xFF10A37F),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 2000),
                  child: TextButton(
                    onPressed: () {
                      // Handle "Forgot Password" action
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Color(0xFF10A37F),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
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
    required bool isPassword,
    required FocusNode? focusNode,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      focusNode: focusNode,
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

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });
    String email = emailController.text.trim(); // Get email
    String password = passwordController.text.trim();

    if (email.isEmpty) {
      showSnackBar(context, "Please enter your email");
    } else if (password.isEmpty) {
      showSnackBar(context, "Please enter your password");
    } else {
      try {
        // Attempt to sign in the user
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

        // Simulate login process
        await Future.delayed(const Duration(seconds: 1));
        Navigator.popUntil(context, (route)=>route.isFirst);
        // Navigate to HomePage after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  HomePage()),
        );
      } catch (e) {
        // Show error message in SnackBar
        showSnackBar(context, "Error logging in: ${e.toString()}");
      }
    }

    setState(() {
      isLoading = false;
    });
  }
}
