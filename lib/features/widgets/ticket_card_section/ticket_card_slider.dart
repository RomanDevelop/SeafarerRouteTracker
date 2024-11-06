import 'package:flutter/material.dart';

class TicketCardSlider extends StatelessWidget {
  const TicketCardSlider({super.key, required this.imageUrls});
  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect rect) {
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.grey,
            Colors.transparent,
            Colors.transparent,
            Colors.grey,
          ],
          stops: [0.0, 0.1, 0.9, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: SizedBox(
        height: 250,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          scrollDirection: Axis.horizontal,
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: 160,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: Image.asset(
                          // Заменили Image.network на Image.asset
                          imageUrls[index], // Путь к локальному изображению
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'NFT Ship',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.monetization_on, size: 16),
                                Text(' 57.0 SCT')
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
