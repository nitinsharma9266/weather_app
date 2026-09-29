import 'package:flutter/material.dart';

import '../../app/routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const String weatherImage =
      'assets/images/onboarding_screen.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // ==========================================================
            // RESPONSIVE IMAGE HEIGHT
            // ==========================================================
            //
            // Normal screen par image screen ka around 48% legi.
            // Bahut badi screen par image 520 px se zyada nahi hogi.
            // Bahut chhoti screen par image 240 px se kam nahi hogi.
            //
            final double imageHeight =
            (constraints.maxHeight * 0.48)
                .clamp(240.0, 520.0)
                .toDouble();

            // Image ke baad available content area.
            final double contentMinHeight =
            (constraints.maxHeight - imageHeight)
                .clamp(0.0, double.infinity)
                .toDouble();

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),

                child: Column(
                  children: [
                    // ==================================================
                    // WEATHER IMAGE
                    // ==================================================

                    SizedBox(
                      width: double.infinity,
                      height: imageHeight,

                      child: ClipRRect(
                        borderRadius:
                        const BorderRadius.only(
                          bottomLeft:
                          Radius.circular(35),
                          bottomRight:
                          Radius.circular(35),
                        ),

                        child: Image.asset(
                          weatherImage,
                          width: double.infinity,
                          height: imageHeight,
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
                        ),
                      ),
                    ),

                    // ==================================================
                    // WELCOME CONTENT
                    // ==================================================

                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: contentMinHeight,
                      ),

                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),

                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,

                          children: [
                            // ==================================================
                            // APP TITLE
                            // ==================================================

                            const Text(
                              'Weather App',
                              textAlign: TextAlign.center,

                              style: TextStyle(
                                fontSize: 32,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            // ==================================================
                            // SUBTITLE
                            // ==================================================

                            const Text(
                              'Know your weather,\n'
                                  'wherever you go.',

                              textAlign:
                              TextAlign.center,

                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                                height: 1.4,
                              ),
                            ),

                            const SizedBox(
                              height: 30,
                            ),

                            // ==================================================
                            // GET STARTED BUTTON
                            // ==================================================

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

                                style:
                                ElevatedButton
                                    .styleFrom(
                                  backgroundColor:
                                  Colors.blue,

                                  foregroundColor:
                                  Colors.white,

                                  shape:
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      14,
                                    ),
                                  ),
                                ),

                                child: const Text(
                                  'Get Started',

                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 14,
                            ),

                            // ==================================================
                            // CURRENT WEATHER BUTTON
                            // ==================================================

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

                                style:
                                OutlinedButton
                                    .styleFrom(
                                  foregroundColor:
                                  Colors.blue,

                                  side:
                                  const BorderSide(
                                    color: Colors.blue,
                                    width: 1.5,
                                  ),

                                  shape:
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      14,
                                    ),
                                  ),
                                ),

                                child: const Text(
                                  'Current Weather',

                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            // Extra bottom space
                            // for very small screens.
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}