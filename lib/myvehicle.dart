import 'package:flutter/material.dart';
import 'package:internpark/addvehicledetails.dart';
import 'package:internpark/explore.dart';

// ------------------------------------------------------------------
// --- Define Colors for Consistency 🎨 ---
// ------------------------------------------------------------------
const Color _newBodyBackgroundColor = Color(0xFF2A2E33);
const Color _headerBackgroundColor = Color(0xFF21252B);
const Color _accentColor = Color(0xFF4C75E5);
const Color _cardColor = Color.fromARGB(185, 110, 109, 109);

const String _dottedPatternImagePath = 'assets/background_login.png';
const String _dummyVehicleImagePath = 'assets/images/motorcycle.png';

// ------------------------------------------------------------------
// --- WIDGET: Full-Width Stretching Image Background ---
// ------------------------------------------------------------------
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
        _dottedPatternImagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Container(color: _headerBackgroundColor),
      ),
    );
  }
}

// ------------------------------------------------------------------
// ## UTILITY: Vehicle Gradient Background Only 🚗✨
// ------------------------------------------------------------------
class _VehicleImageWithRadialGlow extends StatelessWidget {
  final String imagePath;
  final double height;
  const _VehicleImageWithRadialGlow(this.imagePath, {this.height = 220});

  @override
  Widget build(BuildContext context) {
    const double imageRatio = 1.8;
    return Container(
      width: height * imageRatio,
      height: height,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: height * 1.5,
            height: height * 0.9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.5,
                colors: [
                  _accentColor.withOpacity(0.5),
                  _accentColor.withOpacity(0.0),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.two_wheeler,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// --- SCREEN: MyVehicle 📱 ---
// ------------------------------------------------------------------
class MyVehicle extends StatelessWidget {
  final String vehicleImagePath;
  final Map<String, String> details;

  const MyVehicle({
    super.key,
    required this.vehicleImagePath,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    final double totalHeaderHeight =
        MediaQuery.of(context).padding.top + kToolbarHeight;
    final String model = details['model'] ?? 'Unknown Vehicle';

    return Scaffold(
      backgroundColor: _newBodyBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Vehicle',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          // 1. Background Pattern
          const _FullWidthDotBackground(),

          // 2. Glow Effect behind where the image would be
          Positioned(
            top: totalHeaderHeight,
            left: 0,
            right: 0,
            height: 220,
            child: _VehicleImageWithRadialGlow(vehicleImagePath, height: 220),
          ),

          // 3. Vehicle Card
          Positioned(
            top: totalHeaderHeight + 60.0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _VehicleSummaryCard(
                  imagePath: vehicleImagePath,
                  model: model,
                  plate: details['plate'] ?? 'No Plate',
                  placeholderDetail: details['insurance'] ?? 'No Detail',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExploreScreen(
                          onBackToHome: () => Navigator.pop(context),
                          onSearchStateChanged: (bool isSearching) {},
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // --- 4. FLOATING ICON (+) ADDED HERE ---
          Positioned(
            bottom: 30 + MediaQuery.of(context).padding.bottom,
            right: 25,
            height: 195,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddVehicleDetailsPage(
                      vehicleImagePath: 'assets/car.png',
                    ),
                  ),
                );
                // Define your "Add Vehicle" logic here
              },
              backgroundColor: _accentColor, // Uses your theme's blue
              shape: const CircleBorder(),
              elevation: 8,
              child: const Icon(Icons.add, color: Colors.white, size: 32),
            ),
          ),
        ],
      ),
    );
  }
}
