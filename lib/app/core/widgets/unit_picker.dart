import 'package:flutter/material.dart';
import '../../data/models/item_unit.dart';
import '../theme/design_tokens.dart';

class UnitPicker extends StatelessWidget {
  final ItemUnit selectedUnit;
  final ValueChanged<ItemUnit> onUnitChanged;
  final List<UnitType> availableUnits;
  final bool allowCustom;

  const UnitPicker({
    super.key,
    required this.selectedUnit,
    required this.onUnitChanged,
    this.availableUnits = const [],
    this.allowCustom = true,
  });

  @override
  Widget build(BuildContext context) {
    final units = availableUnits.isEmpty
        ? (allowCustom ? UnitType.values : UnitType.values.where((u) => u != UnitType.custom).toList())
        : availableUnits;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unit',
          style: DesignTokens.bodyStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingS),
        Wrap(
          spacing: DesignTokens.spacingS,
          runSpacing: DesignTokens.spacingS,
          children: [
            ...units.map((unit) {
              final isSelected = selectedUnit.type == unit;
              return ChoiceChip(
                label: Text(unit.displayName),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    onUnitChanged(ItemUnit(type: unit));
                  }
                },
                selectedColor: Colors.blue.withOpacity(0.2),
                checkmarkColor: Colors.blue,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.blue : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              );
            }),
            if (allowCustom)
              ChoiceChip(
                label: const Text('Custom'),
                selected: selectedUnit.type == UnitType.custom,
                onSelected: (selected) {
                  if (selected) {
                    onUnitChanged(ItemUnit(type: UnitType.custom, customUnit: ''));
                  }
                },
                selectedColor: Colors.blue.withOpacity(0.2),
                checkmarkColor: Colors.blue,
                labelStyle: TextStyle(
                  color: selectedUnit.type == UnitType.custom ? Colors.blue : Colors.grey[700],
                  fontWeight: selectedUnit.type == UnitType.custom ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
          ],
        ),
        if (selectedUnit.type == UnitType.custom) ...[
          const SizedBox(height: DesignTokens.spacingM),
          TextField(
            onChanged: (value) {
              onUnitChanged(selectedUnit.copyWith(customUnit: value));
            },
            decoration: InputDecoration(
              labelText: 'Custom unit',
              hintText: 'e.g., t-shirts, minutes, sets',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
              ),
            ),
            controller: TextEditingController(text: selectedUnit.customUnit),
          ),
        ],
      ],
    );
  }
}

