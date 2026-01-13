import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:internpark/Host/hostdetails.dart';
import 'package:internpark/Host/hostprofile.dart';
import 'package:internpark/Host/notification.dart';
import 'package:internpark/Host/spotedit.dart';

// --- Global Theme Colors ---
const Color _bodyBackgroundColor = Color(0xFF2A2E33);
const Color _navBarColor = Color(0xFF444B54);
const Color _accentColor = Color(0xFF4C75E5);

// --- Dashboard Specific Colors ---
const Color _cardColor = Color(0xFF3E4247);
const Color _headerBackgroundColor = Color(0xFF21252B);

// --- Edit Screen Specific Colors ---
const Color _accentBlue = Color(0xFF539DF3);
const Color _textGray = Colors.white70;
// --- Verify Screen Colors ---
const Color _verifyPrimaryBlue = Color(0xFF5486E0);
const Color _verifyContainerColor = Color(0xFF353A40);

void main() {
  runApp(const BottomNavBarApp());
}

class BottomNavBarApp extends StatelessWidget {
  const BottomNavBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'sans-serif',
        sliderTheme: SliderThemeData(
          activeTrackColor: _accentBlue,
          inactiveTrackColor: Colors.grey[700],
          thumbColor: _accentBlue,
          overlayColor: _accentBlue.withAlpha(30),
        ),
      ),
      home: const Hostpage(),
    );
  }
}

class Hostpage extends StatefulWidget {
  const Hostpage({super.key});

  @override
  State<Hostpage> createState() => _HostpageState();
}

