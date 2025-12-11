import 'package:flutter/material.dart';
// NOTE: You must ensure this file 'package:internpark/detailsmyvehicle.dart' exists
// and contains the definition for the 'MyVehicle' widget.
import 'package:internpark/detailsmyvehicle.dart';

// ------------------------------------------------------------------
// --- Define Colors for Consistency (Updated with all used colors) ---
// ------------------------------------------------------------------
const Color _newBodyBackgroundColor = Color(0xFF2A2E33);
const Color _headerBackgroundColor = Color(
  0xFF21252B,
); // Color used for background image fallback/header
const Color _accentColor = Color(0xFF4C75E5);
// Colors for the new form screen
const Color _inputFieldColor = Colors.white;
const Color _inputBorderColor = Color(0xFF444B54);

// ------------------------------------------------------------------
// --- Main App Setup ---
// ------------------------------------------------------------------

void main() {
  // NOTE: Ensure 'assets/background_login.png' (for the background)
  // and 'assets/placeholder_vehicle.png' (for the center image)
  // are available in your assets folder and declared in pubspec.yaml.
  runApp(const VehicleDetailsApp());
}

class VehicleDetailsApp extends StatelessWidget {
  const VehicleDetailsApp({super.key});

  @override
  Widget build(BuildContext context) {
    // A placeholder asset path for the vehicle image, required by AddVehicleDetailsPage
    const placeholderVehiclePath = 'assets/placeholder_vehicle.png';

    return MaterialApp(
      title: 'Vehicle Details Form Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Set the default scaffold background to the body color
        scaffoldBackgroundColor: _newBodyBackgroundColor,
        brightness: Brightness.dark,
        primaryColor: _accentColor,
        colorScheme: const ColorScheme.dark(
          primary: _accentColor,
          secondary: _accentColor,
          background: _newBodyBackgroundColor,
        ),
      ),
      // Set the home to the AddVehicleDetailsPage for direct demonstration
      home: const AddVehicleDetailsPage(
        vehicleImagePath: placeholderVehiclePath,
      ),
    );
  }
}

// ------------------------------------------------------------------
// --- WIDGET: Full-Width Stretching Image Background (Partial Screen) ---
// ------------------------------------------------------------------
class _FullWidthDotBackground extends StatelessWidget {
  const _FullWidthDotBackground();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // Original logic: Height = (Status Bar Padding + 150) + (Remaining Screen Height / 2)
    final double headerHeight = mediaQuery.padding.top + 150;
    // Calculate the total height for the background image
    final double totalBackgroundHeight =
        headerHeight + (mediaQuery.size.height - headerHeight) / 2;

    // The Positioned widget explicitly sets the calculated height,
    // achieving the requested partial-screen size background.
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: totalBackgroundHeight,
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
// ## UTILITY: Build Vehicle Image with Background Gradient 🚗✨
// ------------------------------------------------------------------
Widget _buildVehicleImage(String imagePath, {double height = 220}) {
  const double imageRatio = 1.8;
  const double imageDisplayHeight = 0.8;

  return Container(
    width: height * imageRatio,
    height: height,
    alignment: Alignment.center,
    child: Stack(
      alignment: Alignment.center,
      children: [
        // Layer 1: The large, central gradient glow
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
                _accentColor.withOpacity(0.5), // Center glow
                _accentColor.withOpacity(0.0), // Fade out to transparent
              ],
              stops: const [0.0, 1.0],
            ),
          ),
        ),

