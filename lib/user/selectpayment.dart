import 'package:flutter/material.dart';

// --- Define Colors for Consistency ---
const Color _newBodyBackgroundColor = Color(0xFF2A2E33);
const Color _headerBackgroundColor = Color(0xFF21252B);
const Color _cardFillColor = Color(0xFF1E2126);
const Color _inputFillColor = Color(0xFFFFFFFF);
const Color _buttonColor = Color(0xFF5D8BF4);

void main() {
  runApp(const FullScreenBackgroundApp());
}

class FullScreenBackgroundApp extends StatelessWidget {
  const FullScreenBackgroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment UI Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: _newBodyBackgroundColor,
        brightness: Brightness.dark,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: PaymentFormCard(),
                  ),
                  const SizedBox(height: 25),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "Select Payment",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: PaymentMethodList(),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {},
          ),
          const Text(
            'Payment',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// --- WIDGET: Select Payment List with Local Image Assets ---
// ------------------------------------------------------------------
class PaymentMethodList extends StatelessWidget {
  const PaymentMethodList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPaymentItem(
          title: "PayPal",
          imagePath: 'assets/paypal.png', // Change to your filename
        ),
        const SizedBox(height: 12),
        _buildPaymentItem(
          title: "MasterCard",
          imagePath: 'assets/mastercard.png', // Change to your filename
        ),
      ],
    );
  }

  Widget _buildPaymentItem({
    required String title,
    required String imagePath,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 30,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Image.asset(
              imagePath, 
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.white),
            ),
          ),
          const SizedBox(width: 15),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// --- WIDGET: The Credit Card Input Form ---
// ------------------------------------------------------------------
class PaymentFormCard extends StatelessWidget {
  const PaymentFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 42, 46, 51).withOpacity(0.9),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Add Credit card",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 25),
          _buildLabel("Card Holder Name"),
          _buildTextField(hint: "John Doe", suffixIcon: Icons.person_outline),
          const SizedBox(height: 20),
          _buildLabel("Card Number"),
          _buildTextField(hint: "xxxx xxxx xxxx xxxx"),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Expiry Date"),
                    _buildTextField(hint: "01/01"),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("CVV"),
                    _buildTextField(hint: "xxx"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Center(
            child: SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Proceed",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0, left: 4),
    child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 13)),
  );

  Widget _buildTextField({required String hint, IconData? suffixIcon}) =>
      TextField(
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          fillColor: _inputFillColor,
          filled: true,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.grey) : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      );
}

class _FullWidthDotBackground extends StatelessWidget {
  const _FullWidthDotBackground();
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double headerHeight = mediaQuery.padding.top + 150;
    final double totalHeight = headerHeight + (mediaQuery.size.height - headerHeight) / 2;
    return Positioned(
      top: 0, left: 0, right: 0, height: totalHeight,
      child: Image.asset(
        'assets/background_login.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(color: _headerBackgroundColor),
      ),
    );
  }
}