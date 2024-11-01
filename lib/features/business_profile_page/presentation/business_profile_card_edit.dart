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
                  'https://images.unsplash.com/photo-1523294002435-91467ed2ccda?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fHNoaXB8ZW58MHx8MHx8fDA%3D',
                  'https://plus.unsplash.com/premium_photo-1661884720911-91cd3f823298?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzN8fHNoaXB8ZW58MHx8MHx8fDA%3D',
                  'https://images.unsplash.com/photo-1444487233259-dae9d907a740?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzZ8fHNoaXB8ZW58MHx8MHx8fDA%3D',
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
                tokenAmount: '10 SCT',
              ),
            ),
            const SizedBox(height: 10),
            const MoreCard(
              title: 'Sell Your NFTs',
              tokenAmount: '20 SCT',
            ),
          ],
        ),
      ),
    );
  }
}
