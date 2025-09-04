import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GameContextMenu extends StatelessWidget {
  final Map<String, dynamic> game;
  final VoidCallback? onPlay;
  final VoidCallback? onInstall;
  final VoidCallback? onUninstall;
  final VoidCallback? onGameInfo;
  final VoidCallback? onControllerSettings;
  final VoidCallback? onRemove;

  const GameContextMenu({
    super.key,
    required this.game,
    this.onPlay,
    this.onInstall,
    this.onUninstall,
    this.onGameInfo,
    this.onControllerSettings,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final status = game['status'] as String? ?? 'non_installe';

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderColor.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppTheme.cardColor,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CustomImageWidget(
                      imageUrl: game['artwork'] as String? ?? '',
                      width: 12.w,
                      height: 12.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game['title'] as String? ?? 'Titre inconnu',
                        style:
                            AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        _getStatusText(status),
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: AppTheme.borderColor.withValues(alpha: 0.3),
          ),
          if (status == 'installe') ...[
            _buildMenuItem(
              icon: 'play_arrow',
              title: 'Jouer',
              onTap: onPlay,
            ),
            _buildMenuItem(
              icon: 'gamepad',
              title: 'Paramètres manette',
              onTap: onControllerSettings,
            ),
            _buildMenuItem(
              icon: 'delete_outline',
              title: 'Désinstaller',
              onTap: onUninstall,
              isDestructive: true,
            ),
          ] else if (status == 'installation') ...[
            _buildMenuItem(
              icon: 'pause',
              title: 'Suspendre l\'installation',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: 'cancel',
              title: 'Annuler l\'installation',
              onTap: () {},
              isDestructive: true,
            ),
          ] else ...[
            _buildMenuItem(
              icon: 'download',
              title: 'Installer',
              onTap: onInstall,
            ),
          ],
          _buildMenuItem(
            icon: 'info_outline',
            title: 'Informations du jeu',
            onTap: onGameInfo,
          ),
          _buildMenuItem(
            icon: 'remove_circle_outline',
            title: 'Retirer de la bibliothèque',
            onTap: onRemove,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String title,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color:
                  isDestructive ? AppTheme.errorColor : AppTheme.textSecondary,
              size: 20,
            ),
            SizedBox(width: 4.w),
            Text(
              title,
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color:
                    isDestructive ? AppTheme.errorColor : AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'installe':
        return 'Installé';
      case 'installation':
        return 'Installation en cours...';
      case 'non_installe':
        return 'Non installé';
      default:
        return 'Statut inconnu';
    }
  }
}
