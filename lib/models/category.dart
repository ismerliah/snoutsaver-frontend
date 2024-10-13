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
      icon: convertIcon(json['id'], json['icon']),
    );
  }

  // Function to convert category id or icon name to IconData
  static IconData convertIcon(int categoryId, String? iconName) {
    if (iconName != null && iconName.isNotEmpty) {
      return _convertIconName(iconName);
    }

    return _getIconFromCategoryId(categoryId);
  }

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

  static IconData _getIconFromCategoryId(int categoryId) {
    final Map<int, IconData> categoryIdMap = {
      1: Icons.business_center_rounded,
      2: Icons.card_giftcard_rounded,
      3: Icons.monetization_on_rounded,
      4: Icons.account_balance_rounded,
      5: Icons.more_horiz_rounded,
      6: Icons.fastfood_rounded,
      7: Icons.train_rounded,
      8: Icons.shopping_cart_rounded,
      9: Icons.home_rounded,
      10: Icons.receipt_long_rounded,
      11: Icons.music_note_rounded,
      12: Icons.school_rounded,
      13: Icons.medical_services_rounded,
    };

    return categoryIdMap[categoryId] ?? Icons.category_rounded;
  }
}
