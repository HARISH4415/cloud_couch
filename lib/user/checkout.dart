import 'package:flutter/material.dart';

const Color _newBodyBackgroundColor = Color(0xFF2A2E33);
const Color _headerBackgroundColor = Color(0xFF21252B);
const Color _accentBlue = Color(0xFF5584E2);

void main() {
  runApp(const FullScreenBackgroundApp());
}

class FullScreenBackgroundApp extends StatelessWidget {
  const FullScreenBackgroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking Summary Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: _newBodyBackgroundColor,
        brightness: Brightness.dark,
        fontFamily: 'sans-serif',
      ),
      home: const BackgroundHostScreen(),
    );
  }
}

class BackgroundHostScreen extends StatelessWidget {
  const BackgroundHostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _newBodyBackgroundColor,
      body: Stack(
        children: [
          const _FullWidthDotBackground(),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // --- Header Area ---
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Summary',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Updated Summary Card with Timer ---
                  const SummaryCard(),

                  const SizedBox(height: 5),

                  const CheckinCard(),

                  const SizedBox(height: 20),

                  // --- Scan QR Button ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 90.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accentBlue,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Scan QR',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top section: Garage details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  'https://images.unsplash.com/photo-1506521781263-d8422e82f27a?q=80&w=200',
                  width: 100,
                  height: 100,
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
                        color: Color(0xFF333D47),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Color(0xFF333D47),
                        ),
                        Text(
                          ' 125m',
                          style: TextStyle(color: Color(0xFF333D47)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Navigate to spot button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Navigate to spot',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // --- New Section: Time Remaining ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Time remaining',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                '03:21',
                style: TextStyle(
                  color: Color(0xFF333D47),
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CheckinCard extends StatelessWidget {
  const CheckinCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Checkin QR',
            style: TextStyle(
              color: Color(0xFF333D47),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade100, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.network(
                'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=CheckinExampleData',
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Scan this QR to check in',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ],
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
          return Container(color: _headerBackgroundColor);
        },
      ),
    );
  }
}
