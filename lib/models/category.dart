import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final String type;
  final IconData icon;

  Category({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      icon: _convertIconName(json['icon']),
    );
  }

  // Function to convert icon name to IconData
  static IconData _convertIconName(String iconName) {
    final Map<String, IconData> iconMap = {
      'business_center_rounded': Icons.business_center_rounded,
      'card_giftcard_rounded': Icons.card_giftcard_rounded,
      'monetization_on_rounded': Icons.monetization_on_rounded,
      'account_balance_rounded': Icons.account_balance_rounded,
      'more_horiz_rounded': Icons.more_horiz_rounded,
      'fastfood_rounded': Icons.fastfood_rounded,
      'train_rounded': Icons.train_rounded,
      'shopping_cart_rounded': Icons.shopping_cart_rounded,
      'home_rounded': Icons.home_rounded,
      'receipt_long_rounded': Icons.receipt_long_rounded,
      'music_note_rounded': Icons.music_note_rounded,
      'school_rounded': Icons.school_rounded,
      'medical_services_rounded': Icons.medical_services_rounded,
    };

    return iconMap[iconName] ?? Icons.category_rounded;
  }
}