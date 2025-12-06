import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController(text: '+92');
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

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
                      width: 180,
                      child: Image.asset(
                        'assets/sharego_logo.png',
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
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // SOCIAL SIGNUP
                          Row(
                            children: const [
                              Text("Sign Up with:   "),
                              Image(
                                  image: AssetImage("assets/google.png"),
                                  width: 22),
                              SizedBox(width: 10),
                              Icon(Icons.apple, size: 26),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // EMAIL
                          TextField(
                            controller: emailCtrl,
                            decoration: const InputDecoration(
                              labelText: "Email:",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // PHONE
                          TextField(
                            controller: phoneCtrl,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: "Phone:",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // PASSWORD
                          TextField(
                            controller: passCtrl,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Password:",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // CONFIRM PASSWORD
                          TextField(
                            controller: confirmCtrl,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Confirm Password:",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // SIGNUP BUTTON
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
                              onPressed: () => context.go('/auth/otp'),
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Center(
                            child: GestureDetector(
                              onTap: () => context.pop(),
                              child: const Text(
                                "Back to Login",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
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
