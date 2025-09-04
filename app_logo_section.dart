import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppLogoSection extends StatelessWidget {
  const AppLogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Logo
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.accentColor,
                AppTheme.successColor,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentColor.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'games',
              color: AppTheme.primaryDark,
              size: 40,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        // App Name
        Text(
          'GameStream',
          style: AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 0.5.h),
        // Tagline
        Text(
          'Jeux PC sur mobile',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