        // Layer 2: Vehicle image (on top of the gradient)
        Image.asset(
          imagePath,
          fit: BoxFit.contain,
          height: height * imageDisplayHeight,
          errorBuilder: (context, error, stackTrace) {
            // Error handling widget
            return Container(
              width: height * 1.5,
              height: height * imageDisplayHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.withOpacity(0.5)),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_not_supported, color: Colors.red, size: 30),
                  Text(
                    'Image Not Found',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}

// ------------------------------------------------------------------
// --- WIDGET: Custom Text Field (Width Adjusted) 📝 ---
// ------------------------------------------------------------------
class _VehicleDetailInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData icon;
  final TextEditingController?
  controller; // Added controller for form data capture

  const _VehicleDetailInputField({
    required this.label,
    required this.hintText,
    required this.icon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Set horizontal padding for input width
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller, // Link controller here
            style: const TextStyle(color: Colors.black, fontSize: 16),
            decoration: InputDecoration(
              filled: true,
              fillColor: _inputFieldColor,
              hintText: hintText,
              hintStyle: TextStyle(color: _inputBorderColor),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                child: Icon(icon, color: _inputBorderColor, size: 24),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: _accentColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// --- SCREEN: Add Vehicle Details Page (Integrated with Background) ---
// ------------------------------------------------------------------
class AddVehicleDetailsPage extends StatefulWidget {
  final String vehicleImagePath;

  const AddVehicleDetailsPage({super.key, required this.vehicleImagePath});

  @override
  State<AddVehicleDetailsPage> createState() => _AddVehicleDetailsPageState();
}

class _AddVehicleDetailsPageState extends State<AddVehicleDetailsPage> {
  // 1. Define controllers to capture form data
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _insuranceController = TextEditingController();

  @override
  void dispose() {
    _plateController.dispose();
    _modelController.dispose();
    _insuranceController.dispose();
    super.dispose();
  }

  void _submitDetails() {
    // Collect the data to pass to the next screen
    final vehicleData = {
      'plate': _plateController.text,
      'model': _modelController.text,
      'insurance': _insuranceController.text,
    };

    // Navigate to the next screen, passing the image path and the collected details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyVehicle(
          vehicleImagePath: widget.vehicleImagePath,
          details: vehicleData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Keep the scaffold background color for the bottom half of the screen
      backgroundColor: _newBodyBackgroundColor,
      // We set extendBodyBehindAppBar to true so the body (Stack)
      // can occupy the full height behind the transparent AppBar.
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        // Set the AppBar background to transparent for the body's Stack to show through
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Add Vehicle Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),

      // *** START: Integration of Partial Background using Stack ***
      body: Stack(
        children: [
          // Layer 1: The partial screen background image
          const _FullWidthDotBackground(),

          // Layer 2: The main scrollable content
          SingleChildScrollView(
            // Now using ClampingScrollPhysics as the content might need to scroll
            // when the keyboard is open or on small screens.
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                // Use a SizedBox to push the content below the AppBar/Status Bar
                SizedBox(
                  height: MediaQuery.of(context).padding.top + kToolbarHeight,
                ),

                // Vehicle Image Display Area
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Display the image with big blue gradient background
                        _buildVehicleImage(
                          widget.vehicleImagePath,
                          height: 220,
                        ),
                        const SizedBox(height: 15),
                        // 'Change Vehicle' Text Button
                        TextButton(
                          onPressed: () {
                            // Action to change vehicle (returns to previous screen or selection)
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Change Vehicle',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // --- Form Area Container ---
                // NOTE: This container is colored with _newBodyBackgroundColor to cover
                // the lower part of the _FullWidthDotBackground, ensuring a clean transition.
                Container(
                  color: _newBodyBackgroundColor,
                  width: double.infinity,
                  child: Column(
                    children: [
                      const SizedBox(height: 1),

                      // The actual form content
                      Column(
                        children: [
                          _VehicleDetailInputField(
                            label: 'Licence Plate Number',
                            hintText: 'Enter Plate Number',
                            icon: Icons.directions_car,
                            controller: _plateController,
                          ),
                          _VehicleDetailInputField(
                            label: 'Vehicle Model',
                            hintText: 'Enter vehicle model',
                            icon: Icons.motorcycle,
                            controller: _modelController,
                          ),
                          _VehicleDetailInputField(
                            label: 'Insurance',
                            hintText: 'Enter Insurance ID',
                            icon: Icons.security,
                            controller: _insuranceController,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),

                      // Add Now Button
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 100.0,
                          ),
                          child: ElevatedButton(
                            onPressed: _submitDetails, // Call the submit method
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _accentColor,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(150),
                              ),
                            ),
                            child: const Text(
                              'Add now',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Final spacer for safe area at the bottom
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // *** END: Integration of Partial Background using Stack ***
    );
  }
}
