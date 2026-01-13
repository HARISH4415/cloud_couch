import 'package:flutter/material.dart';

// --- Colors ---
const Color _newBodyBackgroundColor = Color(0xFF2A2E33);
const Color _headerBackgroundColor = Color(0xFF21252B);
const Color _cardBackgroundColor = Color(0xFF383C41);
const Color _accentColor = Color(0xFF6C63FF);

void main() {
  runApp(const FullScreenBackgroundApp());
}

class FullScreenBackgroundApp extends StatelessWidget {
  const FullScreenBackgroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: _newBodyBackgroundColor,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: const History(),
    );
  }
}

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Booked spots'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 79, 127, 221),
          elevation: 8,
          child: const Icon(Icons.chat, color: Colors.white, size: 30),
          onPressed: () {},
        ),
      ),

      body: Stack(
        children: [
          const _FullWidthDotBackground(),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
                    child: Text(
                      "Open",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const ParkingCard(
                    title: "Freeway Park Garage",
                    distance: "125 m",
                    time: "Approx. 1 min",
                    price: "50/hr",
                    spaces: "12 Available",
                    imageUrl: 'https://images.unsplash.com/photo-1506521781263-d8422e82f27a?q=80&w=400',
                  ),

                  const SizedBox(height: 30),

                  const Padding(
                    padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
                    child: Text(
                      "Closed",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Opacity(
                    opacity: 0.4,
                    child: const ParkingCard(
                      title: "Freeway Park Garage",
                      distance: "125 m",
                      time: "Approx. 1 min",
                      price: "50/hr",
                      spaces: "12 Available",
                      imageUrl: 'https://images.unsplash.com/photo-1506521781263-d8422e82f27a?q=80&w=400',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ParkingCard extends StatelessWidget {
  final String title;
  final String distance;
  final String time;
  final String price;
  final String spaces;
  final String imageUrl;

  const ParkingCard({
    super.key,
    required this.title,
    required this.distance,
    required this.time,
    required this.price,
    required this.spaces,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 60, 62, 64),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        // Centering alignment: Vertically aligns the image and the text block
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [
          // 1. Garage Image (Centered in Row)
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              imageUrl,
              width: 100, // Slightly adjusted for better balance
              height: 85,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 100,
                height: 85,
                color: Colors.grey[800],
                child: const Icon(Icons.image, color: Colors.white24),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // 2. Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white54),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(distance, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    const Spacer(),
                    Text(time, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildDetailItem("Price", "₹$price"),
                    const SizedBox(width: 24),
                    _buildDetailItem("Space", spaces),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white54)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
      ],
    );
  }
}

class _FullWidthDotBackground extends StatelessWidget {
  const _FullWidthDotBackground();
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double headerHeight = mediaQuery.padding.top + 150;
    final double totalHeight = headerHeight + (mediaQuery.size.height - headerHeight) / 2;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: totalHeight,
      child: Image.asset(
        'assets/background_login.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(color: _headerBackgroundColor),
      ),
    );
  }
}