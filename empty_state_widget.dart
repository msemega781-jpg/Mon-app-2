import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback? onAddGamesTap;

  const EmptyStateWidget({
    super.key,
    this.onAddGamesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(20.w),
                border: Border.all(
                  color: AppTheme.borderColor.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'sports_esports',
                  color: AppTheme.textSecondary,
                  size: 60,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Aucun jeu dans votre bibliothèque',
              style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Commencez à construire votre collection de jeux en ajoutant vos premiers titres depuis votre PC ou en explorant notre catalogue.',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: onAddGamesTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: AppTheme.primaryDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'add',
                      color: AppTheme.primaryDark,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Ajouter votre premier jeu',
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/pc-streaming-setup');
              },
              child: Text(
                'Configurer le streaming PC',
                style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
