import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF82AEFE),
                      Colors.white,
                    ],
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // LOGO
                    SizedBox(
                      width: 660,
                      child: Image.asset(
                        'assets/sharego_logo2.png',
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 22),

                    // WHITE CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // EMAIL
                          TextField(
                            controller: emailCtrl,
                            decoration: const InputDecoration(
                              labelText: "Email:",
                              border: OutlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // PASSWORD
                          TextField(
                            controller: passCtrl,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Password:",
                              border: OutlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // SIGN IN WITH
                          Row(
                            children: const [
                              Text("Sign in with:   "),
                              Image(
                                  image: AssetImage("assets/google.png"),
                                  width: 22),
                              SizedBox(width: 10),
                              Icon(Icons.apple, size: 26),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // SIGN UP NAVIGATION
                          Center(
                            child: GestureDetector(
                              onTap: () => context.push("/auth/signup"),
                              child: const Text(
                                "Sign Up Now",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // LOGIN BUTTON
                          SizedBox(
                            height: 52,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3B82F6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => context.go('/'),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // FOOTER
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0066D9),
                  Color(0xFF2E78F0),
                  Color(0xFF4C8CFF),
                ],
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Terms & Condition",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                Text("Privacy Policy",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
