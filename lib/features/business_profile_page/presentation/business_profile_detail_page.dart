import 'package:flutter/material.dart';
import 'package:route_tracking/features/business_profile_page/presentation/more_card.dart';
import 'package:route_tracking/features/business_profile_page/presentation/business_profile_card.dart';
import 'package:route_tracking/features/business_profile_page/presentation/ship_model.dart';
import 'package:route_tracking/features/business_profile_page/presentation/tokenomics_screen.dart';
import 'package:route_tracking/features/route_tracking/presentation/route_tracking_screen.dart';

class BusinessProfileDetailsPage extends StatefulWidget {
  final BusinessProfile profile;

  const BusinessProfileDetailsPage({super.key, required this.profile});

  @override
  State<BusinessProfileDetailsPage> createState() =>
      _BusinessProfileDetailsPageState();
}

class _BusinessProfileDetailsPageState extends State<BusinessProfileDetailsPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);

    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(_controller!)
      ..addListener(() {
        setState(() {});
      });

    _controller!.forward();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Profile'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.currency_bitcoin),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const TokenomicsScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          BusinessProfileCard(
              profile: BusinessProfile(
                  balance: widget.profile.balance,
                  nftShipName: widget.profile.nftShipName,
                  nftShipUrl: widget.profile.nftShipUrl,
                  coefficientPower: widget.profile.coefficientPower,
                  nauticalMile: widget.profile.nauticalMile)),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xffF3F3F3),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/user.png'),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Alex Karpenko',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.account_balance_wallet,
                              size: 16,
                            ),
                            Text(
                              ' 9.90 SCAI',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RouteTrackingScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Transform.scale(
                          scale: _animation!.value,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/maps.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: const Column(
              children: [
                MoreCard(
                  title: 'Create Post — Earn Tokens',
                  tokenAmount: '21.5 SCAI',
                ),
                SizedBox(height: 5),
                MoreCard(
                  title: 'Company Feedback for Tokens',
                  tokenAmount: '55.2 SCAI',
                ),
                SizedBox(height: 5),
                MoreCard(
                  title: 'Tokens for Shoreline Adventures',
                  tokenAmount: '34.7 SCAI',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
