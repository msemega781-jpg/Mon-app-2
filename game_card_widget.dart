import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GameCardWidget extends StatelessWidget {
  final Map<String, dynamic> game;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isGridView;

  const GameCardWidget({
    super.key,
    required this.game,
    this.onTap,
    this.onLongPress,
    this.isGridView = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.borderColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: isGridView ? _buildGridCard() : _buildListCard(),
      ),
    );
  }

  Widget _buildGridCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              color: AppTheme.surfaceColor,
            ),
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: CustomImageWidget(
                imageUrl: game['artwork'] as String? ?? '',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(2.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game['title'] as String? ?? 'Titre inconnu',
                      style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    _buildPlatformBadges(),
                  ],
                ),
                SizedBox(height: 1.h),
                _buildActionButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListCard() {
    return Padding(
      padding: EdgeInsets.all(3.w),
      child: Row(
        children: [
          Container(
            width: 20.w,
            height: 15.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppTheme.surfaceColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomImageWidget(
                imageUrl: game['artwork'] as String? ?? '',
                width: 20.w,
                height: 15.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game['title'] as String? ?? 'Titre inconnu',
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),
                _buildPlatformBadges(),
                SizedBox(height: 1.h),
                Text(
                  game['size'] as String? ?? '',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(height: 1.5.h),
                _buildActionButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformBadges() {
    final platforms = (game['platforms'] as List<dynamic>?) ?? [];

    return Wrap(
      spacing: 1.w,
      runSpacing: 0.5.h,
      children: platforms.map<Widget>((platform) {
        Color badgeColor;
        String platformText = platform as String? ?? '';

        switch (platformText.toLowerCase()) {
          case 'pc':
            badgeColor = AppTheme.accentColor;
            break;
          case 'émulé':
            badgeColor = AppTheme.warningColor;
            break;
          case 'cloud':
            badgeColor = AppTheme.successColor;
            break;
          default:
            badgeColor = AppTheme.textSecondary;
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: badgeColor.withValues(alpha: 0.5),
              width: 0.5,
            ),
          ),
          child: Text(
            platformText,
            style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w500,
              fontSize: 10.sp,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButton() {
    final status = game['status'] as String? ?? 'non_installe';

    switch (status) {
      case 'installe':
        return SizedBox(
          width: double.infinity,
          height: 4.h,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              foregroundColor: AppTheme.primaryDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'play_arrow',
                  color: AppTheme.primaryDark,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Jouer',
                  style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      case 'installation':
        return SizedBox(
          width: double.infinity,
          height: 4.h,
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.warningColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.warningColor.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.warningColor),
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  '${game['progress'] ?? 0}%',
                  style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.warningColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      default:
        return SizedBox(
          width: double.infinity,
          height: 4.h,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.accentColor,
              side: BorderSide(color: AppTheme.accentColor, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'download',
                  color: AppTheme.accentColor,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Installer',
                  style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }
}
