import 'package:flutter/material.dart';
import 'package:internpark/book.dart';
import 'package:internpark/details1.dart';
import 'package:internpark/home.dart';

// ------------------------------------------------------------------
// --- Define Colors for Consistency (Combined from both snippets) ---
// ------------------------------------------------------------------
const Color _newBodyBackgroundColor = Color(
  0xFF2A2E33,
); // Main dark background (visible below image)
const Color _headerBackgroundColor = Color(
  0xFF21252B,
); // Darker header/search bar (fallback for image)
const Color _onPrimaryColor = Colors.white; // Text/Icon color
const Color _sheetBackgroundColor = Color(
  0xFF383838,
); // Dark grey background for the bottom sheet
const Color _accentBlue = Color(
  0xFF4285F4,
); // Google Blue, used for primary accent
const Color _inactiveGrey = Color(0xFF707070); // Used for inactive text/icons
const Color _cardBackgroundColor = Color(
  0xFF383838,
); // Dark grey background for the card
const Color _heartRed = Color(0xFFFF4D4D); // Red for the heart icon

// ------------------------------------------------------------------
// --- Main App Setup: Uses Navigator for Routing ---
// ------------------------------------------------------------------
void main() {
  // NOTE: Ensure 'assets/background_login.png' is available in your assets folder.
  // If not available, the fallback color will be used in ExploreScreen.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking App Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // The default background color for all Scaffolds is set here
        scaffoldBackgroundColor: _newBodyBackgroundColor,
        brightness: Brightness.dark,
        // Apply custom slider theme globally
        sliderTheme: SliderThemeData(
          activeTrackColor: _accentBlue,
          inactiveTrackColor: _inactiveGrey.withOpacity(0.5),
          thumbColor: _accentBlue,
          overlayColor: _accentBlue.withOpacity(0.2),
          valueIndicatorColor: _accentBlue,
          showValueIndicator: ShowValueIndicator.never,
        ),
      ),
      // Start with the main screen that contains the BottomNavBar
      home: ExploreScreen(onBackToHome: () {}, onSearchStateChanged: (bool ) {  },),
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
    // Calculate the partial height for the image background
    final double totalHeight =
        headerHeight + (mediaQuery.size.height - headerHeight) / 2;

    // The Positioned widget explicitly sets the calculated height,
    // achieving the requested partial-screen size.
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: totalHeight,
      child: Image.asset(
        'assets/background_login.png',
        fit: BoxFit.cover, // Ensures the image covers the set area
        errorBuilder: (context, error, stackTrace) {
          // Fallback to a solid background color if the asset is missing
          return Container(color: _headerBackgroundColor);
        },
      ),
    );
  }
}

// ------------------------------------------------------------------
// --- WIDGET: ExploreScreen (Host screen for content and filter) ---
// ------------------------------------------------------------------
class ExploreScreen extends StatefulWidget {
  // Required constructor parameter signature kept for compatibility
  final void Function() onBackToHome;
  final Function(bool) onSearchStateChanged;

