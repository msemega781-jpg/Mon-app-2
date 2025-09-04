import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddGamesBottomSheet extends StatelessWidget {
  const AddGamesBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ajouter des jeux',
                  style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Choisissez comment vous souhaitez ajouter des jeux à votre bibliothèque',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                _buildOptionTile(
                  context,
                  icon: 'computer',
                  title: 'Installer depuis PC',
                  subtitle: 'Transférez vos jeux depuis votre ordinateur',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/pc-streaming-setup');
                  },
                ),
                SizedBox(height: 2.h),
                _buildOptionTile(
                  context,
                  icon: 'store',
                  title: 'Parcourir le catalogue',
                  subtitle: 'Découvrez de nouveaux jeux disponibles',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to browse screen
                  },
                ),
                SizedBox(height: 2.h),
                _buildOptionTile(
                  context,
                  icon: 'cloud_download',
                  title: 'Importer depuis Steam',
                  subtitle: 'Synchronisez votre bibliothèque Steam',
                  onTap: () {
                    Navigator.pop(context);
                    // Handle Steam import
                  },
                ),
                SizedBox(height: 2.h),
                _buildOptionTile(
                  context,
                  icon: 'folder_open',
                  title: 'Fichier local',
                  subtitle: 'Installez un fichier .exe directement',
                  onTap: () {
                    Navigator.pop(context);
                    // Handle local file installation
                  },
                ),
                SizedBox(height: 4.h),
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.textSecondary,
                    ),
                    child: Text(
                      'Annuler',
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.borderColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: AppTheme.accentColor,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: AppTheme.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
