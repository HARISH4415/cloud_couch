import 'package:flutter/material.dart';
import 'package:internpark/details1.dart';
import 'package:internpark/explore.dart';
import 'package:intl/intl.dart'; // Required for date formatting

// --- Define Colors for Consistency ---
const Color _newBodyBackgroundColor = Color(0xFF2A2E33); // Dark Gray Background
const Color _headerBackgroundColor = Color(
  0xFF21252B,
); // Fallback/Dark Header Background
const Color _cardBackgroundColor = Color(
  0xFF3B4147,
); // Input Field Background Color
const Color _primaryBlue = Color(0xFF5A7BE9); // Search Button Blue

// ------------------------------------------------------------------
// --- Main App Setup ---
// ------------------------------------------------------------------
void main() {
  // NOTE: Ensure 'assets/background_login.png' is available in your assets folder.
  runApp(const BookApp());
}

class BookApp extends StatelessWidget {
  const BookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Screen UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Set the main background color for Scaffolds
        scaffoldBackgroundColor: _newBodyBackgroundColor,
        brightness: Brightness.dark,
        // Define the default style for all text inputs
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: _cardBackgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide.none, // Hide default border
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 14.0,
          ),
          hintStyle: TextStyle(color: Colors.white70),
        ),
      ),
      // Set the home to the screen that displays the background and UI
      home: const BookScreen(),
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
        // IMPORTANT: Replace with your actual dotted background image path
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
// --- UI Screen: BookScreen (Content Layer) ---
// ------------------------------------------------------------------
class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  // 1. State variables for date range
  DateTime _startDate = DateTime(2025, 10, 1);
  DateTime _endDate = DateTime(2025, 10, 3);
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');

  // 2. State variables for time range
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0); // 08:00
  TimeOfDay _endTime = const TimeOfDay(hour: 23, minute: 0); // 23:00

  // --- Date Picker Method (CORRECTED for White Background) ---
  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (BuildContext context, Widget? child) {
        // FIX: Use a LIGHT theme as the base for a white calendar background.
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  _primaryBlue, // Blue color for highlights (selected date/range)
              onPrimary: Colors
                  .white, // Text color on primary (text inside blue circle)
              surface: Colors.white, // Calendar picker body background
              onSurface: Colors
                  .black87, // Text color on surface (unselected dates, day names)
            ),
            dialogBackgroundColor:
                Colors.white, // Background of the dialog itself
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: _primaryBlue,
              ), // OK/Cancel button color
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked.start != _startDate) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  // --- Time Picker Method ---
  Future<void> _selectTime(bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
      builder: (BuildContext context, Widget? child) {
        // We'll keep the dark theme for the time picker as it usually looks better
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: _primaryBlue,
              onPrimary: Colors.white,
              surface: _cardBackgroundColor,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: _newBodyBackgroundColor,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: _primaryBlue),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  // --- Widget Builders ---

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Back Button
        GestureDetector(
          onTap: () {
            // Pop the current screen to go back to the previous page
            Navigator.push(context, MaterialPageRoute(builder:  (context) => ParkingApp()));
          },
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 15),
        // Title
        const Text(
          'Book',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSearch() {
    return const TextField(
      style: TextStyle(
        color: Colors.black,
      ), // Ensure text is visible on white background
      decoration: InputDecoration(
        hintText: 'Location',
        fillColor: Color.fromARGB(255, 255, 255, 255),
        filled: true,
        hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.mic, color: Color.fromARGB(179, 2, 1, 1)),
              const SizedBox(width: 10),
              Icon(Icons.search, color: Color.fromARGB(179, 2, 1, 1)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressInput() {
    return const TextField(
      style: TextStyle(
        color: Colors.black,
      ), // Ensure text is visible on white background
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 24.0, // <-- Increased height here
        ),
        fillColor: Color.fromARGB(
          255,
          169,
          164,
          164,
        ), // Use explicit white color
        filled: true,
        hintStyle: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
        ), // Black hint text
        hintText: 'Enter your address',
      ),
    );
  }

  Widget _buildDateInput() {
    // Format the dates for display
    String dateRangeText =
        '${_dateFormat.format(_startDate)} - ${_dateFormat.format(_endDate)}';

    return GestureDetector(
      onTap: _selectDateRange, // Call the date picker function on tap
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateRangeText, // Use the state variable
              style: const TextStyle(color: Color(0xFF676767), fontSize: 16),
            ),
            const Icon(
              Icons.calendar_today,
              color: Color(0xFF676767),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // MODIFIED to use interactive TimeBoxes
  Widget _buildTimingInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text('From', style: TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(width: 15),
        _buildTimeBox(_startTime, isStartTime: true),
        const SizedBox(width: 30),
        const Text('To', style: TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(width: 15),
        _buildTimeBox(_endTime, isStartTime: false),
      ],
    );
  }

  // MODIFIED to take TimeOfDay and be interactive
  Widget _buildTimeBox(TimeOfDay time, {required bool isStartTime}) {
    return GestureDetector(
      onTap: () =>
          _selectTime(isStartTime), // Call the time picker function on tap
      child: Container(
        width: 90, // Fixed width for the time box
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(10.0),
        ),
        alignment: Alignment.center,
        child: Text(
          time.format(context), // Format TimeOfDay for display (e.g., 08:00 AM)
          style: const TextStyle(color: Color(0xFF676767), fontSize: 16),
        ),
      ),
    );
  }

  // MODIFIED: Uses Center and a smaller Container/SizedBox to reduce width.
  Widget _buildSearchButton() {
    // Determine a smaller width, e.g., 60% of the screen width
    const double desiredWidthFactor = 0.6;

    return Center(
      // Center the button horizontally
      child: SizedBox(
        width: MediaQuery.of(context).size.width * desiredWidthFactor,
        height: 55,
        child: ElevatedButton(
          onPressed: () {
            // Handle search action
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Search action placeholder')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90.0),
            ),
            elevation: 5,
            // Ensure the button fills its container
            minimumSize: const Size.fromHeight(55),
          ),
          child: const Center(
            child: Text(
              'Search',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Build Method for the Stateful Widget ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Layer (Fixed)
          const _FullWidthDotBackground(),

          // 2. Content Layer (Scrollable)
          SafeArea(
            child: SingleChildScrollView(
              // Dismiss the keyboard when the user starts scrolling
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header Row ---
                  _buildHeader(context),
                  const SizedBox(height: 30),

                  // --- Location/Search Input ---
                  _buildLocationSearch(),
                  const SizedBox(height: 30),

                  // --- Address Input ---
                  const Text(
                    'Address',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildAddressInput(),
                  const SizedBox(height: 30),

                  // --- Date Input (Interactive) ---
                  const Text(
                    'Day',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildDateInput(),
                  const SizedBox(height: 40),

                  // --- Timing Input (Interactive) ---
                  const Text(
                    'Timing',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTimingInput(),

                  // --- Search Button (part of the scrollable content) ---
                  const SizedBox(height: 250), // Space before the button
                  _buildSearchButton(),
                  const SizedBox(
                    height: 40,
                  ), // Space after the button for padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
