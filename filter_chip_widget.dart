import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final String? iconName;

  const FilterChipWidget({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accentColor.withValues(alpha: 0.2)
              : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.accentColor
                : AppTheme.borderColor.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconName != null) ...[
              CustomIconWidget(
                iconName: iconName!,
                color:
                    isSelected ? AppTheme.accentColor : AppTheme.textSecondary,
                size: 16,
              ),
              SizedBox(width: 1.w),
            ],
            Text(
              label,
              style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                color:
                    isSelected ? AppTheme.accentColor : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: 1.w),
              CustomIconWidget(
                iconName: 'close',
                color: AppTheme.accentColor,
                size: 14,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
