import 'package:flutter/material.dart';

// --- Define Colors for Consistency ---
const Color _newBodyBackgroundColor = Color(0xFF2A2E33);
const Color _headerBackgroundColor = Color(0xFF21252B);

void main() {
  runApp(const FullScreenBackgroundApp());
}

class FullScreenBackgroundApp extends StatelessWidget {
  const FullScreenBackgroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking Confirmation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: _newBodyBackgroundColor,
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
      ),
      home: const BackgroundHostScreen(),
    );
  }
}

// ------------------------------------------------------------------
// --- Host Screen: Merged Background & Ticket Details ---
// ------------------------------------------------------------------
class BackgroundHostScreen extends StatelessWidget {
  const BackgroundHostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          true, // Allows the background image to show behind AppBar
      backgroundColor: _newBodyBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: const Text(
          'Summary',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, size: 35, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // 1. Background Layer
          const _FullWidthDotBackground(),

          // 2. Content Layer
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20,
              ),
              child: Column(
                children: [_buildTicketCard(), const SizedBox(height: 30)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget: The White Ticket Card ---
  Widget _buildTicketCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Upper Part: Location and Logistics
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        'https://img.freepik.com/premium-photo/full-frame-shot-parking-lot_1048944-23630625.jpg?semt=ais_hybrid&w=740&q=80',
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Freeway Park Garage',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.grey,
                              ),
                              Text(
                                ' 125m',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _infoRow('Vehicle', 'Speedster x (B 1234 XY)'),
                _infoRow('Parking spot', '2nd Floor (B-3)'),
                _infoRow('Date', 'November 10, 2025'),
                _infoRow('Duration', '4 Hours'),
                _infoRow('Start', '09:00 AM', isBoldValue: true),
                _infoRow('End', '13:00 PM', isBoldValue: true),
                _infoRow('Checked In', '09:12 AM', isBoldValue: true),
                _infoRow('Checked Out', '12:47 PM', isBoldValue: true),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '----------------------------------------',
              style: TextStyle(color: Colors.grey, letterSpacing: 4),
              maxLines: 1,
            ),
          ),

          // Lower Part: Payment Details
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              children: [
                _infoRow(
                  'Amount Paid',
                  '₹400.00',
                  fontSize: 18,
                  isBoldValue: true,
                ),
                _infoRow('Status', 'On-time', isBoldValue: true, fontSize: 18),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Color(0xFF5D5C5C),
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(text: 'Penality '),
                          TextSpan(
                            text: '(₹10 per 10 min)',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      '₹400.00',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
    String label,
    String value, {
    bool isBoldValue = false,
    double fontSize = 16,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF5D5C5C),
              fontSize: fontSize,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isBoldValue ? const Color(0xFF21252B) : Colors.black,
              fontWeight: isBoldValue ? FontWeight.bold : FontWeight.w500,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// --- WIDGET: Stretching Background Image ---
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
        errorBuilder: (context, error, stackTrace) {
          return Container(color: _headerBackgroundColor);
        },
      ),
    );
  }
}
