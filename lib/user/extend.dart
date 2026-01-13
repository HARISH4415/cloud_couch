import 'package:flutter/material.dart';

void main() => runApp(
  const MaterialApp(
    home: CheckoutWaitScreen(),
    debugShowCheckedModeBanner: false,
  ),
);

class CheckoutWaitScreen extends StatelessWidget {
  const CheckoutWaitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Dark background for contrast
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'OOPS!!',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Looks like the previous customer\nhasn't checked out.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text:
                          "You can change your spot if you are in hurry, or you  can click on the ",
                    ),
                    TextSpan(
                      text: '"I can wait"',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: " button if you can wait for sometime"),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Spot Selection Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSpotButton("1 min away"),
                  _buildSpotButton("1 min away"),
                  _buildSpotButton("1 min away"),
                ],
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "View 5 more spots >",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Main Blue Button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4F7FDD), // Blue
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "I can wait",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 25),
              const Text(
                "By changing spot, your currently paid amount will be refunded\nin 3-5 working days",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build the grey spot buttons
  Widget _buildSpotButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}
