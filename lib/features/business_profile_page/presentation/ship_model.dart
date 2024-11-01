class BusinessProfile {
  final double balance;
  final String nftShipName;
  final String nftShipUrl;
  final double coefficientPower;
  final double nauticalMile;

  BusinessProfile({
    required this.balance,
    required this.nftShipName,
    required this.nftShipUrl,
    required this.coefficientPower,
    required this.nauticalMile,
  });

  factory BusinessProfile.fromMap(Map<String, dynamic> map) {
    return BusinessProfile(
      balance: (map['balance'] as num).toDouble(),
      nftShipName: map['nftShipName'],
      nftShipUrl: map['nftShipUrl'],
      coefficientPower: (map['coefficientPower'] as num?)?.toDouble() ?? 1.0,
      nauticalMile: (map['nauticalMile'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
