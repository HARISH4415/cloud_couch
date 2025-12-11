import 'package:flutter/material.dart';

// --- Define Colors for Consistency ---
const Color _newBodyBackgroundColor = Color(0xFF2A2E33);
const Color _headerBackgroundColor = Color(0xFF21252B);
const Color _onPrimaryColor = Colors.white; // Text/Icon color

// ✨ UPDATED: Search bar color set to a standard grey for better visibility/contrast
const Color _searchBarColor = Color(0xFF707070); 
const Color _searchTextColor = Colors.black; // Text color inside the grey search bar

// ------------------------------------------------------------------
// --- Main App Setup ---
// ------------------------------------------------------------------
void main() {
  // NOTE: Ensure 'assets/background_login.png' is available in your assets folder.
  // The original image seems to be a repeating dot pattern.
  // For this code to run, you must have an asset named 'assets/background_login.png'.
  // If you don't, it will fall back to a solid color defined in _headerBackgroundColor.
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
        // Set the default background for Scaffolds
        scaffoldBackgroundColor: _newBodyBackgroundColor,
        brightness: Brightness.dark,
        // Define a consistent color scheme for the App Bar
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // Make it transparent to show Stack background
          elevation: 0, // Remove shadow
          iconTheme: IconThemeData(color: _onPrimaryColor),
          titleTextStyle: TextStyle(color: _onPrimaryColor, fontSize: 20),
        ),
        // Define the input decoration theme for the search bar
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: _searchBarColor, // ✨ Uses the new GREY color
          hintStyle: TextStyle(color: _searchTextColor.withOpacity(0.7)), // Adjust hint color for grey background
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none, // Remove border line
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.blue, width: 2.0), // Optional: Highlight when focused
          ),
        ),
      ),
      home: const BackgroundHostScreen(),
    );
  }
}

// ------------------------------------------------------------------
// --- WIDGET: Full-Width Stretching Image Background ---
// ------------------------------------------------------------------
class _FullWidthDotBackground extends StatelessWidget {
  const _FullWidthDotBackground();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // Calculates a height that covers more than half the screen, based on
    // the original code's requirement (150 + half of the remaining height).
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
// --- WIDGET: Search Bar ---
// ------------------------------------------------------------------
class _SearchWidget extends StatelessWidget {
  const _SearchWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextField(
        // Set text color to black for high contrast against the grey background
        style: const TextStyle(color: _searchTextColor), 
        decoration: InputDecoration(
          hintText: 'Search for location or address...',
          prefixIcon: Icon(
            Icons.search,
            color: _searchTextColor.withOpacity(0.7), // Adjust icon color for grey background
          ),
        ),
        onSubmitted: (value) {
          // Implement search logic here
          debugPrint('Search submitted: $value');
        },
      ),
    );
  }
}

// ------------------------------------------------------------------
// --- WIDGET: Custom UI Content (AppBar and Body) ---
// ------------------------------------------------------------------
class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. MUST use Column to stack the AppBar and the content below it.
    return Column(
      children: [
        // 1. App Bar equivalent
        AppBar(
          // ⬅️ Back arrow/button restored here
          // The BackButton works naturally within the 'leading' slot.
          leading: const BackButton(color: _onPrimaryColor),

          title: const Text(
            'Explore',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decorationColor: _onPrimaryColor,
              decorationThickness: 2,
            ),
          ),
          centerTitle: false, // Ensures left alignment (after the back button)
          actions: const [
            // Menu/Hamburger icon
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.menu, color: _onPrimaryColor, size: 30),
            ),
          ],
        ),

        // 2. "Parking nearby" section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Parking nearby',
                style: TextStyle(
                  color: _onPrimaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // Filter Icon
              Icon(
                Icons.filter_list,
                color: _onPrimaryColor.withOpacity(0.7),
                size: 24,
              ),
            ],
          ),
        ),

        // 3. Search Bar Widget goes here
        const _SearchWidget(),

        // You would typically have a ListView or other scrollable content here
      ],
    );
  }
}

// ------------------------------------------------------------------
// --- Host Screen: Displays background and content in a Stack ---
// ------------------------------------------------------------------
class BackgroundHostScreen extends StatelessWidget {
  const BackgroundHostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // The background color of the Scaffold will be visible below the image
      backgroundColor: _newBodyBackgroundColor,

      // Use a Stack to layer the content on top of the background
      body: Stack(
        children: [
          // 1. Background Layer (Partial Image)
          _FullWidthDotBackground(),

          // 2. Foreground Layer (The UI components)
          Explore(),
        ],
      ),
    );
  }
}