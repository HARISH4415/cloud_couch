import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:internpark/book.dart'; // Import math for pi/radians

// --- MAIN APPLICATION SETUP ---
void main() {
  runApp(const ParkingApp());
}

class ParkingApp extends StatelessWidget {
  const ParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parking Detail UI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(
          0xFF121212,
        ), // Dark background color
        useMaterial3: true,
      ),
      home: const ParkingDetailScreen(),
    );
  }
}

// --- PARKING DETAIL SCREEN WIDGET ---
class ParkingDetailScreen extends StatelessWidget {
  const ParkingDetailScreen({super.key});

  // Helper widget for the Price/Book Now section
  Widget _buildPriceBookBar(BuildContext context) {
    return Container(
      // Vertical padding adjusted to ensure it's visually appealing at the bottom
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 42, 46, 51),
        // Line above the price bar is removed as requested
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Total Price
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Total Price',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 4),
              // Price Tag
              Text.rich(
                TextSpan(
                  text: '₹50',
                  style: const TextStyle(
                    color: Color.fromARGB(
                      255,
                      79,
                      127,
                      221,
                    ), // Blue price color
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' /hr',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Book Now Button
          ElevatedButton(
            onPressed: () {
              // Navigate to the booking screen
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(150, 50),
              backgroundColor: const Color.fromARGB(255, 79, 127, 221),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Book Now',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. REDUCED IMAGE HEADER HEIGHT: from 0.45 to 0.38
    final imageHeaderHeight = MediaQuery.of(context).size.height * 0.38;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 1. Fixed Height Image Header Section
          SizedBox(
            height: imageHeaderHeight,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                // Image (using a placeholder for demonstration)
                Image.network(
                  'https://img.freepik.com/premium-photo/full-frame-shot-parking-lot_1048944-23630625.jpg?semt=ais_hybrid&w=740&q=80',
                  fit: BoxFit.cover,
                ),

                // Dark Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.8),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),

                // Back Arrow Icon (Top Left) - UPDATED TO USE CUSTOM ICON
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 10,
                    left: 15,
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3), // Semi-transparent circle
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Main Content Area (Using Expanded to fill remaining space)
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 42, 46, 51),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Scrollable Content Area
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 8.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // CAR PARKING TAG AND RATING
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                // Car Parking Tag
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      79,
                                      127,
                                      221,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'Car Parking',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),

                                // Rating
                                Row(
                                  children: const <Widget>[
                                    Icon(
                                      Icons.star,
                                      color: Color.fromARGB(255, 63, 43, 177),
                                      size: 20,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '4.5 (345 reviews)',
                                      style: TextStyle(
                                        color: Color.fromARGB(
                                          255,
                                          128,
                                          121,
                                          121,
                                        ),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),
                            // Title and Location
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    // Parking Name
                                    Text(
                                      'Freeway Park Garage',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    // Location
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.white70,
                                          size: 18,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'EA mall, 2nd Floor Parking',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // Direction Button
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 79, 127, 221),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Transform.rotate(
                                    angle: -0.5 * math.pi / 2,
                                    child: const Icon(
                                      Icons.send,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),
                            // Tab Bar (Now stateful and dynamic)
                            const CustomTabBar(),

                            const SizedBox(height: 12),
                            // Quick Info Row (Part of 'About' content)
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '05 mins away',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '23 spots available',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),
                            // Description Section (Part of 'About' content)
                            const Text(
                              'Description',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'This parking space offers a clean, safe, and well-organized environment for vehicles. The area includes proper surveillance, lighting, and clearly marked lanes, ensuring easy navigation. Suitable for cars, bikes, and small commercial vehicles. Perfect for event-goers, travelers, and daily commuters.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 3. Persistent Price/Book Bar
                  SafeArea(top: false, child: _buildPriceBookBar(context)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom widget to recreate the Tab Bar look - NOW STATEFUL
class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int _selectedIndex = 0; // 0: About, 1: Gallery, 2: Review
  final List<String> _tabs = const ['About', 'Gallery', 'Review'];
  static const Color activeColor = Color.fromARGB(255, 79, 127, 221);
  static const Color inactiveColor = Colors.white70;

  // Calculates the Alignment based on the selected index for the indicator line
  Alignment _getIndicatorAlignment() {
    if (_selectedIndex == 0) {
      return Alignment.centerLeft;
    } else if (_selectedIndex == 1) {
      return Alignment.center;
    } else {
      return Alignment.centerRight;
    }
  }

  // Calculates the dynamic width for the indicator line based on the selected index
  double _getIndicatorWidth(int index) {
    // Note: The widths are set manually to visually match the text length
    switch (index) {
      case 0: // About
        return 55.0;
      case 1: // Gallery
        return 60.0;
      case 2: // Review
        return 65.0;
      default:
        return 55.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_tabs.length, (index) {
            final isSelected = index == _selectedIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: Text(
                _tabs[index],
                style: TextStyle(
                  color: isSelected ? activeColor : inactiveColor,
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 8),

        // The Underline/Indicator for the active tab (Animated to slide)
        Stack(
          children: [
            // Full width gray divider line (Bottom line)
            Container(height: 2, color: const Color(0xFF212121)),

            // Active indicator line, which moves and changes width
            AnimatedAlign(
              alignment: _getIndicatorAlignment(),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Container(
                width: _getIndicatorWidth(_selectedIndex),
                height: 2,
                color: activeColor, // Blue for the active indicator
              ),
            ),
          ],
        ),
      ],
    );
  }
}