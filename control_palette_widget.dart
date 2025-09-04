import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ControlPaletteWidget extends StatelessWidget {
  final Function(Map<String, dynamic>) onControlAdd;

  const ControlPaletteWidget({
    Key? key,
    required this.onControlAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withValues(alpha: 0.95),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(
          top: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Palette de Contrôles',
            style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPaletteItem(
                    'Joystick',
                    'gamepad',
                    AppTheme.accentColor,
                    () => _addControl('joystick', 'Joystick'),
                  ),
                  SizedBox(width: 3.w),
                  _buildPaletteItem(
                    'Bouton A',
                    'radio_button_unchecked',
                    AppTheme.successColor,
                    () => _addControl('action_button', 'A'),
                  ),
                  SizedBox(width: 3.w),
                  _buildPaletteItem(
                    'Bouton B',
                    'radio_button_unchecked',
                    AppTheme.warningColor,
                    () => _addControl('action_button', 'B'),
                  ),
                  SizedBox(width: 3.w),
                  _buildPaletteItem(
                    'D-Pad',
                    'control_camera',
                    AppTheme.errorColor,
                    () => _addControl('dpad', 'D-Pad'),
                  ),
                  SizedBox(width: 3.w),
                  _buildPaletteItem(
                    'Gâchette',
                    'touch_app',
                    AppTheme.textSecondary,
                    () => _addControl('trigger', 'L1'),
                  ),
                  SizedBox(width: 3.w),
                  _buildPaletteItem(
                    'WASD',
                    'keyboard',
                    AppTheme.accentColor,
                    () => _addControl('wasd_cluster', 'WASD'),
                  ),
                  SizedBox(width: 3.w),
                  _buildPaletteItem(
                    'Macro',
                    'settings',
                    AppTheme.warningColor,
                    () => _addControl('macro_button', 'M1'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaletteItem(
      String label, String iconName, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 16.w,
        padding: EdgeInsets.symmetric(vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: AppTheme.borderColor.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 6.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.textSecondary,
                fontSize: 8.sp,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _addControl(String type, String label) {
    final controlData = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': type,
      'label': label,
      'x': 40.w,
      'y': 30.h,
      'size': 1.0,
      'opacity': 0.8,
      'sensitivity': 1.0,
    };
    onControlAdd(controlData);
  }
}
