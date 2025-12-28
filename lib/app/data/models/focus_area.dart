enum FocusArea {
  clothes,
  skincare,
  fitness,
  cooking;

  String get displayName {
    switch (this) {
      case FocusArea.clothes:
        return 'Clothes';
      case FocusArea.skincare:
        return 'Skincare';
      case FocusArea.fitness:
        return 'Fitness';
      case FocusArea.cooking:
        return 'Cooking';
    }
  }
}

