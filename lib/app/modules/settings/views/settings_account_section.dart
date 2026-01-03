import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/section_card.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/services/api_client.dart';
import '../controllers/settings_controller.dart';

Future<Map<String, dynamic>?> _getCurrentUser() async {
  try {
    final apiClient = Get.find<ApiClient>();
    return await apiClient.getCurrentUser();
  } catch (_) {
    return null;
  }
}

class SettingsAccountSection extends GetView<SettingsController> {
  const SettingsAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Account',
      icon: Icons.account_circle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder<Map<String, dynamic>?>(
            future: _getCurrentUser(),
            builder: (context, snapshot) {
              final user = snapshot.data;
              if (user != null) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: DesignTokens.spacingL),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          (user['name'] as String? ?? 'U').substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user['name'] ?? 'User',
                              style: DesignTokens.bodyStyle.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              user['email'] ?? '',
                              style: DesignTokens.captionStyle.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          OutlinedButton.icon(
            onPressed: () async {
              final confirmed = await ConfirmationDialog.show(
                title: 'Logout',
                message: 'Are you sure you want to logout?',
                confirmLabel: 'Logout',
              );
              
              if (confirmed) {
                controller.logout();
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingL,
                vertical: DesignTokens.spacingM,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

