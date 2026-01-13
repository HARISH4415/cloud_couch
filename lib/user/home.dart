import 'package:flutter/material.dart';
import 'package:internpark/user/addvehicledetails.dart';
import 'package:internpark/user/explore.dart';
import 'package:internpark/user/myvehicle.dart';
import 'package:internpark/user/profile.dart';

// --- Define Colors for Consistency ---
const Color _newBodyBackgroundColor = Color(0xFF2A2E33);
const Color _headerBackgroundColor = Color(0xFF21252B);
const Color _accentColor = Color(
  0xFF4C75E5,
); // The Blue for the Radial Gradient

// ------------------------------------------------------------------
// ## UTILITY: Radial Gradient Glow Widget (NEW) 🚗✨
// ------------------------------------------------------------------
class _RadialGradientGlow extends StatelessWidget {
  final double size; // Width and height of the gradient container

  const _RadialGradientGlow({this.size = 300});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Container(
          // This container defines the area where the gradient is drawn
          width: size * 0.8,
          height: size * 0.8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // Using RadialGradient for a perfect central glow effect
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.5, // Controls how quickly it fades out
              colors: [
                _accentColor.withOpacity(0.5), // Center glow (Blue)
                _accentColor.withOpacity(0.0), // Fade out to transparent
              ],
              stops: const [0.0, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// --- Main App Setup ---
// ------------------------------------------------------------------
void main() {
  // NOTE: Ensure 'assets/background_login.png', 'assets/bike.png',
  // and 'assets/car.png' are available in your assets folder.
  runApp(const BottomNavBarApp());
}

class BottomNavBarApp extends StatelessWidget {
  const BottomNavBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehicle Carousel Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: _newBodyBackgroundColor,
        brightness: Brightness.dark,
        primaryColor: _accentColor,
        colorScheme: const ColorScheme.dark(
          primary: _accentColor,
          secondary: _accentColor,
          background: _newBodyBackgroundColor,
        ),
      ),
      home: const NavigationHost(),
    );
  }
}

// ------------------------------------------------------------------
// --- Navigation Host and Main Screen (The main structure) ---
// ------------------------------------------------------------------
class NavigationHost extends StatefulWidget {
  const NavigationHost({super.key});

  @override
  State<NavigationHost> createState() => _NavigationHostState();
}

class _NavigationHostState extends State<NavigationHost> {
  int _selectedIndex = 0;
  bool _isSearching = false;

