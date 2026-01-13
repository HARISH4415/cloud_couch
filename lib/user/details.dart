import 'package:flutter/material.dart';

// --- Define Colors for Consistency (Kept for fallback color) ---
const Color _newBodyBackgroundColor = Color(0xFF2A2E33);
const Color _headerBackgroundColor = Color(0xFF21252B);

// ------------------------------------------------------------------
// --- Main App Setup ---
// ------------------------------------------------------------------
void main() {
  // NOTE: Ensure 'assets/background_login.png' is available in your assets folder.
  runApp(const FullScreenBackgroundApp());
}

class FullScreenBackgroundApp extends StatelessWidget {
  const FullScreenBackgroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Partial Background Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: _newBodyBackgroundColor,
        brightness: Brightness.dark,
      ),
      // Set the home to the screen that displays the background
      home: const BackgroundHostScreen(),
    );
  }
}

// ------------------------------------------------------------------
// --- WIDGET: Full-Width Stretching Image Background (Reverted to original size logic) ---
// ------------------------------------------------------------------
class _FullWidthDotBackground extends StatelessWidget {
  const _FullWidthDotBackground();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    
    // Original logic: Height = (Status Bar Padding + 150) + (Remaining Screen Height / 2)
    final double headerHeight = mediaQuery.padding.top + 150;
    final double totalHeight =
        headerHeight + (mediaQuery.size.height - headerHeight) / 2;

    // The Positioned widget explicitly sets the calculated height, 
    // achieving the requested partial-screen size.
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: totalHeight,
      child: Image.asset(
        'assets/background_login.png',
        fit: BoxFit.cover, // Ensures the image covers the set area
        errorBuilder: (context, error, stackTrace) {
          // Fallback to a solid background color if the asset is missing
          return Container(color: _headerBackgroundColor);
        },
      ),
    );
  }
}

// ------------------------------------------------------------------
// --- Host Screen: Displays ONLY the specific size background ---
// ------------------------------------------------------------------
class BackgroundHostScreen extends StatelessWidget {
  const BackgroundHostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // The background color of the Scaffold will be visible below the image
      backgroundColor: _newBodyBackgroundColor, 
      
      // Use a Stack to layer the content
      body: Stack(
        children: [
          // This is the background layer with the specific height
          _FullWidthDotBackground(),
          
          // Content for demonstration
          Center(
            child: Text(
              'Background Size Restored to Original',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}