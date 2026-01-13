import 'package:flutter/material.dart';
import 'package:internpark/Host/main.dart';

// --- Define Colors for Consistency ---
const Color _newBodyBackgroundColor = Color(0xFF2A2E33);
const Color _headerBackgroundColor = Color(0xFF21252B);
const Color _accentBlue = Color(0xFF4F7FDD);

void main() {
  runApp(const notfication());
}

class notfication extends StatelessWidget {
  const notfication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notifications UI',
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

class BackgroundHostScreen extends StatelessWidget {
  const BackgroundHostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: 
            (context) => const Hostpage()));
          },
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background
          const _FullWidthDotBackground(),

          // Notifications Content
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                const SizedBox(height: 10),
                _buildSectionHeader('Today'),
                
                // 1. Michelle
                const _NotificationItem(
                  imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=60', // Placeholder for Michelle
                  title: 'Michelle has booked your spot from',
                  subTitle: '11:00 to 13:00',
                  time: '8:01am',
                  isActionable: true, // Makes subtitle blue
                ),

                // 2. Annie
                const _NotificationItem(
                  imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&auto=format&fit=crop&q=60', // Placeholder for Annie
                  title: 'Annie has requested your spot from',
                  subTitle: '9:00 to 11:00',
                  time: '8:01am',
                  isActionable: true, // Makes subtitle blue
                ),

                const SizedBox(height: 30),
                _buildSectionHeader('Yesterday'),

                // 3. Darren
                const _NotificationItem(
                  imageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&auto=format&fit=crop&q=60', // Placeholder for Darren
                  title: 'Darren has booked your spot from',
                  subTitle: '9:00 to 11:00',
                  time: '8:01am',
                  isActionable: true, // Makes subtitle blue
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, left: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// --- WIDGET: Notification List Item (Updated for Avatars) ---
// ------------------------------------------------------------------
class _NotificationItem extends StatelessWidget {
  final String imageUrl; // Changed from IconData to String URL
  final String title;
  final String? subTitle;
  final String time;
  final bool isActionable;
  final bool isLast;

  const _NotificationItem({
    required this.imageUrl,
    required this.title,
    this.subTitle,
    required this.time,
    this.isActionable = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Image
              CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage(imageUrl),
                backgroundColor: Colors.grey.shade800,
              ),
              const SizedBox(width: 16),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                      ),
                    ),
                    if (subTitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subTitle!,
                        style: TextStyle(
                          color: isActionable ? _accentBlue : Colors.white70,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.grey, 
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(color: Colors.white12, thickness: 1, height: 1),
      ],
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