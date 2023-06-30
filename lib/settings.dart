import 'package:flutter/material.dart';
import 'package:puckjs_app/one_tap.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Customize the functions for each tap',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 10),
                RoundedOptionButton(
                  text: 'Single tap',
                  onPressed: () {
                    Navigator.push( //this navigates to the screen after pressing the button
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => const Onetap()));
                    // TODO: Handle single tap functionality
                  },
                ),
                const SizedBox(height: 20),
                RoundedOptionButton(
                  text: 'Double tap',
                  onPressed: () {
                    // TODO: Handle double tap functionality
                  },
                ),
                const SizedBox(height: 20),
                RoundedOptionButton(
                  text: 'Continuous tap',
                  onPressed: () {
                    // TODO: Handle continuous tap functionality
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedOptionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const RoundedOptionButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1A22),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          alignment: Alignment.centerRight,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