  const ExploreScreen({
    super.key,
    required this.onBackToHome,
    required this.onSearchStateChanged,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {

  void _setSearching(bool value) {
    setState(() {
    });
    // Notify parent about search state change
    widget.onSearchStateChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    const double kToolbarHeight = 56.0;

    // This Scaffold is the new route, ensuring BottomNavBar/FAB are hidden
    return Scaffold(
      // *** FIX APPLIED HERE: Prevents the Scaffold from resizing when the keyboard is active,
      // which stops the underlying NavigationHost from being exposed. ***
      resizeToAvoidBottomInset: false,

      // *** ADDED: Container with fixed background color to cover entire screen ***
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: _newBodyBackgroundColor, // Background color for entire screen
        child: Stack(
          children: [
            // 1. Background Image Layer
            const _FullWidthDotBackground(),

            // 2. Foreground Content Layer (Scrollable)
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Custom Header (Replaces AppBar) ---
                      Container(
                        // IMPORTANT: Set color to be transparent to show the image/background layer
                        color: Colors.transparent,
                        padding: EdgeInsets.only(
                          top: statusBarHeight,
                          left: 16.0,
                          right: 16.0,
                          bottom: 8.0,
                        ),
                        height: statusBarHeight + kToolbarHeight,
                        child: Row(
                          children: [
                            // Left Arrow Icon (Back Button)
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: _onPrimaryColor,
                              ),
                              onPressed: () {
                                widget.onBackToHome();
                              },
                            ),

                            // "Explore" Title (Left-aligned)
                            const Text(
                              'Explore',
                              style: TextStyle(
                                color: _onPrimaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.menu,
                                color: _onPrimaryColor,
                                size: 28,
                              ),
                              onPressed: () {
                                // Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),

                      // --- "Parking nearby" and Filter Icon ---
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25.0,
                          vertical: 16.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Parking nearby',
                              style: TextStyle(
                                color: _onPrimaryColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Filter Icon - UPDATED onPressed
                            IconButton(
                              icon: const Icon(
                                Icons.filter_list,
                                color: _onPrimaryColor,
                                size: 28,
                              ),
                              onPressed: () {
                                // Calls the bottom sheet, which will appear over this full-screen route.
                                _showFilterSheet(context);
                              },
                            ),
                          ],
                        ),
                      ),

                      // --- Search Bar ---
                      _CustomSearchBar(onSearchStateChanged: _setSearching),

                      // --- Parking Details Card (NEW WIDGET ADDED HERE) ---
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: _ParkingDetailsCard(),
                      ),

                      // --- Empty Space / List Items Area (Still uses a large SizedBox) ---
                      // This creates the scroll area over the background image.
                      const SizedBox(height: 700),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// --- WIDGET: Parking Details Card (NEW) ---
// ------------------------------------------------------------------
class _ParkingDetailsCard extends StatelessWidget {
  const _ParkingDetailsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 97, 97, 97),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 69, 67, 67).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Side: Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: SizedBox(
              width: 100,
              height: 100,
              // Using a placeholder image for demonstration. Replace with actual asset or NetworkImage.
              child: Image.asset(
                'assets/parking_garage.png', // Replace with your image path
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to a solid color if the asset is missing
                  // You can also use a generic icon here if desired
                  return Container(
                    color: _headerBackgroundColor,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.directions_car,
                      color: Color(0xFF616161),
                      size: 40,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12.0),

          // Middle Section: Text Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  'Freeway Park Garage',
                  style: TextStyle(
                    color: _onPrimaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8.0),

                // Location/Distance/Time
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_sharp,
                      color: Color.fromARGB(255, 141, 133, 133),
                      size: 16,
                    ),
                    const SizedBox(width: 4.0),
                    const Text(
                      '125 m',
                      style: TextStyle(
                        color: Color.fromARGB(255, 198, 196, 196),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    const Text(
                      'Approx. 1 min',
                      style: TextStyle(
                        color: Color.fromARGB(255, 198, 196, 196),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),

                // Price/Space
                Row(
                  children: [
                    // Price
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price',
                          style: TextStyle(
                            color: Color.fromARGB(255, 198, 196, 196),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '₹50/hr',
                          style: TextStyle(
                            color: _onPrimaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 30.0),
                    // Space
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Space',
                          style: TextStyle(
                            color: Color.fromARGB(255, 198, 196, 196),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '12 Available',
                          style: TextStyle(
                            color: _onPrimaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right Side: Heart Icon
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Icon(Icons.favorite, color: _heartRed, size: 28),
          ),
          
          // Arrow Icon (from image) - WRAPPED IN GestureDetector
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ParkingDetailScreen(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(top: 4.0, left: 8.0),
              child: Icon(
                Icons.chevron_right,
                color: Color.fromARGB(
                  255,
                  198,
                  196,
                  196,
                ), // Matches the text color
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// --- WIDGET: Custom Search Bar (Updated to track search state) ---
// ------------------------------------------------------------------
class _CustomSearchBar extends StatefulWidget {
  final Function(bool) onSearchStateChanged;

  const _CustomSearchBar({required this.onSearchStateChanged});

  @override
  State<_CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<_CustomSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Notify parent when search text changes
    widget.onSearchStateChanged(_controller.text.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: _headerBackgroundColor,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        style: const TextStyle(color: _onPrimaryColor),
        decoration: const InputDecoration(
          hintText: 'Search for parking, streets, or areas...',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// --- Helper Function to Show Bottom Sheet (Unchanged) ---
// ------------------------------------------------------------------

void _showFilterSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return const _FilterBottomSheet();
    },
  );
}

// ------------------------------------------------------------------
// --- WIDGET: Filter Bottom Sheet (With Security Fix) ---
// ------------------------------------------------------------------

class _FilterBottomSheet extends StatefulWidget {
  const _FilterBottomSheet();

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  RangeValues _priceRange = const RangeValues(30, 150);
  String _selectedSortBy = 'Popular';
  // Initial state for CCTV: true (Yes is selected)
  bool _cctvEnabled = true;
  int _selectedRating = 5;

  Widget _buildSortButton(String text) {
    final bool isSelected = _selectedSortBy == text;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: OutlinedButton(
          onPressed: () {
            setState(() {
              _selectedSortBy = text;
            });
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: isSelected ? _accentBlue : _onPrimaryColor,
            foregroundColor: isSelected ? _onPrimaryColor : _onPrimaryColor,
            side: BorderSide(
              color: isSelected ? _accentBlue : Colors.transparent,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected
                  ? _onPrimaryColor
                  : const Color.fromARGB(207, 0, 0, 0),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingButton(int rating) {
    final bool isSelected = _selectedRating == rating;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: OutlinedButton(
          onPressed: () {
            setState(() {
              _selectedRating = rating;
            });
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: isSelected ? _accentBlue : _onPrimaryColor,
            foregroundColor: isSelected ? _onPrimaryColor : _onPrimaryColor,
            side: BorderSide(color: isSelected ? _accentBlue : _inactiveGrey),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                color: isSelected ? _onPrimaryColor : _inactiveGrey,
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                '$rating',
                style: TextStyle(
                  color: isSelected
                      ? _onPrimaryColor
                      : const Color.fromARGB(255, 70, 69, 69),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: _sheetBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Filter',
            style: TextStyle(
              color: _onPrimaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // --- Price Range Section ---
          const Text(
            'Price Range',
            style: TextStyle(
              color: _onPrimaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 200,
            divisions: null,
            activeColor: const Color.fromARGB(255, 79, 127, 223),
            labels: RangeLabels(
              '₹${_priceRange.start.round()}',
              '₹${_priceRange.end.round()}',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _priceRange = values;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${_priceRange.start.round()}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 172, 168, 168),
                  ),
                ),
                Text(
                  '₹${_priceRange.end.round()}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 172, 168, 168),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- Sort By Section ---
          const Text(
            'Sort by',
            style: TextStyle(
              color: _onPrimaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildSortButton('Most recent'),
              _buildSortButton('Popular'),
              _buildSortButton('Low to High'),
            ],
          ),
          const SizedBox(height: 24),

          // --- Security Section (FIXED LOGIC) ---
          const Text(
            'Security',
            style: TextStyle(
              color: _onPrimaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Must have CCTV coverage?',
                style: TextStyle(color: Color.fromARGB(255, 172, 168, 168)),
              ),
              const Spacer(),

              // Yes Checkbox
              Checkbox(
                value: _cctvEnabled,
                onChanged: (bool? value) {
                  setState(() {
                    _cctvEnabled = value ?? false;
                  });
                },
                checkColor: _onPrimaryColor,
                // FIX: Only apply accent blue when selected, otherwise use inactive grey
                fillColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return _accentBlue;
                  }
                  return const Color.fromARGB(255, 255, 255, 255);
                }),
              ),
              // FIX: Use conditional styling for the label text
              Text(
                'Yes',
                style: TextStyle(
                  color: _cctvEnabled ? _accentBlue : _onPrimaryColor,
                ),
              ),
              const SizedBox(width: 16),

              // No Checkbox
              Checkbox(
                value: !_cctvEnabled,
                onChanged: (bool? value) {
                  setState(() {
                    _cctvEnabled = !(value ?? true);
                  });
                },
                checkColor: _onPrimaryColor,
                // FIX: Only apply accent blue when selected, otherwise use inactive grey
                fillColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return _accentBlue;
                  }
                  return const Color.fromARGB(255, 255, 255, 255);
                }),
              ),
              // FIX: Use conditional styling for the label text
              Text(
                'No',
                style: TextStyle(
                  color: !_cctvEnabled ? _accentBlue : _onPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // --- Rating Section ---
          const Text(
            'Rating',
            style: TextStyle(
              color: _onPrimaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildRatingButton(2),
              _buildRatingButton(3),
              _buildRatingButton(4),
              _buildRatingButton(5),
            ],
          ),
          const SizedBox(height: 30),

          // --- Apply Filter Button ---
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the bottom sheet
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentBlue,
                  foregroundColor: _onPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Apply filter',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
