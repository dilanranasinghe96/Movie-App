import 'package:flutter/material.dart';
import 'package:logo_n_spinner/logo_n_spinner.dart';

import 'homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogoandSpinner(
              imageAssets: 'lib/assets/logo.png',
              reverse: true,
              arcColor: Colors.blue,
              spinSpeed: Duration(milliseconds: 500),
            ),
            Text(
              'Movie App',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
