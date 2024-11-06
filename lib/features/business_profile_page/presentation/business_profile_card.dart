import 'package:flutter/material.dart';
import 'package:route_tracking/features/business_profile_page/presentation/business_profile_card_edit.dart';
import 'package:route_tracking/features/business_profile_page/presentation/ship_model.dart';

class BusinessProfileCard extends StatelessWidget {
  final BusinessProfile profile;

  const BusinessProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BusinessProfileCardEdit(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xffF3F3F3),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 5),
          ],
        ),
        child: Column(
          children: [
            Image.network(
              profile.nftShipUrl,
              height: 120,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/ship_nft.png', // Путь к локальному изображению
                  height: 120,
                );
              },
            ),
            Text(
              profile.nftShipName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.currency_bitcoin),
                    Text(' ${profile.balance.toStringAsFixed(2)} SCAI'),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.power,
                      color: Colors.grey,
                    ),
                    Text(' ${profile.coefficientPower.toStringAsFixed(1)}x'),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.directions_boat,
                      color: Colors.grey,
                    ),
                    Text(' ${profile.nauticalMile.toStringAsFixed(1)} NM'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
