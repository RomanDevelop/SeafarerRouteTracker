import 'package:flutter/material.dart';

class MoreCard extends StatelessWidget {
  final String title;
  final String tokenAmount;

  const MoreCard({
    super.key,
    required this.title,
    required this.tokenAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff212020),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.monetization_on,
                      color: Colors.white, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    tokenAmount,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.power, color: Colors.white, size: 16),
                  const SizedBox(width: 5),
                  const Text('1.0x',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                  const SizedBox(width: 10),
                  const Icon(Icons.navigation, color: Colors.white, size: 16),
                  const SizedBox(width: 5),
                ],
              ),
            ],
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 24),
        ],
      ),
    );
  }
}
