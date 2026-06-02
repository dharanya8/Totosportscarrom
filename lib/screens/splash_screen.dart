import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:totocarrom/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late Animation<double> _fadeAnimation;
  late List<FloatingCoin> _coins;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoScale = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));

    _logoController.forward();

    _generateCoins();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const LoginScreen(),
            transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      });
    });
  }

  void _generateCoins() {
    final random = Random();
    _coins = List.generate(12, (index) {
      return FloatingCoin(
        left: random.nextDouble() * 300,
        top: random.nextDouble() * 700,
        delay: random.nextDouble() * 2,
        size: 30 + random.nextDouble() * 20,
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6C3BFF), Color(0xFF00BFFF), Color(0xFF0F172A)],
          ),
        ),
        child: Stack(
          children: [
            ..._coins.map((coin) => _AnimatedCoin(coin: coin)),

            Center(
              child: AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [Color(0xFF6C3BFF), Color(0xFF22D3EE)]),
                        ),
                        child: const Icon(Icons.sports_esports, size: 80, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),

            const Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Text(
                'TOTO SPORTS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FloatingCoin {
  final double left;
  final double top;
  final double delay;
  final double size;

  FloatingCoin({required this.left, required this.top, required this.delay, required this.size});
}

class _AnimatedCoin extends StatefulWidget {
  final FloatingCoin coin;
  const _AnimatedCoin({required this.coin});

  @override
  State<_AnimatedCoin> createState() => _AnimatedCoinState();
}

class _AnimatedCoinState extends State<_AnimatedCoin> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(seconds: 3), vsync: this);

    _floatAnimation = Tween<double>(
      begin: 0,
      end: -30,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));

    Future.delayed(Duration(milliseconds: (widget.coin.delay * 1000).toInt()), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.coin.left,
      top: widget.coin.top,
      child: AnimatedBuilder(
        animation: _floatAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: Container(
              width: widget.coin.size,
              height: widget.coin.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amber,
                boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.5), blurRadius: 10)],
              ),
            ),
          );
        },
      ),
    );
  }
}
