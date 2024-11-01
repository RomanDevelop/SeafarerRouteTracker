import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_tracking/features/business_profile_page/presentation/business_profile_detail_page.dart';
import 'package:route_tracking/features/business_profile_page/presentation/ship_model.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Пример данных для BusinessProfile
    BusinessProfile profile = BusinessProfile(
      balance: 9.99,
      nftShipName: 'NFT UHL FLAIR',
      nftShipUrl:
          'https://images.unsplash.com/photo-1474224348275-dd142b14f8c1?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTh8fHNoaXB8ZW58MHx8MHx8fDA%3D',
      coefficientPower: 1.0,
      nauticalMile: 0.0,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Route Tracking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BusinessProfileDetailsPage(
        profile: profile,
      ),
    );
  }
}
