import 'package:flutter/material.dart';

// --- Shared Colors ---
const Color _bodyBackgroundColor = Color(0xFF2A2E33);
const Color _headerBackgroundColor = Color(0xFF21252B);
const Color _accentBlue = Color(0xFF539DF3);
const Color _valueColor = Colors.white;

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: QRScannerScreen(), // App starts here
  ));
}

// ==========================================
// 1. QR SCANNER SCREEN (New UI)
// ==========================================
class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // A. Fake Camera Background
          // In a real app, the MobileScanner widget would go here
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF111111), // Dark placeholder for camera
            child: Center(
              child: Icon(
                Icons.camera_alt_outlined, 
                size: 80, 
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),

          // B. Scanner Overlay (The Frame)
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: _accentBlue, width: 3),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _accentBlue.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  )
                ]
              ),
              child: Stack(
                children: [
                  // Animated line simulation (static for UI demo)
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 2,
                      width: 260,
                      color: Colors.red.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // C. Top Controls (Back Button & Title)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.pop(context);
                    }, // Handle close
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Scan QR Code",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48), // Balance row
                ],
              ),
            ),
          ),

          // D. Bottom Instructions & Trigger Button
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  "Align QR code within the frame",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 30),
                
                // This button simulates a successful scan
                ElevatedButton.icon(
                  onPressed: () {
                    // NAVIGATE TO USER STATUS SCREEN
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserStatusScreen()),
                    );
                  },
                  icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                  label: const Text("Simulate Scan", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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

// ==========================================
// 2. YOUR ORIGINAL USER STATUS SCREEN
// ==========================================
class UserStatusScreen extends StatelessWidget {
  const UserStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bodyBackgroundColor,
      body: Stack(
        children: [
          // 1. Status Specific Background
          const _StatusPageBackground(),

          // 2. Foreground Content Layer
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Navigation Back
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    // --- NAVIGATE BACK ---
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Digital Clock
                const Center(
                  child: Text(
                    "01 : 21",
                    style: TextStyle(
                      fontSize: 90,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2,
                      color: Colors.white, // Ensure text is visible
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // User Name
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    "Ramesh",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.1,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                // Information Grid/List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      _buildDataRow("Slot", "1:00 pm to 4:00 pm"),
                      _buildDataRow("Status", "Checked In"),
                      _buildDataRow("Check in time", "10:02"),
                      _buildDataRow("Penalty", "₹ 0.0"),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Communication Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(Icons.notifications_sharp),
                    _buildActionButton(Icons.chat_bubble_rounded),
                    _buildActionButton(Icons.phone_rounded),
                  ],
                ),

                const Spacer(),

                // Legal Disclaimer
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35.0),
                  child: Text(
                    "Disclaimer: You must contact or notify the user only on emergency cases. Unnecessary contact can be considered as violation and actions will be taken",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widget: Info Row ---
  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 18,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: _valueColor,
              fontSize: 17,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widget: Action Button ---
  Widget _buildActionButton(IconData icon) {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        color: _accentBlue,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 26),
    );
  }
}

class _StatusPageBackground extends StatelessWidget {
  const _StatusPageBackground();

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
          return Container(color: _headerBackgroundColor);
        },
      ),
    );
  }
}