import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/design_tokens.dart';
import '../../data/models/energy_level.dart' as models;

class EnergyPicker extends StatelessWidget {
  final models.EnergyLevel selectedEnergy;
  final ValueChanged<models.EnergyLevel> onEnergyChanged;

  const EnergyPicker({
    super.key,
    required this.selectedEnergy,
    required this.onEnergyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingS),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey[50]!,
            Colors.grey[100]!,
          ],
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        boxShadow: DesignTokens.softShadow(context),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildEnergyOption(
            context,
            models.EnergyLevel.low,
            'Low',
            Icons.battery_1_bar,
            Colors.blue,
          ),
          _buildEnergyOption(
            context,
            models.EnergyLevel.medium,
            'Medium',
            Icons.battery_3_bar,
            Colors.orange,
          ),
          _buildEnergyOption(
            context,
            models.EnergyLevel.high,
            'High',
            Icons.battery_full,
            Colors.green,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.1, end: 0, duration: 400.ms);
  }

  Widget _buildEnergyOption(
    BuildContext context,
    models.EnergyLevel level,
    String label,
    IconData icon,
    Color color,
  ) {
    final isSelected = selectedEnergy == level;
    return Expanded(
      child: GestureDetector(
        onTap: () => onEnergyChanged(level),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          padding: const EdgeInsets.symmetric(
            vertical: DesignTokens.spacingM,
            horizontal: DesignTokens.spacingS,
          ),
          margin: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingS),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      color.withOpacity(0.3),
                      color.withOpacity(0.2),
                    ],
                  )
                : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
            border: Border.all(
              color: isSelected ? color : Colors.transparent,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? color : Colors.grey[600],
                size: 24,
              ),
              const SizedBox(height: DesignTokens.spacingS),
              Text(
                label,
                style: DesignTokens.bodyStyle.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                  color: isSelected ? color : Colors.grey[700],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        )
            .animate(target: isSelected ? 1 : 0)
            .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 200.ms),
      ),
    );
  }
}
