import 'package:flutter/material.dart';

// ------------------------------------------------------------------
// --- Define Colors for Consistency (Required) 🎨 ---
// ------------------------------------------------------------------
const Color _newBodyBackgroundColor = Color(0xFF2A2E33);
const Color _headerBackgroundColor = Color(
  0xFF21252B,
); // Used for background fallback/header area
const Color _accentColor = Color(
  0xFF4C75E5,
); // The Blue for the Radial Gradient
// Card background color that is slightly lighter than the body/header
const Color _cardColor = Color.fromARGB(185, 110, 109, 109);

// Placeholder for the image paths (REQUIRED)
const String _dottedPatternImagePath = 'assets/background_login.png';
const String _dummyVehicleImagePath =
    'assets/images/motorcycle.png'; // Used for card display

// ------------------------------------------------------------------
// --- WIDGET: Full-Width Stretching Image Background (Partial Height) 🖼️ ---
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
        _dottedPatternImagePath,
        fit: BoxFit.cover, // Ensures the image covers the set area
        errorBuilder: (context, error, stackTrace) {
          // Fallback to the dark header color if the asset is missing
          return Container(color: _headerBackgroundColor);
        },
      ),
    );
  }
}

// ------------------------------------------------------------------
// ## UTILITY: Vehicle Gradient Background Only 🚗✨
// ------------------------------------------------------------------
class _VehicleImageWithRadialGlow extends StatelessWidget {
  final String imagePath; // Kept for method compatibility, but unused
  final double height;

  const _VehicleImageWithRadialGlow(this.imagePath, {this.height = 220});

  Widget _buildRadialGradientOnly({double height = 220}) {
    const double imageRatio = 1.8;

    return Container(
      width: height * imageRatio,
      height: height,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Layer 1: The large, central gradient glow (The requested blue gradient)
          Container(
            width: height * 1.5,
            height: height * 0.9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // Using RadialGradient for a perfect central glow effect
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.5,
                colors: [
                  _accentColor.withOpacity(0.5), // Center glow (Blue)
                  _accentColor.withOpacity(0.0), // Fade out to transparent
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
          // Layer 2: Empty space to maintain the container structure/size
          SizedBox(height: height * 0.8),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The imagePath parameter is ignored as requested.
    return _buildRadialGradientOnly(height: height);
  }
}

// ------------------------------------------------------------------
// ## UTILITY: Vehicle Card Widget 🛵
// ------------------------------------------------------------------
class _VehicleSummaryCard extends StatelessWidget {
  final String imagePath;
  final String model;
  final String plate;
  final String placeholderDetail;
  final VoidCallback onTap;

  const _VehicleSummaryCard({
    required this.imagePath,
    required this.model,
    required this.plate,
    required this.placeholderDetail,
    required this.onTap,
  });

  static const double _cardBorderRadius = 20;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_cardBorderRadius),
        child: Container(
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(_cardBorderRadius),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
            boxShadow: [
              // Subtle shadow for lift effect
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Vehicle Image (Kept for card)
              SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.two_wheeler,
                          color: Colors.grey,
                          size: 50,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 15),

              // 2. Vehicle Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      model,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plate,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      placeholderDetail,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Navigation Arrow
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// --- SCREEN: MyVehicle (Integrated with Layered Backgrounds) 📱 ---
// ------------------------------------------------------------------

class MyVehicle extends StatelessWidget {
  final String vehicleImagePath;
  final Map<String, String> details;

  const MyVehicle({
    super.key,
    required this.vehicleImagePath,
    required this.details,
  });

  // Define the fixed height for the gradient container
  static const double _gradientHeight = 220;

  // Define a constant for the overlap height
  static const double _cardOverlapOffset =
      60.0; // The top padding for the card container

  // FAB Position: Set higher than default float position (~20-30px + padding)
  static const double _fabBottomPosition = 120.0;

  @override
  Widget build(BuildContext context) {
    // Helper to get the total height of the AppBar and Status Bar
    final double topPadding = MediaQuery.of(context).padding.top;
    const double appBarHeight = kToolbarHeight; // Default is 56.0
    final double totalHeaderHeight = topPadding + appBarHeight;

    // Extract data from the map
    final String model = details['model'] ?? 'Unknown Vehicle';
    final String plate = details['plate'] ?? 'No Plate';
    final String placeholderDetail = details['insurance'] ?? 'No Detail';

    return Scaffold(
      backgroundColor: _newBodyBackgroundColor,
      // Extend the body content up behind the AppBar
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        // Make the AppBar transparent to reveal the Stack content behind it
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove shadow
        scrolledUnderElevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Vehicle',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Color.fromARGB(255, 132, 127, 127),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Delete Vehicle action clicked')),
              );
            },
          ),
        ],
      ),

      // Use a Stack to layer the custom background beneath the main content
      body: Stack(
        children: [
          // 1. Dotted Background (BOTTOM LAYER)
          const _FullWidthDotBackground(),

          // 2. Gradient Container (MIDDLE LAYER - Over the Dotted Background)
          // Use Positioned to place the gradient below the AppBar area
          Positioned(
            top: totalHeaderHeight, // Starts right after the AppBar
            left: 0,
            right: 0,
            height: _gradientHeight,
            child: Center(
              child: _VehicleImageWithRadialGlow(
                vehicleImagePath,
                height: _gradientHeight,
              ),
            ),
          ),

          // 3. Main Scrollable Content (TOP LAYER)
          SingleChildScrollView(
            // Adjust the top padding to allow the card to move up and overlap the gradient.
            padding: EdgeInsets.only(
              top:
                  totalHeaderHeight +
                  _cardOverlapOffset, // The card sits 60px below the AppBar.
            ),
            child: Column(
              children: [
                // The single vehicle card (Yamaha MT)
                _VehicleSummaryCard(
                  imagePath: vehicleImagePath,
                  model: model,
                  plate: plate,
                  placeholderDetail: placeholderDetail,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Viewing full details for $model'),
                      ),
                    );
                  },
                ),
                // Add additional content here if needed...

                // Padding at the bottom for the FAB clearance
                const SizedBox(height: 800),
              ],
            ),
          ),

          // 4. Floating Action Button (Positioned in Stack) - MOVED UP
          Positioned(
            right: 16.0, // Standard FAB horizontal spacing
            // Set the bottom position using the defined offset and system bottom padding
            bottom: _fabBottomPosition + MediaQuery.of(context).padding.bottom,
            child: FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chatbot interface opened')),
                );
              },
              backgroundColor: _cardColor,
              shape: const CircleBorder(),
              elevation: 6,
              child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// --- Main App Setup 🚀 ---
// ------------------------------------------------------------------
void main() {
  // Dummy data for demonstration.
  final Map<String, String> vehicleDetails = {
    'model': 'Yamaha MT-07',
    'plate': 'PY 01 BY 9999',
    'insurance': 'VIN: XYZ123ABC987DEF',
  };

  runApp(
    MaterialApp(
      title: 'Vehicle Tracker',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // Home screen is the MyVehicle widget
      home: MyVehicle(
        vehicleImagePath: _dummyVehicleImagePath,
        details: vehicleDetails,
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