  final List<String> _vehicleImages = const [
    'assets/car.png',
    'assets/bike.png',
    'assets/car.png',
    'assets/car.png',
    'assets/bike.png',
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      VehicleCarouselPage(
        vehicleImages: _vehicleImages,
        onArrowPressed: () => _onItemTapped(1),
      ),
      // Pass a callback to the Explore page to allow it to change the state
      ExploreScreen(
        onBackToHome: () => _onItemTapped(0),
        onSearchStateChanged: (isSearching) {
          setState(() {
            _isSearching = isSearching;
          });
        },
      ),
      const PlaceholderPage(title: 'Chatbot Interface', color: Colors.blueGrey),
      const PlaceholderPage(title: 'Saved Items', color: Colors.orange),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isSearching = false; // Reset search state when navigating
    });
  }

  Widget _buildCustomBottomNavBar() {
    const Color navBarColor = Color(0xFF444B54);
    final Color unselectedColor = Colors.white.withOpacity(0.5);

    final List<Map<String, dynamic>> items = [
      {'icon': Icons.home_outlined, 'label': 'Home'},
      {'icon': Icons.search_rounded, 'label': 'Explore'},
      {'icon': Icons.receipt_rounded, 'label': ''},
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
            final item = entry.value;
            final isCenterItem = index == 2;

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
                              padding: const EdgeInsets.all(10),
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
                                Icons.chat_bubble,
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
                            size: 24,
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
                            fontWeight: _selectedIndex == index
                                ? FontWeight.bold
                                : FontWeight.normal,
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

  Widget _buildFloatingChatbotIcon() {
    const double iconSize = 24.0;
    const double buttonSize = 56.0;

    return Container(
      width: buttonSize,
      height: buttonSize,
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
      child: IconButton(
        icon: const Icon(Icons.chat, color: Colors.white, size: iconSize),
        onPressed: () => _onItemTapped(2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double navBarHeight = 150.0; //Floating icon height consideration
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // Hide bottom navbar and floating icon when searching
    final bool hideBottomUI = _isSearching;
    final bool showFloatingIcon =
        _selectedIndex == 0 ||
        _selectedIndex == 1; // ithu vanthu floating icon display condition

    return Scaffold(
      backgroundColor: _newBodyBackgroundColor,
      body: Stack(
        children: [
          // 1. Current Page Content
          _pages[_selectedIndex],

          // 2. Bottom Navigation Bar (Hidden when searching)
          if (!hideBottomUI)
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildCustomBottomNavBar(),
            ),

          // 3. Floating Chatbot Icon (Hidden when searching)
          if (showFloatingIcon)
            Positioned(
              right: 20,
              bottom:
                  navBarHeight +
                  bottomPadding -
                  50, //ithu vanthu floating icon oda position
              child: _buildFloatingChatbotIcon(),
            ),
        ],
      ),
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

// ------------------------------------------------------------------
// --- WIDGET: Header ---
// ------------------------------------------------------------------
class _AppBarHeader extends StatelessWidget {
  final bool useBackgroundColor;
  final VoidCallback? onArrowPressed;
  const _AppBarHeader({
    super.key,
    this.useBackgroundColor = true,
    this.onArrowPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: useBackgroundColor ? _headerBackgroundColor : Colors.transparent,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 25,
        left: 30,
        right: 20,
        bottom: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hello Sara !',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Icon(Icons.menu, color: Colors.white, size: 30),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white, size: 20),
              const SizedBox(width: 5),
              const Text(
                'Pondicherry',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w200,
                ),
              ),
              GestureDetector(
                onTap: onArrowPressed,
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            'Pick your vehicle',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// --- WIDGET: Vehicle Carousel Page (Home Screen Content) ---
// ------------------------------------------------------------------
class VehicleCarouselPage extends StatefulWidget {
  final List<String> vehicleImages;
  final VoidCallback? onArrowPressed;

  const VehicleCarouselPage({
    super.key,
    required this.vehicleImages,
    this.onArrowPressed,
  });

  @override
  State<VehicleCarouselPage> createState() => _VehicleCarouselPageState();
}

class _VehicleCarouselPageState extends State<VehicleCarouselPage> {
  late PageController _pageController;
  double _currentPage = 0.0;
  static const int _infinitePageCount = 10000;
  late final int _initialPage;

  static const double carouselHeight = 450;
  static const double imageSize = 400;
  static const Color arrowColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    // Calculate the initial page index to be in the middle of the infinite list
    _initialPage = _infinitePageCount ~/ 2 + 1;

    _pageController = PageController(
      viewportFraction: 0.5,
      initialPage: _initialPage,
    );

    // **FIX STARTS HERE:** Initialize _currentPage with the initial page index.
    // This ensures the custom transformation/opacity logic correctly applies
    // to the center and surrounding pages on the initial build.
    _currentPage = _initialPage.toDouble();
    // **FIX ENDS HERE**

    _pageController.addListener(() {
      // Check for null before assignment, though likely unnecessary after initial load
      if (_pageController.page != null) {
        setState(() {
          _currentPage = _pageController.page!;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Helper to get the actual image index (0, 1, 2, 3, 4...) from the virtual index
  int _getActualIndex(int virtualIndex) {
    return virtualIndex % widget.vehicleImages.length;
  }

  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _goToPreviousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Layer 1: The Stretching Background Image
        const _FullWidthDotBackground(),

        // Layer 2: All the Content (Header, Carousel, Buttons)
        SingleChildScrollView(
          child: Column(
            children: [
              // --- 1. Header (Top part) ---
              _AppBarHeader(
                useBackgroundColor: false,
                onArrowPressed: widget.onArrowPressed,
              ),

              // --- 2. Vehicle Carousel Area (Image Only) ---
              SizedBox(
                height: carouselHeight,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _infinitePageCount,
                  itemBuilder: (context, virtualIndex) {
                    final int actualIndex = _getActualIndex(virtualIndex);

                    // This difference is crucial for the scaling/opacity effect
                    final double difference = (virtualIndex - _currentPage)
                        .abs();
                    final double scale = 1.0 - (difference * 0.3);
                    final double opacity =
                        1.0 - (difference * 0.5).clamp(0.0, 1.0);
                    final double translateY = difference * -15.0;

                    return Transform.scale(
                      scale: scale,
                      child: Transform.translate(
                        offset: Offset(0, translateY),
                        child: Opacity(
                          opacity: opacity,
                          child: _buildVehicleImage(
                            widget.vehicleImages[actualIndex],
                            // Pass a flag to only show glow on the central item
                            showGlow: difference < 0.5,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 1.0),

              // --- 3. Navigation Arrows ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 100.0,
                  vertical: 5.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left Arrow Button
                    GestureDetector(
                      onTap: _goToPreviousPage,
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: arrowColor,
                        size: 30,
                      ),
                    ),

                    // Right Arrow Button
                    GestureDetector(
                      onTap: _goToNextPage,
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: arrowColor,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),

              // --- 4. Bottom Buttons ---
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 'My Vehicle' Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // 1. Get the currently focused image from the carousel
                          final int virtualIndex = _currentPage.round();
                          final int actualIndex = _getActualIndex(virtualIndex);
                          final String currentSelectedImage =
                              widget.vehicleImages[actualIndex];

                          // 2. Define the details map to be shown in MyVehicle
                          final Map<String, String> vehicleDetails = {
                            'model': 'Yamaha MT-07',
                            'plate': 'PY 01 BY 9999',
                            'insurance': 'VIN: XYZ123ABC987DEF',
                          };

                          // 3. Navigate to the MyVehicle page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyVehicle(
                                vehicleImagePath:
                                    currentSelectedImage, // Passes current carousel image
                                details:
                                    vehicleDetails, // Passes the details map
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: _accentColor,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          side: const BorderSide(color: Colors.white, width: 2),
                        ),
                        child: const Text(
                          'My Vehicle',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // 'Proceed' Button (NAVIGATION LOGIC)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // 1. Get the currently selected image asset path
                          final int virtualIndex = _currentPage.round();
                          final int actualIndex = _getActualIndex(virtualIndex);
                          final String selectedVehicleImage =
                              widget.vehicleImages[actualIndex];

                          // 2. Navigate to the new page, passing the image path
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddVehicleDetailsPage(
                                vehicleImagePath: selectedVehicleImage,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accentColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Proceed',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Add padding at the bottom to account for the custom nav bar
              SizedBox(height: MediaQuery.of(context).padding.bottom + 95.0),
            ],
          ),
        ),
      ],
    );
  }

  /// Helper widget to display the vehicle image (with error handling)
  Widget _buildVehicleImage(String imagePath, {bool showGlow = false}) {
    final imageWidget = Image.asset(
      imagePath,
      fit: BoxFit.contain,
      height: imageSize,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 200,
          height: 200,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 40),
              Text('Asset Error', style: TextStyle(color: Colors.red)),
            ],
          ),
        );
      },
    );

    // Add the radial glow only if requested (for the central item)
    if (showGlow) {
      return Stack(
        alignment: Alignment.center,
        children: [
          // Layer 1: The Radial Glow
          _RadialGradientGlow(size: imageSize),
          // Layer 2: The Vehicle Image
          imageWidget,
        ],
      );
    }

    return imageWidget;
  }
}

// ------------------------------------------------------------------
// --- Placeholder Page for Demonstration ---
// ------------------------------------------------------------------
class PlaceholderPage extends StatelessWidget {
  final String title;
  final Color color;

  const PlaceholderPage({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: _newBodyBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, color: color, size: 80),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'This content changes when you tap a button below.',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
