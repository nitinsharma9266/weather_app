import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),

            child: Padding(
              padding: const EdgeInsets.all(12.0),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  // =========================
                  // Location Section
                  // =========================

                  Row(
                    children: [

                      Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 16,
                      ),

                      const SizedBox(width: 8),

                      Text(
                        "Delhi India",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Spacer(),

                      Icon(
                        Icons.settings,
                        color: Colors.blue,
                        size: 16,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // Search Section
                  // =========================

                  Row(
                    children: [

                      const SizedBox(width: 10),

                      Icon(
                        Icons.search,
                        color: Colors.blue,
                        size: 20,
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: SearchBar(
                          hintText: "Search for city",
                          elevation: WidgetStateProperty.all(0),
                          backgroundColor:
                          WidgetStateProperty.all(Colors.white),
                          onSubmitted: (value) {
                            print("Searching for: $value");
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // Current Weather
                  // =========================

                  Center(
                    child: Icon(
                      Icons.sunny,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: Text(
                      "28°C",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Text(
                      "Clear Sky",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Text(
                      "Feels like 28°C",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // Weather Information Cards
                  // =========================

                  Row(
                    children: [

                      Expanded(
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),

                            child: Column(
                              children: [

                                Icon(
                                  Icons.water_drop,
                                  color: Colors.blue,
                                  size: 20,
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  "Humidity",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  "80%",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),

                            child: Column(
                              children: [

                                Icon(
                                  Icons.wind_power,
                                  color: Colors.blue,
                                  size: 20,
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  "Wind",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  "12 KM/h",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // Hourly Forecast Heading
                  // =========================

                  Center(
                    child: Text(
                      "Hourly Forecast",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // Hourly Forecast Cards
                  // =========================

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,

                    child: Row(
                      children: [

                        // Card 1
                        SizedBox(
                          width: 95,
                          height: 140,

                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),

                              child: Column(
                                children: [

                                  Text(
                                    "10:00 AM",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Icon(
                                    Icons.sunny,
                                    color: Colors.red,
                                    size: 14,
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    "28°C",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Card 2
                        SizedBox(
                          width: 95,
                          height: 140,

                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),

                              child: Column(
                                children: [

                                  Text(
                                    "11:00 AM",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Icon(
                                    Icons.sunny,
                                    color: Colors.red,
                                    size: 14,
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    "29°C",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Card 3
                        SizedBox(
                          width: 95,
                          height: 140,

                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),

                              child: Column(
                                children: [

                                  Text(
                                    "12:00 PM",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Icon(
                                    Icons.sunny,
                                    color: Colors.red,
                                    size: 14,
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    "30°C",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Card 4
                        SizedBox(
                          width: 95,
                          height: 140,

                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),

                              child: Column(
                                children: [

                                  Text(
                                    "1:00 PM",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Icon(
                                    Icons.sunny,
                                    color: Colors.red,
                                    size: 14,
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    "31°C",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    " 5 Day Forecast",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}