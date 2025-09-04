import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GamingBackground extends StatelessWidget {
  final Widget child;

  const GamingBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryDark,
            AppTheme.secondaryDark,
            AppTheme.primaryDark.withValues(alpha: 0.8),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Gaming pattern overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1542751371-adc38448a05e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          // Subtle controller icons
          Positioned(
            top: 15.h,
            right: -5.w,
            child: Opacity(
              opacity: 0.03,
              child: Transform.rotate(
                angle: 0.2,
                child: CustomIconWidget(
                  iconName: 'gamepad',
                  color: AppTheme.accentColor,
                  size: 80,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20.h,
            left: -3.w,
            child: Opacity(
              opacity: 0.03,
              child: Transform.rotate(
                angle: -0.3,
                child: CustomIconWidget(
                  iconName: 'sports_esports',
                  color: AppTheme.successColor,
                  size: 60,
                ),
              ),
            ),
          ),
          // Main content
          child,
        ],
      ),
    );
  }
}
