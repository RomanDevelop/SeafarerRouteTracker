import 'package:flutter/material.dart';

class TokenomicsScreen extends StatelessWidget {
  const TokenomicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFE0E5EC),
        title: Row(
          children: [
            Icon(Icons.pie_chart, color: Colors.grey[700]), // Неоморфная иконка
            const SizedBox(width: 8),
            Text(
              'Tokenomics of the Project',
              style: TextStyle(
                  color: Colors.grey[700], fontWeight: FontWeight.bold),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.grey[700]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildNeomorphicBox(
                  child: Text(
                    'Tokenomics of the Project: SCAI (Seamen\'s Club AI Hub Token)',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800]),
                  ),
                ),
                const SizedBox(height: 20),
                buildNeomorphicBox(
                  child: buildSection(
                    'Token Name: SCAI',
                    'SCAI is the internal currency used to reward users for active participation and task completion within the Seamen\'s Club AI Hub ecosystem. The token can be exchanged for miles and unique NFT assets for withdrawal to cryptocurrency wallets, as well as used for project-specific products and services.',
                  ),
                ),
                const SizedBox(height: 20),
                buildNeomorphicBox(
                  child: buildSection(
                    'Token Issuance',
                    '- Maximum Supply: 500 million SCAI\n- Planned Duration Before Market Release: 249 years\n- Planned Market Entry: After 249 years, at which point the ecosystem will be fully developed and capable of sustaining stable demand.',
                  ),
                ),
                const SizedBox(height: 20),
                buildNeomorphicBox(
                  child: buildSection(
                    'Token Allocation',
                    '- 40% (200 million) — Rewards for user activities.\n- 35% (175 million) — Project fund reserve for scaling and development.\n- 20% (100 million) — Team and developer allocation.\n- 5% (25 million) — Marketing and user acquisition initiatives.',
                  ),
                ),
                const SizedBox(height: 20),
                buildNeomorphicBox(
                  child: buildSection(
                    'Token Utility',
                    'SCAI can be used for miles exchange, NFT marketplace, club products and services, and VPN services. To maintain the token\'s value, a portion of SCAI tokens used for VPN access will be burned.',
                  ),
                ),
                const SizedBox(height: 20),
                buildNeomorphicBox(
                  child: buildSection(
                    'Incentives and Rewards',
                    'Activity rewards are given for completing tasks and bringing in new participants. Regular users receive bonus tokens and exclusive ecosystem privileges.',
                  ),
                ),
                const SizedBox(height: 20),
                buildNeomorphicBox(
                  child: buildSection(
                    'Inflation Control Mechanisms',
                    'Limited supply and token burn mechanisms help sustain long-term value.',
                  ),
                ),
                const SizedBox(height: 20),
                buildNeomorphicBox(
                  child: buildSection(
                    'Plans for Market Entry',
                    'After the 249-year development period, the project will enter cryptocurrency exchanges, backed by a stable ecosystem.',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Функция для создания неоморфного контейнера
  Widget buildNeomorphicBox({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E5EC),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            offset: Offset(-5, -5),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.black12,
            offset: Offset(5, 5),
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }

  // Функция для создания секции с заголовком и текстом
  Widget buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800]),
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: TextStyle(fontSize: 16, height: 1.5, color: Colors.grey[700]),
        ),
      ],
    );
  }
}
