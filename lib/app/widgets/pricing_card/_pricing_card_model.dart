part of '_pricing_card.dart';

class PricingCardModel {
  final IconData? icon;
  final String planName;
  final String? planDescription;
  final double planPrice;
  final double? discountPrice;
  final String subscriptionType;
  final Map<String, bool> features;

  const PricingCardModel({
    this.icon,
    required this.planName,
    this.planDescription,
    required this.planPrice,
    this.discountPrice,
    required this.subscriptionType,
    required this.features,
  });
}
