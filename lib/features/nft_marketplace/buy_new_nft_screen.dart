import 'package:flutter/material.dart';

class BuyNewNFTsScreen extends StatelessWidget {
  const BuyNewNFTsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy New NFTs'),
      ),
      body: const Center(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 16.0), // Обрезка по горизонтали
          child: Text(
            'Insufficient funds for purchases. Your account must have at least 100 SCT.',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center, // Выравнивание по центру
          ),
        ),
      ),
    );
  }
}
