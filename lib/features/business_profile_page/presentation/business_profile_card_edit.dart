import 'package:flutter/material.dart';
import 'package:route_tracking/features/business_profile_page/presentation/more_card.dart';
import 'package:route_tracking/features/nft_marketplace/buy_new_nft_screen.dart';
import 'package:route_tracking/features/widgets/ticket_card_section/ticket_card_slider.dart';

class BusinessProfileCardEdit extends StatelessWidget {
  const BusinessProfileCardEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFT Marketplace'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок для коллекции картинок
            const Center(
              child: Text(
                'My NFT Collection',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10), // Отступ между заголовком и слайдером
            // Слайдер изображений
            const SizedBox(
              height: 200,
              child: TicketCardSlider(
                imageUrls: [
                  'assets/ship_nft_1.png', // Локальный путь к изображению
                  'assets/ship_nft_2.png',
                  'assets/ship_nft_3.png',
                ],
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BuyNewNFTsScreen(),
                  ),
                );
              },
              child: const MoreCard(
                title: 'Buy New NFTs',
                tokenAmount: '3.0 SCAI',
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BuyNewNFTsScreen(),
                  ),
                );
              },
              child: const MoreCard(
                title: 'Sell Your NFTs',
                tokenAmount: '5.0 SCAI',
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BuyNewNFTsScreen(),
                  ),
                );
              },
              child: const MoreCard(
                title: 'Exchange & Withdrawals',
                tokenAmount: '100.0 SCAI',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
