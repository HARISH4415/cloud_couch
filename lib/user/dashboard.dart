import 'package:flutter/material.dart';

// --- Theme Colors ---
const Color _backgroundColor = Color(0xFF2A2E33); // The Grey background for the bottom half
const Color _cardColor = Color(0xFF3E4247);
const Color _primaryBlue = Color(0xFF5D87E6);
const Color _headerBackgroundColor = Color(0xFF21252B);

void main() {
  runApp(const DashboardApp());
}

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _backgroundColor,
        fontFamily: 'sans-serif',
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Function to handle navigation tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      // --- Standardized Bottom Navigation Bar ---
      bottomNavigationBar: _buildBottomNav(),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: _primaryBlue,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      
      body: Stack(
        children: [
          // 1. Partial Background Layer
          const _FullWidthDotBackground(),

          // 2. Scrollable Content Layer
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildHeader(),
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
                  _buildHorizontalList(),
                  const SizedBox(height: 30),
                  
                  const Divider(color: Colors.white24, thickness: 1.5),
                  const SizedBox(height: 20),

                  _buildSlotCard(
                    "Parking slot 1",
                    "10:00 to 12:00",
                    "Checked in",
                    "01:21",
                    "https://images.unsplash.com/photo-1506521781263-d8422e82f27a?q=80&w=400",
                  ),
                  _buildSlotCard(
                    "Parking slot 1",
                    "08:00 to 10:00",
                    "Checked out",
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
                    "Parking slot 1",
                    "08:00 to 10:00",
                    "Checked out",
                    "--",
                    "https://images.unsplash.com/photo-1573348722427-f1d6819fdf98?q=80&w=400",
                  ),
                  const SizedBox(height: 100), // Space to see background behind Nav
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hello Sara !', style: TextStyle(fontSize: 16, color: Colors.white70)),
            const SizedBox(height: 4),
            Row(
              children: const [
                Icon(Icons.location_on, size: 16, color: Colors.white70),
                SizedBox(width: 4),
                Text('Pondicherry', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Icon(Icons.keyboard_arrow_right, size: 18, color: Colors.white70),
              ],
            ),
          ],
        ),
        const Icon(Icons.menu, size: 28),
      ],
    );
  }

  Widget _buildHorizontalList() {
    return SizedBox(
      height: 130,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1545179605-1296651e9d43?q=80&w=400'),
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
                        Text('Parking slot 1 ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                        Icon(Icons.edit, size: 12, color: Colors.white),
                      ],
                    ),
                  ),
                ],
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

  Widget _buildSlotCard(String title, String time, String status, String remaining, String imageUrl) {
    return Container(
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
            child: Image.network(imageUrl, width: 85, height: 85, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white38),
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
    );
  }

  Widget _rowInfo(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 13)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: Colors.white)),
        ],
      ),
    );
  }

  // --- Updated Bottom Navigation Bar Implementation ---
  Widget _buildBottomNav() {
    return BottomAppBar(
      color: const Color(0xFF21252B),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Dashboard Button
            GestureDetector(
              onTap: () => _onItemTapped(0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                   Icons.home_outlined,
                    color: _selectedIndex == 0 ? _primaryBlue : Colors.white38,
                  ),
                  Text(
                    "Dashboard",
                    style: TextStyle(
                      fontSize: 12,
                      color: _selectedIndex == 0 ? _primaryBlue : Colors.white38,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40), // Gap for the FloatingActionButton
            // Profile Button
            GestureDetector(
              onTap: () => _onItemTapped(1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_outline,
                    color: _selectedIndex == 1 ? _primaryBlue : Colors.white38,
                  ),
                  Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 12,
                      color: _selectedIndex == 1 ? _primaryBlue : Colors.white38,
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
}

class _FullWidthDotBackground extends StatelessWidget {
  const _FullWidthDotBackground();
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double headerHeight = mediaQuery.padding.top + 150;
    // Calculation ensures image ends roughly halfway down the screen
    final double totalHeight = headerHeight + (mediaQuery.size.height - headerHeight) / 2.2;

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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 20),
              itemBuilder: (context, index) => const Icon(Icons.circle, size: 2),
            ),
          ),
        ),
      ),
    );
  }
}