import 'package:flutter/material.dart';

import '../../app/routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const String weatherImageUrl =
      'https://images.unsplash.com/photo-1736215564688-f2780b42158e'
      '?auto=format&fit=crop&fm=jpg&q=80&w=1200';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ------------------------------------------------
            // Weather Image
            // ------------------------------------------------
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
                child: Image.network(
                  weatherImageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,

                  // Image load hone mein problem aaye
                  errorBuilder: (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return Container(
                      width: double.infinity,
                      color: Colors.blue.shade100,
                      child: const Center(
                        child: Icon(
                          Icons.cloud,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },

                  // Image load hone tak
                  loadingBuilder: (
                      context,
                      child,
                      loadingProgress,
                      ) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return Container(
                      width: double.infinity,
                      color: Colors.blue.shade100,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ------------------------------------------------
            // Welcome Content
            // ------------------------------------------------
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Weather App',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Know your weather,\n'
                          'wherever you go.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ------------------------------------------------
                    // Get Started Button
                    // ------------------------------------------------
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.home,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ------------------------------------------------
                    // Current Weather Button
                    // ------------------------------------------------
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.home,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: const BorderSide(
                            color: Colors.blue,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Current Weather',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}