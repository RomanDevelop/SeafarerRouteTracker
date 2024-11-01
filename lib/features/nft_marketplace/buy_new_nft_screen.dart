import 'package:flutter/material.dart';

class BuyNewNFTsScreen extends StatelessWidget {
  const BuyNewNFTsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy New NFTs'),
      ),
      // ignore: prefer_const_constructors
      body: Center(
        child: const Text(
          'NFT Mirco Marketplace',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
