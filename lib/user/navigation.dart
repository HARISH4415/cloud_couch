import 'package:flutter/material.dart';

const Color _newBodyBackgroundColor = Color(0xFF2A2E33);
const Color _headerBackgroundColor = Color(0xFF21252B);

void main() {
  runApp(const FullScreenBackgroundApp());
}

class FullScreenBackgroundApp extends StatelessWidget {
  const FullScreenBackgroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: _newBodyBackgroundColor,
        brightness: Brightness.dark,
        fontFamily: 'sans-serif',
      ),
      home: const BackgroundHostScreen(),
    );
  }
}

class BackgroundHostScreen extends StatelessWidget {
  const BackgroundHostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _newBodyBackgroundColor,
      body: Stack(
        children: [
          // 1. Background Layer (The Dots)
          const _FullWidthDotBackground(),

          // 2. Map Container and Header
          SafeArea(
            child: Column(
              children: [
                // Header Row
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 15.0,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back, color: Colors.white),
                      const SizedBox(width: 16),
                      const Text(
                        'Navigation',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Map Container (White area)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                      child: Stack(
                        children: [
                          // Placeholder for actual Map
                          const Center(
                            child: Icon(
                              Icons.map,
                              size: 100,
                              color: Colors.grey,
                            ),
                          ),

                          // Time Label Overlay (Top Right of Map)
                          const Positioned(
                            top: 30,
                            right: 30,
                            child: Text(
                              "03:21",
                              style: TextStyle(
                                color: Color(0xFF4A4A4A),
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Extra space at bottom to prevent map from touching the screen edge
                const SizedBox(height: 10),
              ],
            ),
          ),

          // 3. Floating Bottom Info Card (Overlays the map)
          Positioned(
            bottom: 25, // Distance from bottom of screen
            left: 10,
            right: 10,
            child: _BottomInfoCard(),
          ),
        ],
      ),
    );
  }
}

// --- Bottom Info Card Widget ---
class _BottomInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3E4247), // Dark grey card from image
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Parking Image Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              'https://img.freepik.com/premium-photo/full-frame-shot-parking-lot_1048944-23630625.jpg?semt=ais_hybrid&w=740&q=80',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 25),
          // Text Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Freeway Park Garage',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.location_on, size: 16, color: Colors.white70),
                    Text(' 125m', style: TextStyle(color: Colors.white70)),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  '2nd Floor (B-3)',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Estimated time: 1 mins',
                  style: TextStyle(fontSize: 12, color: Colors.white54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Background Widget ---
class _FullWidthDotBackground extends StatelessWidget {
  const _FullWidthDotBackground();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double headerHeight = mediaQuery.padding.top + 150;
    final double totalHeight =
        headerHeight + (mediaQuery.size.height - headerHeight) / 2;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: totalHeight,
      child: Image.asset(
        'assets/background_login.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(color: _headerBackgroundColor);
        },
      ),
    );
  }
}
