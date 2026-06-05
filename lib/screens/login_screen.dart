import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  bool otpSent = false;
  String generatedOtp = "";

  void sendOtp() {
    if (nameController.text.trim().isEmpty) {
      showMsg("Enter Name");
      return;
    }

    if (phoneController.text.trim().length != 10) {
      showMsg("Enter Valid Phone Number");
      return;
    }

    generatedOtp = (1000 + Random().nextInt(9000)).toString();

    setState(() {
      otpSent = true;
    });

    showMsg("OTP Sent : $generatedOtp");
  }

  void login() {
    if (otpController.text != generatedOtp) {
      showMsg("Invalid OTP");
      return;
    }

    showMsg("Login Success");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainNavigationScreen(
          userName: nameController.text.trim(),
          userPhone: phoneController.text.trim(),
        ),
      ),
    );
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget buildField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboard = TextInputType.text,
    List<TextInputFormatter>? formatter,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        inputFormatters: formatter,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          filled: true,
          fillColor: Colors.blueAccent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 75,
                  width: 75,
                  decoration: BoxDecoration(
                    color: const Color(0xff3F51B5),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.shield_outlined, color: Colors.white, size: 40),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Welcome Back",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                ),

                const SizedBox(height: 8),

                Text("Please sign in to continue", style: TextStyle(color: Colors.grey.shade600)),

                const SizedBox(height: 30),

                buildField(
                  hint: "Enter Name",
                  icon: Icons.person_outline,
                  controller: nameController,
                ),

                buildField(
                  hint: "Enter Phone Number",
                  icon: Icons.phone_outlined,
                  controller: phoneController,
                  keyboard: TextInputType.phone,
                  formatter: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),

                if (otpSent)
                  buildField(
                    hint: "Enter OTP",
                    icon: Icons.lock_outline,
                    controller: otpController,
                    keyboard: TextInputType.number,
                    formatter: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                  ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: otpSent ? login : sendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3F51B5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      otpSent ? "Login" : "Send OTP",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),

                if (otpSent) ...[
                  const SizedBox(height: 20),
                  Text(
                    "Demo OTP : $generatedOtp",
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
