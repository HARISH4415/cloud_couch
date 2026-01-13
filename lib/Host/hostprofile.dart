import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// --- Define Colors for Consistency ---
const Color _newBodyBackgroundColor = Color(0xFF2A2E33);
const Color _headerBackgroundColor = Color(0xFF21252B);
const Color _accentBlue = Color(0xFF4C75E5);
const Color _cardBorderColor = Colors.white12;

void main() {
  runApp(const ParkingApp());
}

class ParkingApp extends StatelessWidget {
  const ParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: _newBodyBackgroundColor,
        brightness: Brightness.dark,
        primaryColor: _accentBlue,
        fontFamily: 'sans-serif',
      ),
      home: const NavigationHost(),
    );
  }
}

// ------------------------------------------------------------------
// --- Navigation Host ---
// ------------------------------------------------------------------
class NavigationHost extends StatefulWidget {
  const NavigationHost({super.key});

  @override
  State<NavigationHost> createState() => _NavigationHostState();
}

class _NavigationHostState extends State<NavigationHost> {
  int _selectedIndex = 4;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const PlaceholderPage(title: 'Home Screen', icon: Icons.home_outlined),
      const PlaceholderPage(
        title: 'Explore Screen',
        icon: Icons.search_rounded,
      ),
      const PlaceholderPage(title: 'Receipts', icon: Icons.receipt_long),
      const PlaceholderPage(title: 'Saved Items', icon: Icons.bookmark_border),
      const Hostprofile(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _selectedIndex, children: _pages),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildCustomBottomNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomBottomNavBar() {
    const Color navBarColor = Color(0xFF444B54);
    final List<Map<String, dynamic>> items = [
      {'icon': Icons.home_outlined, 'label': 'Home'},
      {'icon': Icons.search_rounded, 'label': 'Explore'},
      {'icon': Icons.receipt_long, 'label': 'Receipts'},
      {'icon': Icons.bookmark_border, 'label': 'Saved'},
      {'icon': Icons.person_outline, 'label': 'Profile'},
    ];

    return Container(
      color: navBarColor,
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final isSelected = _selectedIndex == index;

            return GestureDetector(
              onTap: () => _onItemTapped(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      entry.value['icon'],
                      color: isSelected ? _accentBlue : Colors.white54,
                    ),
                    Text(
                      entry.value['label'],
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? _accentBlue : Colors.white54,
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

// ------------------------------------------------------------------
// --- Profile Screen Implementation ---
// ------------------------------------------------------------------
class Hostprofile extends StatefulWidget {
  const Hostprofile({super.key});

  @override
  State<Hostprofile> createState() => _HostprofileState();
}

class _HostprofileState extends State<Hostprofile> {
  bool _isEditing = false;
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _FullWidthDotBackground(),
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        if (_isEditing) setState(() => _isEditing = false);
                      },
                    ),
                    Text(
                      _isEditing ? 'Edit Profile' : 'Profile',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.mode_edit_rounded,
                        size: 28,
                        color: Colors.white,
                      ),
                      onPressed: () => setState(() => _isEditing = !_isEditing),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: _isEditing ? _buildEditBody() : _buildProfileBody(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileBody() {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildAvatar(isEditing: false),
        const SizedBox(height: 16),
        const Text(
          'Pat',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Text(
          'cloudcouch@gmail.com',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 40),

        // --- Updated Group 1 based on Image ---
        _buildSettingsGroup([
          _buildListTile('My spots'),
          _buildListTile('History'),
          _buildListTile('Change bank details'),
          _buildListTile('Book your spot', showDivider: false),
        ]),

        const SizedBox(height: 20),

        // --- Updated Group 2 based on Image ---
        _buildSettingsGroup([
          _buildListTile('Language'),
          _buildListTile('Terms and policy'),
          _buildListTile('Logout', showDivider: false),
        ]),
        const SizedBox(height: 120),
      ],
    );
  }

  Widget _buildEditBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildAvatar(isEditing: true),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _showPicker(context),
            child: const Text(
              'Change photo',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          const SizedBox(height: 30),
          _buildEditField('Name', 'Enter your name'),
          const SizedBox(height: 20),
          _buildEditField('Mobile number', 'Enter your Mobile number'),
          const SizedBox(height: 20),
          _buildEditField('Email', 'Enter your Email'),
          const SizedBox(height: 40),
          Center(
            child: SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () => setState(() => _isEditing = false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Change password?',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 150),
        ],
      ),
    );
  }

  Widget _buildAvatar({required bool isEditing}) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
      ),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey,
        backgroundImage: _image != null ? FileImage(_image!) : null,
        child: _image == null
            ? const Icon(Icons.person, size: 60, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildEditField(String label, String hint) {
    return Column(
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
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsGroup(List<Widget> tiles) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF21252B).withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: _cardBorderColor),
      ),
      child: Column(children: tiles),
    );
  }

  Widget _buildListTile(String title, {bool showDivider = true}) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.white54),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: _cardBorderColor,
          ),
      ],
    );
  }
}

// ------------------------------------------------------------------
// --- Utilities ---
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
        'assets/background_login.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Container(color: _headerBackgroundColor),
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;
  const PlaceholderPage({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: _accentBlue),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
