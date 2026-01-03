import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';

/// Service for mapping item names and categories to appropriate icons
class ItemIconService {
  /// Get icon for shopping item based on name and category
  static IconData getShoppingIcon(String name, [String? category]) {
    final lowerName = name.toLowerCase();
    final lowerCategory = category?.toLowerCase() ?? '';

    // Check category first
    if (lowerCategory.contains('fruit') || lowerCategory.contains('vegetable')) {
      return Icons.eco;
    }
    if (lowerCategory.contains('meat') || lowerCategory.contains('protein')) {
      return Icons.set_meal;
    }
    if (lowerCategory.contains('dairy') || lowerCategory.contains('milk')) {
      return Icons.local_drink;
    }
    if (lowerCategory.contains('beverage') || lowerCategory.contains('drink')) {
      return Icons.local_drink;
    }
    if (lowerCategory.contains('snack')) {
      return Icons.cookie;
    }
    if (lowerCategory.contains('cleaning') || lowerCategory.contains('household')) {
      return Icons.cleaning_services;
    }
    if (lowerCategory.contains('personal') || lowerCategory.contains('hygiene')) {
      return Icons.spa;
    }

    // Check item name
    if (lowerName.contains('milk') || lowerName.contains('yogurt') || lowerName.contains('cheese')) {
      return Icons.local_drink;
    }
    if (lowerName.contains('bread') || lowerName.contains('bagel') || lowerName.contains('toast')) {
      return Icons.breakfast_dining;
    }
    if (lowerName.contains('egg')) {
      return Icons.egg;
    }
    if (lowerName.contains('fruit') || lowerName.contains('apple') || lowerName.contains('banana') || 
        lowerName.contains('orange') || lowerName.contains('berry')) {
      return Icons.eco;
    }
    if (lowerName.contains('vegetable') || lowerName.contains('lettuce') || lowerName.contains('tomato') ||
        lowerName.contains('carrot') || lowerName.contains('onion')) {
      return Icons.eco;
    }
    if (lowerName.contains('meat') || lowerName.contains('chicken') || lowerName.contains('beef') ||
        lowerName.contains('pork') || lowerName.contains('fish')) {
      return Icons.set_meal;
    }
    if (lowerName.contains('rice') || lowerName.contains('pasta') || lowerName.contains('noodle')) {
      return Icons.lunch_dining;
    }
    if (lowerName.contains('soap') || lowerName.contains('shampoo') || lowerName.contains('toothpaste') ||
        lowerName.contains('deodorant')) {
      return Icons.spa;
    }
    if (lowerName.contains('detergent') || lowerName.contains('cleaner') || lowerName.contains('paper')) {
      return Icons.cleaning_services;
    }
    if (lowerName.contains('water') || lowerName.contains('juice') || lowerName.contains('soda') ||
        lowerName.contains('coffee') || lowerName.contains('tea')) {
      return Icons.local_drink;
    }

    // Default shopping icon
    return Icons.shopping_bag;
  }

