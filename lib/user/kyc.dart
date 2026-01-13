import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// --- Theme Colors ---
const Color _backgroundColor = Color(0xFF2A2E33); 
const Color _inputFillColor = Color(0xFFF5F7FA);
const Color _primaryBlue = Color(0xFF5D87E6);
const Color _labelColor = Colors.white70;
const Color _headerFallbackColor = Color(0xFF21252B);

void main() {
  runApp(const DetailsApp());
}

class DetailsApp extends StatelessWidget {
  const DetailsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _backgroundColor,
      ),
      home: const DetailsScreen(),
    );
  }
}

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library, color: _primaryBlue),
                title: const Text('Upload from Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: _primaryBlue),
                title: const Text('Capture with Camera'),
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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      // Prevents the layout from moving when the keyboard opens
      resizeToAvoidBottomInset: false, 
      body: Stack(
        children: [
          const _FullWidthDotBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 29.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _buildInputField("Aadhar number", "XXXX XXXX XXXX"),
                        const SizedBox(height: 20),

                        const Text(
                          "Verify Photo",
                          style: TextStyle(color: _labelColor, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        _buildPhotoUploadBox(),

                        const SizedBox(height: 20),
                        _buildInputField("Bank account name", "Indian Bank"),
                        const SizedBox(height: 20),
                        _buildInputField("Account holder name", "Sara"),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: _buildInputField(
                                "Bank account number",
                                "XXXXXXXXXX",
                                isTall: true,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildInputField(
                                "IFSC code",
                                "XXXXXXXXXX",
                                isTall: true,
                              ),
                            ),
                          ],
                        ),
                        // Pushes the button to the bottom of the screen
                        const Spacer(), 
                        _buildNextButton(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.maybePop(context),
          ),
          const Text(
            'Details',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String hint, {bool isTall = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _labelColor, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: _inputFillColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: isTall ? 30 : 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoUploadBox() {
    return GestureDetector(
      onTap: _showPickerOptions,
      child: Container(
        width: double.infinity,
        height: 200, // Slightly reduced to ensure it fits on more screens
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24, width: 1),
          color: Colors.white.withOpacity(0.05),
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_selectedImage!, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white.withOpacity(0.3),
                    size: 36,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Click to upload or capture",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: const Text(
          "Next",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

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
          return Container(color: _headerFallbackColor);
        },
      ),
    );
  }
}