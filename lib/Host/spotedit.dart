import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// --- ADDED: Location Packages ---
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

// --- Define Colors for Consistency ---
const Color _newBodyBackgroundColor = Color(0xFF2A2E33);
const Color _accentBlue = Color(0xFF539DF3);
const Color _textGray = Colors.white70;
const Color _primaryBlue = Color(0xFF5486E0);

// Colors for the Verify Screen
const Color _verifyPrimaryBlue = Color(0xFF5486E0); 
const Color _verifyContainerColor = Color(0xFF353A40); 

void main() {
  runApp(const FullScreenBackgroundApp());
}

class FullScreenBackgroundApp extends StatelessWidget {
  const FullScreenBackgroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edit Spot UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: _newBodyBackgroundColor,
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        sliderTheme: SliderThemeData(
          activeTrackColor: _accentBlue,
          inactiveTrackColor: Colors.grey[700],
          thumbColor: _accentBlue,
          overlayColor: _accentBlue.withAlpha(30),
        ),
      ),
      home: const EditSpotScreen(),
    );
  }
}

// ... (Keep _FullWidthDotBackground class as is) ...
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
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  _newBodyBackgroundColor.withOpacity(0.0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==================================================================
// === SCREEN 1: EDIT SPOT (UPDATED) ===
// ==================================================================

class EditSpotScreen extends StatefulWidget {
  const EditSpotScreen({super.key});

  @override
  State<EditSpotScreen> createState() => _EditSpotScreenState();
}

class _EditSpotScreenState extends State<EditSpotScreen> {
  // --- State Variables ---
  double _price = 150;
  bool _is24Hrs = false;
  bool _hasCCTV = true;

  late TextEditingController _addressController;
  late TextEditingController _descriptionController;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  List<String> _selectedDays = [];
  final List<String> _daysList = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday',
    'Friday', 'Saturday', 'Sunday', 'Everyday',
  ];

  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 23, minute: 0);
  
  // --- ADDED: Loading state for location fetching ---
  bool _isFetchingLocation = false;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(
        text: "9, Avvai street, Kirumambakkam, Pondicherry 605 023");
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // --- ADDED: Logic to fetch GPS Location ---
  Future<void> _getCurrentLocation() async {
    setState(() => _isFetchingLocation = true);
    
    try {
      // 1. Check Service
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      // 2. Check Permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied.';
      }

      // 3. Get Coordinates
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 4. Reverse Geocode (Lat/Long -> Address)
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, 
        position.longitude
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Construct a readable address string
        String address = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}";
        
        // Update the text controller
        setState(() {
          _addressController.text = address;
        });
        
        if(mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text("Location updated via GPS")),
           );
        }
      }
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if(mounted) setState(() => _isFetchingLocation = false);
    }
  }

  // --- Functions ---
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image: $e")),
      );
    }
  }

  // ... (Keep _showMultiSelect and _selectTime as they were) ...
  void _showMultiSelect() async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Select Days"),
              backgroundColor: _newBodyBackgroundColor,
              content: SingleChildScrollView(
                child: ListBody(
                  children: _daysList.map((day) {
                    final isChecked = _selectedDays.contains(day);
                    return CheckboxListTile(
                      value: isChecked,
                      title: Text(day),
                      activeColor: _accentBlue,
                      checkColor: Colors.white,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked == true) {
                            _selectedDays.add(day);
                          } else {
                            _selectedDays.remove(day);
                          }
                        });
                        setDialogState(() {}); 
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("DONE", style: TextStyle(color: _accentBlue)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _accentBlue,
              onPrimary: Colors.white,
              surface: _newBodyBackgroundColor,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _newBodyBackgroundColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            const _FullWidthDotBackground(),
            SafeArea(
              child: Column(
                children: [
                  _buildAppBar(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          _buildImagePreview(),
                          const SizedBox(height: 20),
                          Center(
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: const Text(
                                "Add/Change photos",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          _buildAddressField(), // Updated Widget
                          const SizedBox(height: 25),
                          _buildPriceSlider(),
                          const SizedBox(height: 1),
                          _buildDaysDropdown(),
                          const SizedBox(height: 20),
                          _buildTimingSection(context),
                          const SizedBox(height: 25),
                          _buildCCTVSection(),
                          const SizedBox(height: 25),
                          const Text(
                            "Description",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          _buildDescriptionField(), 
                          const SizedBox(height: 30),
                          _buildSaveButton(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  // --- UPDATED: Address Field with GPS Icon ---
  Widget _buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Address",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _addressController,
          style: const TextStyle(
            color: Color.fromARGB(168, 255, 254, 254),
            fontSize: 14,
          ),
          maxLines: null,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 179, 176, 176).withOpacity(0.2), 
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _accentBlue, width: 1),
            ),
            // --- ADDED: Suffix Icon for GPS ---
            suffixIcon: IconButton(
              onPressed: _isFetchingLocation ? null : _getCurrentLocation,
              icon: _isFetchingLocation 
                ? const SizedBox(
                    width: 20, 
                    height: 20, 
                    child: CircularProgressIndicator(strokeWidth: 2, color: _accentBlue)
                  )
                : const Icon(Icons.my_location, color: _accentBlue),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionController,
      maxLines: 4, 
      style: const TextStyle(
        color: Color.fromARGB(220, 255, 255, 255),
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: "Enter details about the spot...",
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
        filled: true,
        fillColor: const Color.fromARGB(255, 179, 176, 176).withOpacity(0.2),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _accentBlue, width: 1),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          debugPrint("Saving Description: ${_descriptionController.text}");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Spot details saved successfully!")),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
          shadowColor: _primaryBlue.withOpacity(0.4),
        ),
        child: const Text(
          "Save",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
          const SizedBox(width: 10),
          const Text(
            "Edit spot",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ... (Keep existing _buildImagePreview, _buildPriceSlider, _buildDaysDropdown, 
  //      _buildTimingSection, _buildCCTVSection, and VerifyCCTVContent class) ...
  
  Widget _buildImagePreview() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: _selectedImage != null
                ? FileImage(_selectedImage!) as ImageProvider
                : const NetworkImage(
                    'https://images.unsplash.com/photo-1542362567-b07e54358753?q=80&w=2070&auto=format&fit=crop',
                  ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black.withOpacity(0.1),
              ),
            ),
            const Center(
              child: Icon(Icons.camera_alt, color: Colors.white70, size: 40),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _selectedImage != null ? "Custom Photo" : "Default Photo",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Price (per hour)",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Slider(
          value: _price,
          min: 0,
          max: 500,
          divisions: 100,
          onChanged: (val) => setState(() => _price = val),
        ),
        Center(
          child: Text(
            "₹${_price.toInt()}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDaysDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Days", style: TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _showMultiSelect,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _selectedDays.isEmpty
                      ? const Text(
                          "Pick your days",
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: _selectedDays.map((day) {
                            return Chip(
                              label: Text(
                                day,
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              backgroundColor: _accentBlue,
                              deleteIcon: const Icon(Icons.close, size: 14, color: Colors.white),
                              onDeleted: () {
                                setState(() {
                                  _selectedDays.remove(day);
                                });
                              },
                            );
                          }).toList(),
                        ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

 Widget _buildTimingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Timing",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            // FROM LABEL
            Text(
              "From  ",
              style: TextStyle(
                color: _is24Hrs ? Colors.white38 : _textGray, // Dim label if 24h
              ),
            ),
            // FROM TIME BOX
            GestureDetector(
              // Logic: If 24hrs is true, set onTap to null (disable click)
              onTap: _is24Hrs ? null : () => _selectTime(context, true),
              child: Opacity(
                // Logic: If 24hrs is true, reduce opacity to 0.5
                opacity: _is24Hrs ? 0.5 : 1.0,
                child: _buildTimeBox(_startTime.format(context)),
              ),
            ),
            
            const SizedBox(width: 15),
            
            // TO LABEL
            Text(
              "To  ",
              style: TextStyle(
                color: _is24Hrs ? Colors.white38 : _textGray, // Dim label if 24h
              ),
            ),
            // TO TIME BOX
            GestureDetector(
              // Logic: If 24hrs is true, set onTap to null (disable click)
              onTap: _is24Hrs ? null : () => _selectTime(context, false),
              child: Opacity(
                // Logic: If 24hrs is true, reduce opacity to 0.5
                opacity: _is24Hrs ? 0.5 : 1.0,
                child: _buildTimeBox(_endTime.format(context)),
              ),
            ),
            
            const Spacer(),
            
            // CHECKBOX
            Checkbox(
              value: _is24Hrs,
              side: const BorderSide(color: _accentBlue),
              activeColor: _accentBlue,
              onChanged: (val) {
                setState(() {
                  _is24Hrs = val!;
                  // Optional: Reset times to 00:00 - 23:59 if checked
                  if (_is24Hrs) {
                    _startTime = const TimeOfDay(hour: 0, minute: 0);
                    _endTime = const TimeOfDay(hour: 23, minute: 59);
                  }
                });
              },
            ),
            const Text("24 hrs", style: TextStyle(color: _textGray)),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeBox(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      constraints: const BoxConstraints(minWidth: 80),
      alignment: Alignment.center,
      child: Text(
        time,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildCCTVSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Installed CCTV?",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                const Text("Yes", style: TextStyle(color: _textGray)),
                Checkbox(
                  value: _hasCCTV,
                  activeColor: _accentBlue,
                  side: const BorderSide(color: Colors.grey),
                  onChanged: (val) => setState(() => _hasCCTV = true),
                ),
                const SizedBox(width: 10),
                const Text("No", style: TextStyle(color: _textGray)),
                Checkbox(
                  value: !_hasCCTV,
                  activeColor: _accentBlue,
                  side: const BorderSide(color: Colors.grey),
                  onChanged: (val) => setState(() => _hasCCTV = false),
                ),
              ],
            ),
            if (_hasCCTV)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BackgroundHostScreen()),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "If yes, ",
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    Text(
                      "verify it",
                      style: TextStyle(color: Color(0xFF539DF3), fontSize: 12),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ... (Keep BackgroundHostScreen and VerifyCCTVContent unchanged at the bottom) ...
class BackgroundHostScreen extends StatelessWidget {
  const BackgroundHostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _newBodyBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Handle back navigation
          },
        ),
        title: const Text(
          "Verify CCTV",
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: const Stack(
        children: [
          _FullWidthDotBackground(),
          SafeArea(child: VerifyCCTVContent()),
        ],
      ),
    );
  }
}

class VerifyCCTVContent extends StatelessWidget {
  const VerifyCCTVContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            "Instructions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Please upload your CCTV present recording with geotag and timestamp. Any variation with the image uploaded or footage of any different time will fail to be verified. So follow this instruction to get it verified.",
            style: TextStyle(fontSize: 14, height: 1.4, color: Colors.white70),
          ),
          const SizedBox(height: 30),
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _verifyContainerColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.file_upload_outlined,
                  size: 40,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(height: 12),
                Text(
                  "Upload your file",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.description_outlined, color: Colors.black54),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Vid00193813_cctv.mp4",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.close, color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "(Once verified, you'll be notified and your spot will be open for CCTV availability)",
            style: TextStyle(fontSize: 12, color: Colors.white60),
          ),
          const SizedBox(height: 50),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: _verifyPrimaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 2,
              ),
              child: const Text(
                "Verify",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Disclaimer: The space owners are accountable for fraudulent in the footage after verification and complaints from the customers.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white54,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}