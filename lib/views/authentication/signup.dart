// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gallery/views/home.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:gallery/providers/authProvider.dart';
import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Create Account",
                style: GoogleFonts.instrumentSans(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.70,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 30,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      Center(
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.sansation(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      Text(
                        "Email",
                        style: GoogleFonts.sansation(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),

                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "Enter email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email is required";
                          }
                          if (!value.contains("@")) {
                            return "Enter valid email";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 25),

                      Text(
                        "Password",
                        style: GoogleFonts.sansation(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),

                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Enter password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          if (value.length < 6) {
                            return "Minimum 6 characters";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 40),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: provider.isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    await provider.signup(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                    );

                                    if (provider.errorMessage == null) {
                                      Get.offAll(() => const HomeScreen());
                                    }
                                  }
                                },
                          child: provider.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Sign Up",
                                  style: GoogleFonts.instrumentSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextButton(
                        onPressed: () {
                          Get.offAll(() => const LoginScreen());
                        },
                        child: const Text(
                          "Already have an account? Login",
                          style: TextStyle(color: Colors.black, fontSize: 22),
                        ),
                      ),

                      if (provider.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Center(
                            child: Text(
                              provider.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}