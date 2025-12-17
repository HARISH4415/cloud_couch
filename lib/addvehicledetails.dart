import 'package:flutter/material.dart';
// NOTE: You must ensure this file 'package:internpark/myvehicle.dart' exists
import 'package:internpark/myvehicle.dart';

// ------------------------------------------------------------------
// --- Define Colors for Consistency ---
// ------------------------------------------------------------------
const Color _newBodyBackgroundColor = Color(0xFF2A2E33);
const Color _headerBackgroundColor = Color(0xFF21252B);
const Color _accentColor = Color(0xFF4C75E5);
const Color _inputFieldColor = Colors.white;
const Color _inputBorderColor = Color(0xFF444B54);

// ------------------------------------------------------------------
// --- Main App Setup ---
// ------------------------------------------------------------------

void main() {
  runApp(const VehicleDetailsApp());
}

class VehicleDetailsApp extends StatelessWidget {
  const VehicleDetailsApp({super.key});

  @override
  Widget build(BuildContext context) {
    const placeholderVehiclePath = 'assets/placeholder_vehicle.png';

    return MaterialApp(
      title: 'Vehicle Details Form Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: _newBodyBackgroundColor,
        brightness: Brightness.dark,
        primaryColor: _accentColor,
        colorScheme: const ColorScheme.dark(
          primary: _accentColor,
          secondary: _accentColor,
          surface: _newBodyBackgroundColor,
        ),
      ),
      home: const AddVehicleDetailsPage(
        vehicleImagePath: placeholderVehiclePath,
      ),
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
    final double headerHeight = mediaQuery.padding.top + 150;
    final double totalBackgroundHeight =
        headerHeight + (mediaQuery.size.height - headerHeight) / 2;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: totalBackgroundHeight,
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
        Image.asset(
          imagePath,
          fit: BoxFit.contain,
          height: height * imageDisplayHeight,
          errorBuilder: (context, error, stackTrace) {
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
// --- WIDGET: Custom Text Field 📝 ---
// ------------------------------------------------------------------
class _VehicleDetailInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData icon;
  final TextEditingController? controller;

  const _VehicleDetailInputField({
    required this.label,
    required this.hintText,
    required this.icon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            controller: controller,
            style: const TextStyle(color: Colors.black, fontSize: 16),
            decoration: InputDecoration(
              filled: true,
              fillColor: _inputFieldColor,
              hintText: hintText,
              hintStyle: const TextStyle(color: _inputBorderColor),
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
// --- WIDGET: Vehicle Selection Dropdown Field ---
// ------------------------------------------------------------------
class _VehicleSelectionField extends StatelessWidget {
  final String label;
  final String selectedVehicleImage;
  final String selectedVehicleName;
  final List<Map<String, String>> vehicleOptions;
  final Function(Map<String, String>) onVehicleChanged;

  const _VehicleSelectionField({
    required this.label,
    required this.selectedVehicleImage,
    required this.selectedVehicleName,
    required this.vehicleOptions,
    required this.onVehicleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          Container(
            decoration: BoxDecoration(
              color: _inputFieldColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.transparent, width: 0),
            ),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(canvasColor: _newBodyBackgroundColor),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Map<String, String>>(
                  value: vehicleOptions.firstWhere(
                    (vehicle) => vehicle['image'] == selectedVehicleImage,
                    orElse: () => vehicleOptions.first,
                  ),
                  isExpanded: true,
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: _inputBorderColor,
                      size: 24,
                    ),
                  ),
                  dropdownColor: _newBodyBackgroundColor,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  items: vehicleOptions.map((vehicle) {
                    return DropdownMenuItem<Map<String, String>>(
                      value: vehicle,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          children: [
                            // generic car icon removed
                            Expanded(
                              child: Text(
                                vehicle['name']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                ), // changed to white
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 40,
                              height: 40,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.asset(
                                vehicle['image']!,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.directions_car,
                                    color: Colors.white,
                                    size: 20,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (Map<String, String>? newValue) {
                    if (newValue != null) {
                      onVehicleChanged(newValue);
                    }
                  },
                  selectedItemBuilder: (BuildContext context) {
                    return vehicleOptions.map((vehicle) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          children: [
                            // generic car icon removed
                            Expanded(
                              child: Text(
                                vehicle['name']!,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// --- SCREEN: Add Vehicle Details Page ---
// ------------------------------------------------------------------
class AddVehicleDetailsPage extends StatefulWidget {
  final String vehicleImagePath;

  const AddVehicleDetailsPage({super.key, required this.vehicleImagePath});

  @override
  State<AddVehicleDetailsPage> createState() => _AddVehicleDetailsPageState();
}

class _AddVehicleDetailsPageState extends State<AddVehicleDetailsPage> {
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _insuranceController = TextEditingController();

  final List<Map<String, String>> _vehicleOptions = [
    {'name': 'Sedan', 'image': 'assets/placeholder_vehicle.png'},
    {'name': 'SUV', 'image': 'assets/car.png'},
    {'name': 'Motorcycle', 'image': 'assets/bike.png'},
    {'name': 'Truck', 'image': 'assets/truck_vehicle.png'},
  ];

  late String _selectedVehicleImagePath;
  late String _selectedVehicleName;

  @override
  void initState() {
    super.initState();
    _selectedVehicleImagePath = widget.vehicleImagePath;
    _selectedVehicleName = _vehicleOptions.firstWhere(
      (vehicle) => vehicle['image'] == widget.vehicleImagePath,
      orElse: () => _vehicleOptions.first,
    )['name']!;
  }

  void _handleVehicleChanged(Map<String, String> newVehicle) {
    setState(() {
      _selectedVehicleImagePath = newVehicle['image']!;
      _selectedVehicleName = newVehicle['name']!;
    });
  }

  @override
  void dispose() {
    _plateController.dispose();
    _modelController.dispose();
    _insuranceController.dispose();
    super.dispose();
  }

  void _submitDetails() {
    final vehicleData = {
      'plate': _plateController.text,
      'model': _modelController.text,
      'insurance': _insuranceController.text,
    };

    if (_plateController.text.isEmpty || _modelController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in the details')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyVehicle(
          vehicleImagePath: _selectedVehicleImagePath,
          details: vehicleData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _newBodyBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
      ),
      body: Stack(
        children: [
          const _FullWidthDotBackground(),
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top + kToolbarHeight,
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildVehicleImage(
                          _selectedVehicleImagePath,
                          height: 220,
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: _newBodyBackgroundColor,
                  width: double.infinity,
                  child: Column(
                    children: [
                      const SizedBox(height: 1),
                      Column(
                        children: [
                          _VehicleDetailInputField(
                            label: 'Licence Plate Number',
                            hintText: 'Enter Plate Number',
                            icon: Icons.directions_car,
                            controller: _plateController,
                          ),
                          _VehicleSelectionField(
                            label: 'Vehicle Type',
                            selectedVehicleImage: _selectedVehicleImagePath,
                            selectedVehicleName: _selectedVehicleName,
                            vehicleOptions: _vehicleOptions,
                            onVehicleChanged: _handleVehicleChanged,
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 100.0,
                          ),
                          child: ElevatedButton(
                            onPressed: _submitDetails,
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
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
