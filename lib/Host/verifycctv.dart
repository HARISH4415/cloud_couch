import 'package:flutter/material.dart';

// --- Define Colors for Consistency ---
const Color _newBodyBackgroundColor = Color(0xFF2A2E33);
const Color _primaryBlue = Color(
  0xFF5486E0,
); // Color matched from the "Verify" button
const Color _containerColor = Color(
  0xFF353A40,
); // Darker grey for the upload box

// ------------------------------------------------------------------
// --- Main App Setup ---
// ------------------------------------------------------------------
void main() {
  runApp(const FullScreenBackgroundApp());
}

class FullScreenBackgroundApp extends StatelessWidget {
  const FullScreenBackgroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verify CCTV Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: _newBodyBackgroundColor,
        brightness: Brightness.dark,
        fontFamily: 'Roboto', // Default standard font
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

    // Original logic: Height = (Status Bar Padding + 150) + (Remaining Screen Height / 2)
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
          // Fallback to a solid gradient or color if asset is missing
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.5),
                  _newBodyBackgroundColor,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ------------------------------------------------------------------
// --- Host Screen: Displays background + Content ---
// ------------------------------------------------------------------
class BackgroundHostScreen extends StatelessWidget {
  const BackgroundHostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _newBodyBackgroundColor,
      // Using extendBodyBehindAppBar allows the background image to go behind the app bar area
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Handle back navigation
          },
        ),
        title: const Text(
          "Verify CCTV",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: const Stack(
        children: [
          // 1. Background Layer
          _FullWidthDotBackground(),

          // 2. Content Layer
          SafeArea(child: VerifyCCTVContent()),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// --- WIDGET: The Specific Form Content ---
// ------------------------------------------------------------------
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
          // Instructions Header
          const Text(
            "Instructions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          // Instructions Body
          const Text(
            "Please upload your CCTV present recording with geotag and timestamp. Any variation with the image uploaded or footage of any different time will fail to be verified. So follow this instruction to get it verified.",
            style: TextStyle(fontSize: 14, height: 1.4, color: Colors.white70),
          ),

          const SizedBox(height: 30),

          // Upload Container (Dark Box)
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _containerColor,
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

          // Selected File Display (White Box)
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
                  onTap: () {
                    // Handle remove file
                  },
                  child: const Icon(Icons.close, color: Colors.black87),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          // Sub-note
          const Text(
            "(Once verified, you'll be notified and your spot will be open for CCTV availability)",
            style: TextStyle(fontSize: 12, color: Colors.white60),
          ),

          const SizedBox(height: 50),

          // Verify Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryBlue,
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

          // Footer Disclaimer
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
