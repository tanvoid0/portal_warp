import 'dart:convert';

/// Service for generating image URLs
/// Uses Picsum Photos (free, no API key required, reliable service)
class UnsplashService {
  /// Base URL for Picsum Photos
  static const String _baseUrl = 'https://picsum.photos';

  /// Generate a seed number from keywords for consistent images
  static int _getSeedFromKeywords(String keywords) {
    // Hash the keywords to get a consistent seed
    final bytes = utf8.encode(keywords);
    int hash = 0;
    for (final byte in bytes) {
      hash = ((hash << 5) - hash) + byte;
      hash = hash & hash; // Convert to 32-bit integer
    }
    // Ensure positive number and use modulo to keep it reasonable
    return hash.abs() % 1000;
  }

  /// Generate URL for card background images
  /// [width] and [height] in pixels
  /// [keywords] comma-separated search keywords (used to generate consistent seed)
  static String getCardImageUrl({
    int width = 400,
    int height = 300,
    required String keywords,
  }) {
    final seed = _getSeedFromKeywords(keywords);
    return '$_baseUrl/seed/$seed/$width/$height';
  }

  /// Generate URL for empty state images
  static String getEmptyStateImageUrl({
    int width = 300,
    int height = 300,
    required String keywords,
  }) {
    final seed = _getSeedFromKeywords(keywords);
    return '$_baseUrl/seed/$seed/$width/$height';
  }

  /// Generate URL for hero/banner images
  static String getHeroImageUrl({
    int width = 800,
    int height = 400,
    required String keywords,
  }) {
    final seed = _getSeedFromKeywords(keywords);
    return '$_baseUrl/seed/$seed/$width/$height';
  }

  /// Get image URL for quest card based on focus area
  static String getQuestCardImageUrl(String focusAreaName) {
    final keywords = _getQuestKeywords(focusAreaName);
    return getCardImageUrl(keywords: keywords);
  }

  /// Get image URL for drawer card
  static String getDrawerCardImageUrl([String? category]) {
    final keywords = category != null && category.isNotEmpty
        ? 'clothing,$category,wardrobe'
        : 'clothing,wardrobe,fashion';
    return getCardImageUrl(keywords: keywords);
  }

  /// Get image URL for shopping card
  static String getShoppingCardImageUrl([String? category]) {
    final keywords = category != null && category.isNotEmpty
        ? 'shopping,products,$category'
        : 'shopping,products,groceries';
    return getCardImageUrl(keywords: keywords);
  }

  /// Get image URL for plan card
  static String getPlanCardImageUrl([String? category]) {
    final keywords = category != null && category.isNotEmpty
        ? 'planning,productivity,$category'
        : 'planning,productivity,calendar';
    return getCardImageUrl(keywords: keywords);
  }

  /// Get image URL for empty state based on screen type
  static String getEmptyStateImageUrlForScreen(String screenType) {
    switch (screenType.toLowerCase()) {
      case 'drawer':
        return getEmptyStateImageUrl(keywords: 'wardrobe,clothing,minimal');
      case 'shopping':
        return getEmptyStateImageUrl(keywords: 'shopping,products,minimal');
      case 'planning':
        return getEmptyStateImageUrl(keywords: 'planning,productivity,minimal');
      case 'templates':
        return getEmptyStateImageUrl(keywords: 'documentation,notes,minimal');
      default:
        return getEmptyStateImageUrl(keywords: 'minimal,clean,aesthetic');
    }
  }

  /// Get hero image URL for main screens
  static String getHeroImageUrlForScreen(String screenType) {
    switch (screenType.toLowerCase()) {
      case 'today':
        return getHeroImageUrl(keywords: 'lifestyle,motivation,inspiration');
      default:
        return getHeroImageUrl(keywords: 'lifestyle,minimal,clean');
    }
  }

  /// Map focus area names to Unsplash keywords
  static String _getQuestKeywords(String focusAreaName) {
    switch (focusAreaName.toLowerCase()) {
      case 'clothes':
        return 'clothing,wardrobe,organization';
      case 'skincare':
        return 'skincare,beauty,selfcare';
      case 'fitness':
        return 'fitness,exercise,workout';
      case 'cooking':
        return 'cooking,food,kitchen';
      default:
        return 'lifestyle,productivity';
    }
  }
}