class _HostpageState extends State<Hostpage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bodyBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Show the general background only if NOT on the dashboard
          if (_selectedIndex != 0) const _FullWidthBackground(),

          if (_selectedIndex == 0)
            const DashboardPage()
          else if (_selectedIndex == 1)
            const ChatPageContent()
          else
            const Hostprofile(),

          Align(
            alignment: Alignment.bottomCenter,
            child: _buildCustomBottomNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomBottomNavBar() {
    final Color unselectedColor = Colors.white.withOpacity(0.5);
    final List<Map<String, dynamic>> items = [
      {'icon': Icons.home_outlined, 'label': 'Home'},
      {'icon': Icons.add, 'label': ''},
      {'icon': Icons.person_outline, 'label': 'Profile'},
    ];

    return Container(
      color: _navBarColor,
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isCenterItem = index == 1;

            return GestureDetector(
              onTap: () => _onItemTapped(index),
              child: Padding(
                padding: EdgeInsets.only(
                  top: isCenterItem ? 0 : 15,
                  bottom: isCenterItem ? 10 : 5,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isCenterItem
                        ? Transform.translate(
                            offset: const Offset(0.0, -25.0),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _accentColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: _accentColor.withOpacity(0.4),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          )
                        : Icon(
                            item['icon'] as IconData,
                            color: _selectedIndex == index
                                ? _accentColor
                                : unselectedColor,
                            size: 26,
                          ),
                    if (!isCenterItem)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          item['label'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: _selectedIndex == index
                                ? _accentColor
                                : unselectedColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _FullWidthBackground extends StatelessWidget {
  const _FullWidthBackground();
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Image.asset(
        'assets/background_login.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Container(color: Colors.black26),
      ),
    );
  }
}

class _UploadSection extends StatelessWidget {
  final String title;
  final bool isMandatory;
  final File? imageFile;
  final VoidCallback onTap;

  const _UploadSection({
    required this.title,
    required this.onTap,
    this.imageFile,
    this.isMandatory = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isMandatory)
              const Text(
                " *",
                style: TextStyle(color: Colors.redAccent, fontSize: 14),
              ),
          ],
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
              image: imageFile != null
                  ? DecorationImage(
                      image: FileImage(imageFile!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageFile == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.grey.shade400,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Upload photo",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// ============================================================================
// ========================== DASHBOARD PAGE CODE =============================
// ============================================================================

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _DashboardDotBackground(),
        SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildDashboardHeader(context),
                const SizedBox(height: 30),
                const Text(
                  'Dashboard',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                const Text(
                  'My Listing',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 15),
                _buildHorizontalList(context),
                const SizedBox(height: 30),
                const Divider(color: Colors.white24, thickness: 1.5),
                const SizedBox(height: 20),
                _buildSlotCard(
                  context,
                  "Parking slot 1",
                  "1:00 pm to 4:00 pm",
                  "Checked in",
                  "01:21",
                  "https://images.unsplash.com/photo-1506521781263-d8422e82f27a?q=80&w=400",
                ),
                _buildSlotCard(
                  context,
                  "Parking slot 2",
                  "07:00 am to 10:00 am",
                  "Pending",
                  "--",
                  "https://images.unsplash.com/photo-1590674899484-d5640e854abe?q=80&w=400",
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Yesterday',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
                _buildSlotCard(
                  context,
                  "Parking slot 3",
                  "08:00 am to 10:00 am",
                  "Checked out",
                  "--",
                  "https://images.unsplash.com/photo-1573348722427-f1d6819fdf98?q=80&w=400",
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello Pat !',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 4),
            Row(
              children: const [
                Icon(Icons.location_on, size: 16, color: Colors.white70),
                SizedBox(width: 4),
                Text(
                  'Pondicherry',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Icon(
                  Icons.keyboard_arrow_right,
                  size: 18,
                  color: Colors.white70,
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const notfication()),
            );
          },
          icon: const Icon(
            Icons.notifications_none,
            size: 28,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalList(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditSpotScreen()),
              );
            },
            child: Container(
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1545179605-1296651e9d43?q=80&w=400',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
                child: const Stack(
                  children: [
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Row(
                        children: [
                          Text(
                            'Parking slot 1 ',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Icon(Icons.edit, size: 12, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Container(
            width: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white24, width: 1.5),
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withOpacity(0.05),
            ),
            child: const Icon(Icons.add, color: Colors.white24, size: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotCard(
    BuildContext context,
    String title,
    String time,
    String status,
    String remaining,
    String imageUrl,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QRScannerScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _cardColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                width: 85,
                height: 85,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.white38,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _rowInfo("Slot", time),
                  _rowInfo("Status", status),
                  _rowInfo("Time remaining", remaining, isBold: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowInfo(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 13),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardDotBackground extends StatelessWidget {
  const _DashboardDotBackground();
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double headerHeight = mediaQuery.padding.top + 150;
    final double totalHeight =
        headerHeight + (mediaQuery.size.height - headerHeight) / 2.2;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: totalHeight,
      child: Image.asset(
        'assets/background_login.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: _headerBackgroundColor,
          child: Opacity(
            opacity: 0.1,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 20,
              ),
              itemBuilder: (context, index) =>
                  const Icon(Icons.circle, size: 2),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAppHeader extends StatelessWidget {
  const CustomAppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hello Pat !',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 4),
              Row(
                children: const [
                  Icon(Icons.location_on, size: 16, color: Colors.white70),
                  SizedBox(width: 4),
                  Text(
                    'Pondicherry',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 18,
                    color: Colors.white70,
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const notfication()),
              );
            },
            icon: const Icon(
              Icons.notifications_none,
              size: 28,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// ========================== CHAT PAGE CODE (UPDATED) ========================
// ============================================================================

class ChatPageContent extends StatefulWidget {
  const ChatPageContent({super.key});

  @override
  State<ChatPageContent> createState() => _ChatPageContentState();
}

class _ChatPageContentState extends State<ChatPageContent> {
  // View Index:
  // 0: Main Button, 1: Overlay Menu, 2: Parking Form, 3: Private Form, 4: Verification
  int _viewIndex = 0;

  // New Variable to hold the title of the current flow
  String _currentSpotTitle = "Private Spot";

  // Spot Form Image
  File? _imageFile;

  // Verification Images
  File? _landDoc;
  File? _electricBill;
  File? _gasBill;

  final ImagePicker _picker = ImagePicker();

  // --- Controllers ---
  final TextEditingController _locationController = TextEditingController();

  // --- CCTV State ---
  bool _hasCCTV = true;

  // --- Time Availability State ---
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _is24Hours = false;

  final List<String> _allDays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];
  List<String> _selectedDays = [];

  // --- CLEANUP ---
  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  // --- LOGIC: Fetch Location ---
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled.')),
        );
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')),
          );
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are permanently denied.'),
          ),
        );
      }
      return;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fetching current location...'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";

        setState(() {
          _locationController.text = address;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _showMenu() => setState(() => _viewIndex = 1);
  void _hideMenu() => setState(() => _viewIndex = 0);

  // UPDATED: Set the title when selecting the form
  void _showQuasiForm() => setState(() {
        _viewIndex = 2;
        _currentSpotTitle = "Parkinglot Spot";
      });

  // UPDATED: Set the title when selecting the form
  void _showPrivateForm() => setState(() {
        _viewIndex = 3;
        _currentSpotTitle = "Private Spot";
      });

  void _showVerificationScreen() => setState(() => _viewIndex = 4);

  // Spot Form Image Picker
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Verification Screen Image Picker
  Future<void> _pickVerificationImage(String type) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        if (type == 'land') _landDoc = File(pickedFile.path);
        if (type == 'electric') _electricBill = File(pickedFile.path);
        if (type == 'gas') _gasBill = File(pickedFile.path);
      });
    }
  }

  // Verification Validation Logic
  void _validateAndSubmitVerification() {
    // 1. Check Mandatory Land Document
    if (_landDoc == null) {
      _showErrorSnackBar("Land Document is compulsory!");
      return;
    }

    // 2. Check Logic: Either Electric OR Gas must be present
    if (_electricBill == null && _gasBill == null) {
      _showErrorSnackBar("Please upload either Electricity Bill OR Gas Bill.");
      return;
    }

    // 3. Success
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Verification Documents Submitted Successfully!"),
        backgroundColor: Colors.green,
      ),
    );

    // Reset to Home/Dashboard after success
    _hideMenu();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _selectTime(bool isStart) async {
    if (_is24Hours) return;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _accentColor,
              onPrimary: Colors.white,
              surface: _cardColor,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1F22),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMultiSelectDays() async {
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text("Select Days"),
              backgroundColor: const Color(0xFF2A2E33),
              content: SingleChildScrollView(
                child: ListBody(
                  children: _allDays.map((day) {
                    final bool isChecked = _selectedDays.contains(day);
                    return CheckboxListTile(
                      value: isChecked,
                      title: Text(day),
                      activeColor: _accentColor,
                      checkColor: Colors.white,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? checked) {
                        setModalState(() {
                          if (checked == true) {
                            _selectedDays.add(day);
                          } else {
                            _selectedDays.remove(day);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, _selectedDays),
                  child: const Text(
                    "Done",
                    style: TextStyle(color: _accentColor),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (results != null) {
      setState(() {
        _selectedDays = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Column(
            children: [
              if (_viewIndex == 0 || _viewIndex == 1) const CustomAppHeader(),
              Expanded(child: _buildCurrentBody()),
            ],
          ),
        ),
        if (_viewIndex == 1)
          GestureDetector(
            onTap: _hideMenu,
            child: Container(
              color: Colors.black.withOpacity(0.6),
              alignment: Alignment.center,
              child: _buildSpotTypeCard(),
            ),
          ),
      ],
    );
  }

  Widget _buildCurrentBody() {
    switch (_viewIndex) {
      case 2:
        return _buildSpotForm("Parkinglot Spot");
      case 3:
        return _buildSpotForm("Private Spot", isPrivate: true);
      case 4:
        return _buildVerificationBody(); // New Verification Screen
      default:
        return _buildMainBody();
    }
  }

  // --- NEW VERIFICATION BODY ---
  Widget _buildVerificationBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: _showMenu, // Go back to selection or form
              ),
              Text(
                _currentSpotTitle, // UPDATED: Uses variable title
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 48.0, bottom: 30),
            child: Text(
              "Enter the necessary details for verification!",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),

          // 1. Land Document (Compulsory)
          _UploadSection(
            title: "Land document Photos",
            isMandatory: true,
            imageFile: _landDoc,
            onTap: () => _pickVerificationImage('land'),
          ),

          // 2. Electricity Bill (One of these is required)
          _UploadSection(
            title: "Electricity bill Photos",
            imageFile: _electricBill,
            onTap: () => _pickVerificationImage('electric'),
          ),

          // 3. Gas Bill (One of these is required)
          _UploadSection(
            title: "Gas bill Photos",
            imageFile: _gasBill,
            onTap: () => _pickVerificationImage('gas'),
          ),

          // Helper text for the user
          const Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Text(
              "Note: You must submit the Land Document and at least one utility bill (Electricity or Gas).",
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _validateAndSubmitVerification,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _verifyPrimaryBlue, // Using the blue from verification screen
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Next",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpotForm(String title, {bool isPrivate = false}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: _showMenu,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 48.0),
            child: Text(
              "Enter the necessary details for verification!",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          const SizedBox(height: 25),

          _buildFieldLabel("Name the Spot"),
          _buildTextField("Enter name"),

          const SizedBox(height: 20),

          _buildFieldLabel("Upload Photos"),
          _buildUploadBox(),

          const SizedBox(height: 20),

          _buildFieldLabel("Location"),
          _buildTextField(
            "Enter address",
            controller: _locationController,
            suffixIcon: IconButton(
              icon: const Icon(Icons.my_location, color: Colors.black54),
              onPressed: _getCurrentLocation,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildCounterField(
                  isPrivate ? "Length" : "Total Car Spots",
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildCounterField(
                  isPrivate ? "Width" : "Total Bike Spots",
                ),
              ),
            ],
          ),

          if (isPrivate) ...[
            const SizedBox(height: 20),
            _buildFieldLabel("Days"),
            _buildMultiSelectField(),
          ],

          const SizedBox(height: 20),

          // --- TIME SECTION (With Lock Logic) ---
          _buildFieldLabel("Time Availability"),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 2,
                child: Opacity(
                  opacity: _is24Hours ? 0.5 : 1.0,
                  child: _buildClickableTimeField(
                    "From",
                    _startTime,
                    () => _selectTime(true),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Opacity(
                  opacity: _is24Hours ? 0.5 : 1.0,
                  child: _buildClickableTimeField(
                    "To",
                    _endTime,
                    () => _selectTime(false),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    const Text(
                      "24 hrs",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    Checkbox(
                      value: _is24Hours,
                      activeColor: _accentColor,
                      side: const BorderSide(color: Colors.grey),
                      onChanged: (val) {
                        setState(() {
                          _is24Hours = val ?? false;
                          if (_is24Hours) {
                            _startTime = null;
                            _endTime = null;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // --- CCTV SECTION (UPDATED) ---
          _buildCCTVSection(),

          // --- NEW LOCATION FOR DESCRIPTION ---
          const SizedBox(height: 20),
          _buildFieldLabel("Description"),
          _buildTextField("Enter description...", maxLines: 4),

          // ------------------------------------
          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              // CHANGE HERE: On Pressed, go to Verification Screen
              onPressed: _showVerificationScreen,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Next",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UPDATED CCTV SECTION ---
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
                  activeColor: _accentColor,
                  side: const BorderSide(color: Colors.grey),
                  onChanged: (val) => setState(() => _hasCCTV = true),
                ),
                const SizedBox(width: 10),
                const Text("No", style: TextStyle(color: _textGray)),
                Checkbox(
                  value: !_hasCCTV,
                  activeColor: _accentColor,
                  side: const BorderSide(color: Colors.grey),
                  onChanged: (val) => setState(() => _hasCCTV = false),
                ),
              ],
            ),
            // --- ADDED: Verify Link Logic ---
            if (_hasCCTV)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BackgroundHostScreen()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "If yes, ",
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      Text(
                        "verify it",
                        style: TextStyle(
                          color: _accentColor, // Uses global accent color
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(label, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _buildTextField(
    String hint, {
    int maxLines = 1,
    Widget? suffixIcon,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        suffixIcon: suffixIcon,
      ),
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget _buildClickableTimeField(
    String label,
    TimeOfDay? time,
    VoidCallback onTap,
  ) {
    String displayText = "xx";
    if (_is24Hours) {
      displayText = "--:--";
    } else if (time != null) {
      displayText = time.format(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _is24Hours ? null : onTap, // Logic: Lock if 24 hours
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: _is24Hours
                  ? Colors.white.withOpacity(0.3)
                  : Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              displayText,
              style: TextStyle(
                color: _is24Hours ? Colors.black38 : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMultiSelectField() {
    return GestureDetector(
      onTap: _showMultiSelectDays,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _selectedDays.isEmpty
                    ? "Pick your days"
                    : _selectedDays.join(", "),
                style: TextStyle(
                  color: _selectedDays.isEmpty ? Colors.grey : Colors.black,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadBox() {
    return GestureDetector(
      onTap: _showImageSourceOptions,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
          image: _imageFile != null
              ? DecorationImage(
                  image: FileImage(_imageFile!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _imageFile == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white38,
                    size: 30,
                  ),
                  SizedBox(height: 8),
                  Text("Upload photo", style: TextStyle(color: Colors.white38)),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildCounterField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 8),
        _buildTextField("xx"),
      ],
    );
  }

  Widget _buildMainBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _showMenu,
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentColor,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            ),
            child: const Text(
              'Add Spot',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Click to add your spots",
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSpotTypeCard() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F22),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _hideMenu,
              ),
              const Text("Choose Spot Type", style: TextStyle(fontSize: 20)),
            ],
          ),
          const SizedBox(height: 10),
          _buildMenuOption(
            Icons.local_parking,
            "Private Spot",
            onTap: _showPrivateForm,
          ),
          const Divider(color: Colors.white10),
          _buildMenuOption(
            Icons.local_parking,
            "Parkinglot Spot",
            onTap: _showQuasiForm,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption(IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24),
              ),
              child: Icon(icon, size: 18),
            ),
            const SizedBox(width: 15),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 18))),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// ========================== CCTV VERIFICATION SCREENS =======================
// ============================================================================

class BackgroundHostScreen extends StatelessWidget {
  const BackgroundHostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bodyBackgroundColor,
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
      body: Stack(
        children: const [
          _DashboardDotBackground(), // Reused the existing dot background
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