  /// Get icon for drawer item based on name and category
  static IconData getDrawerIcon(String name, [String? category]) {
    final lowerName = name.toLowerCase();
    final lowerCategory = category?.toLowerCase() ?? '';

    // Gym items - fitness icons (FontAwesome)
    if (lowerCategory.contains('gym') || lowerName.contains('gym')) {
      if (lowerName.contains('towel')) return FontAwesomeIcons.droplet;
      if (lowerName.contains('water') || lowerName.contains('bottle')) return FontAwesomeIcons.bottleWater;
      if (lowerName.contains('bag')) return FontAwesomeIcons.bagShopping;
      if (lowerName.contains('shoe')) return FontAwesomeIcons.shoePrints;
      if (lowerName.contains('t-shirt') || lowerName.contains('tshirt')) return FontAwesomeIcons.shirt;
      if (lowerName.contains('short')) return FontAwesomeIcons.shirt;
      if (lowerName.contains('pant') || lowerName.contains('legging')) return FontAwesomeIcons.shirt;
      if (lowerName.contains('sock')) return FontAwesomeIcons.socks;
      return FontAwesomeIcons.dumbbell;
    }

    // Grooming items - personal care icons (FontAwesome)
    if (lowerCategory.contains('grooming') || lowerName.contains('grooming')) {
      if (lowerName.contains('hair') || lowerName.contains('styling')) return FontAwesomeIcons.scissors;
      if (lowerName.contains('shampoo') || lowerName.contains('conditioner')) return FontAwesomeIcons.bottleDroplet;
      if (lowerName.contains('razor') || lowerName.contains('trimmer')) return FontAwesomeIcons.scissors;
      if (lowerName.contains('beard')) return FontAwesomeIcons.user;
      if (lowerName.contains('deodorant')) return FontAwesomeIcons.sprayCan;
      if (lowerName.contains('fragrance') || lowerName.contains('perfume')) return FontAwesomeIcons.sprayCanSparkles;
      if (lowerName.contains('moisturizer') || lowerName.contains('cleanser') || lowerName.contains('spf')) return FontAwesomeIcons.faceSmile;
      if (lowerName.contains('nail')) return FontAwesomeIcons.handSparkles;
      if (lowerName.contains('hand')) return FontAwesomeIcons.hand;
      return FontAwesomeIcons.spa;
    }

    // Sleepwear items (FontAwesome)
    if (lowerCategory.contains('sleepwear') || lowerCategory.contains('sleep')) {
      if (lowerName.contains('robe')) return FontAwesomeIcons.shirt;
      if (lowerName.contains('t-shirt') || lowerName.contains('tshirt')) return FontAwesomeIcons.shirt;
      if (lowerName.contains('short') || lowerName.contains('pant')) return FontAwesomeIcons.shirt;
      return FontAwesomeIcons.moon;
    }

    // Tops/Shirts - more specific icons (FontAwesome)
    if (lowerCategory.contains('shirt') || lowerCategory.contains('top') ||
        lowerName.contains('shirt') || lowerName.contains('t-shirt') || lowerName.contains('tshirt') ||
        lowerName.contains('blouse') || lowerName.contains('top')) {
      if (lowerName.contains('polo') || lowerName.contains('casual')) return FontAwesomeIcons.shirt;
      if (lowerName.contains('dress') || lowerName.contains('oxford')) return FontAwesomeIcons.shirt;
      return FontAwesomeIcons.shirt;
    }

    // Pants - more specific icons (FontAwesome)
    if (lowerCategory.contains('pant') || lowerCategory.contains('trouser') ||
        lowerName.contains('pant') || lowerName.contains('jean') || lowerName.contains('trouser') ||
        lowerName.contains('chino')) {
      if (lowerName.contains('jean')) return FontAwesomeIcons.shirt;
      if (lowerName.contains('dress') || lowerName.contains('trouser')) return FontAwesomeIcons.shirt;
      return FontAwesomeIcons.shirt;
    }

    // Shorts (FontAwesome)
    if (lowerName.contains('short')) {
      return FontAwesomeIcons.shirt;
    }

    // Shoes - walking/running icons (FontAwesome)
    if (lowerCategory.contains('shoe') || lowerCategory.contains('sneaker') ||
        lowerName.contains('shoe') || lowerName.contains('sneaker') || lowerName.contains('boot') ||
        lowerName.contains('sandal')) {
      if (lowerName.contains('sneaker') || lowerName.contains('gym')) return FontAwesomeIcons.shoePrints;
      if (lowerName.contains('smart') || lowerName.contains('dress')) return FontAwesomeIcons.shoePrints;
      return FontAwesomeIcons.shoePrints;
    }

    // Layers/Outerwear (FontAwesome)
    if (lowerCategory.contains('layer') || lowerCategory.contains('jacket') || lowerCategory.contains('coat') ||
        lowerName.contains('jacket') || lowerName.contains('coat') || lowerName.contains('hoodie') ||
        lowerName.contains('sweater') || lowerName.contains('cardigan') || lowerName.contains('blazer')) {
      if (lowerName.contains('blazer') || lowerName.contains('structured')) return FontAwesomeIcons.shirt;
      if (lowerName.contains('hoodie') || lowerName.contains('crewneck')) return FontAwesomeIcons.shirt;
      if (lowerName.contains('coat')) return FontAwesomeIcons.shirt;
      return FontAwesomeIcons.shirt;
    }

    // Underwear (FontAwesome)
    if (lowerCategory.contains('underwear') || lowerName.contains('underwear') || lowerName.contains('bra')) {
      return FontAwesomeIcons.shirt;
    }

    // Socks (FontAwesome)
    if (lowerCategory.contains('sock') || lowerName.contains('sock')) {
      return FontAwesomeIcons.socks;
    }

    // Accessories (FontAwesome)
    if (lowerCategory.contains('accessory') || lowerName.contains('belt') || lowerName.contains('watch') ||
        lowerName.contains('hat') || lowerName.contains('cap') || lowerName.contains('ring') || lowerName.contains('chain')) {
      if (lowerName.contains('watch')) return FontAwesomeIcons.clock;
      if (lowerName.contains('belt')) return Icons.style;
      if (lowerName.contains('hat') || lowerName.contains('cap')) return FontAwesomeIcons.hatCowboy;
      if (lowerName.contains('ring')) return FontAwesomeIcons.ring;
      if (lowerName.contains('chain')) return FontAwesomeIcons.link;
      return FontAwesomeIcons.gem;
    }

    // Default drawer icon
    return FontAwesomeIcons.shirt;
  }

