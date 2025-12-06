import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

export 'login_screen.dart';
export 'signup_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpCtrl = TextEditingController(text: '123456');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('We sent a 6-digit code to your email.'),
            const SizedBox(height: 16),
            TextField(
              controller: otpCtrl,
              maxLength: 6,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'OTP'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Verify & Continue')),
            TextButton(onPressed: () {}, child: const Text('Resend OTP')),
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/auth/otp'),
              child: const Text('Send reset / OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
