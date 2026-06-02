import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'user_model.dart';
import 'toss_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _otpSent = false;
  bool _isLoading = false;

  String generatedOtp = '';

  void _showMessage(String text, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: error ? Colors.red : const Color(0xFF7F00FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          text,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _sendOtp() {
    if (_nameController.text.trim().isEmpty) {
      _showMessage("Please enter your name", error: true);
      return;
    }

    if (_phoneController.text.length != 10) {
      _showMessage("Enter valid phone number", error: true);
      return;
    }

    generatedOtp = (1000 + Random().nextInt(9000)).toString();

    setState(() {
      _otpSent = true;
    });

    _showMessage("OTP Sent Successfully");
  }

  Future<void> _login() async {
    if (_otpController.text != generatedOtp) {
      _showMessage("Invalid OTP", error: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Save user data
    UserModel.name = _nameController.text.trim();
    UserModel.phone = _phoneController.text.trim();

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TossScreen()));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FF),
      body: Stack(
        children: [
          Container(
            height: 360,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C3BFF), Color(0xFF00BFFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(55)),
            ),
          ),

          Positioned(
            top: -40,
            right: -30,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),

          Positioned(
            top: 120,
            left: -50,
            child: Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  Container(
                    height: 115,
                    width: 115,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 25)],
                    ),
                    child: const Icon(Icons.sports_esports, color: Color(0xFF7F00FF), size: 65),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "TOTO SPORTS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Play • Register • Win",
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 15),
                  ),

                  const SizedBox(height: 45),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Login Account",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Enter your details to continue",
                          style: TextStyle(color: Colors.black.withOpacity(0.54), fontSize: 15),
                        ),
                        const SizedBox(height: 30),

                        _buildField(
                          controller: _nameController,
                          hint: "Enter Name",
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 22),

                        _buildField(
                          controller: _phoneController,
                          hint: "Enter Phone Number",
                          icon: Icons.phone,
                          keyboard: TextInputType.phone,
                          formatter: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ),
                        const SizedBox(height: 30),

                        _buildButton(text: "Send OTP", onTap: _sendOtp),

                        if (_otpSent) ...[
                          const SizedBox(height: 30),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6C3BFF), Color(0xFF00BFFF)],
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.lock_open_rounded,
                                    color: Colors.white,
                                    size: 34,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Temporary OTP",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  generatedOtp,
                                  style: const TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),

                          // ================= OTP FIELD =================
                          _buildField(
                            controller: _otpController,
                            hint: "Enter OTP",
                            icon: Icons.lock,
                            keyboard: TextInputType.number,
                            formatter: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                          ),
                          const SizedBox(height: 30),

                          _buildButton(text: _isLoading ? "Loading..." : "Login", onTap: _login),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    List<TextInputFormatter>? formatter,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        inputFormatters: formatter,
        style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: Colors.white,
          prefixIcon: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF6C3BFF), Color(0xFF00BFFF)]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.54), fontSize: 15),
          contentPadding: const EdgeInsets.symmetric(vertical: 22),
        ),
      ),
    );
  }

  Widget _buildButton({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF6C3BFF), Color(0xFF00BFFF)]),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C3BFF).withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