  /// Get color for icon based on category/item type (theme-aware)
  static Color getIconColor(BuildContext context, String? category, [String? name]) {
    final lowerCategory = category?.toLowerCase() ?? '';
    final lowerName = name?.toLowerCase() ?? '';
    final appColors = Theme.of(context).colorScheme.app;
    final colorScheme = Theme.of(context).colorScheme;

    // Shopping items - green/teal tones
    if (lowerCategory.contains('fruit') || lowerCategory.contains('vegetable') || 
        lowerName.contains('fruit') || lowerName.contains('vegetable')) {
      return appColors.shoppingPrimary;
    }
    if (lowerCategory.contains('meat') || lowerName.contains('meat') || lowerName.contains('chicken')) {
      return appColors.error;
    }
    if (lowerCategory.contains('dairy') || lowerName.contains('milk') || lowerName.contains('cheese')) {
      return colorScheme.primary;
    }
    if (lowerCategory.contains('cleaning') || lowerName.contains('detergent') || lowerName.contains('cleaner')) {
      return appColors.info;
    }

    // Drawer items - purple/pink tones
    if (lowerCategory.contains('shirt') || lowerName.contains('shirt') || lowerName.contains('top')) {
      return appColors.drawerPrimary;
    }
    if (lowerCategory.contains('pant') || lowerName.contains('pant') || lowerName.contains('jean')) {
      return appColors.drawerSecondary;
    }
    if (lowerCategory.contains('shoe') || lowerName.contains('shoe') || lowerName.contains('sneaker')) {
      return appColors.planningPrimary;
    }

    // Default
    return colorScheme.onSurfaceVariant;
  }
  
  /// Legacy method for backward compatibility (deprecated)
  @Deprecated('Use getIconColor(context, category, name) instead')
  static Color getIconColorLegacy(String? category, [String? name]) {
    final lowerCategory = category?.toLowerCase() ?? '';
    final lowerName = name?.toLowerCase() ?? '';

    // Shopping items - green/teal tones
    if (lowerCategory.contains('fruit') || lowerCategory.contains('vegetable') || 
        lowerName.contains('fruit') || lowerName.contains('vegetable')) {
      return Colors.green.shade400;
    }
    if (lowerCategory.contains('meat') || lowerName.contains('meat') || lowerName.contains('chicken')) {
      return Colors.red.shade300;
    }
    if (lowerCategory.contains('dairy') || lowerName.contains('milk') || lowerName.contains('cheese')) {
      return Colors.blue.shade300;
    }
    if (lowerCategory.contains('cleaning') || lowerName.contains('detergent') || lowerName.contains('cleaner')) {
      return Colors.blue.shade400;
    }

    // Drawer items - purple/pink tones
    if (lowerCategory.contains('shirt') || lowerName.contains('shirt') || lowerName.contains('top')) {
      return Colors.purple.shade300;
    }
    if (lowerCategory.contains('pant') || lowerName.contains('pant') || lowerName.contains('jean')) {
      return Colors.indigo.shade300;
    }
    if (lowerCategory.contains('shoe') || lowerName.contains('shoe') || lowerName.contains('sneaker')) {
      return Colors.brown.shade300;
    }

    // Default
    return Colors.grey.shade600;
  }
}

