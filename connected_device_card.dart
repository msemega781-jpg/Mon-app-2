import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ConnectedDeviceCard extends StatelessWidget {
  final Map<String, dynamic> device;
  final VoidCallback? onDisconnect;

  const ConnectedDeviceCard({
    Key? key,
    required this.device,
    this.onDisconnect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final batteryLevel = device['batteryLevel'] as int? ?? 0;
    final connectionType = device['connectionType'] as String? ?? 'Bluetooth';
    final signalStrength = device['signalStrength'] as int? ?? 0;
    final isConnected = device['isConnected'] as bool? ?? false;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isConnected ? AppTheme.accentColor : AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'gamepad',
                  color: AppTheme.accentColor,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device['name'] as String? ?? 'Contrôleur Inconnu',
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      device['model'] as String? ?? 'Modèle Inconnu',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isConnected
                      ? AppTheme.successColor.withValues(alpha: 0.2)
                      : AppTheme.errorColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isConnected ? 'Connecté' : 'Déconnecté',
                  style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                    color: isConnected
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatusItem(
                  'Batterie',
                  '$batteryLevel%',
                  CustomIconWidget(
                    iconName:
                        batteryLevel > 20 ? 'battery_full' : 'battery_alert',
                    color: batteryLevel > 20
                        ? AppTheme.successColor
                        : AppTheme.warningColor,
                    size: 4.w,
                  ),
                ),
              ),
              Expanded(
                child: _buildStatusItem(
                  'Connexion',
                  connectionType,
                  CustomIconWidget(
                    iconName: connectionType == 'USB' ? 'usb' : 'bluetooth',
                    color: AppTheme.accentColor,
                    size: 4.w,
                  ),
                ),
              ),
              Expanded(
                child: _buildStatusItem(
                  'Signal',
                  '$signalStrength%',
                  CustomIconWidget(
                    iconName: signalStrength > 70
                        ? 'signal_wifi_4_bar'
                        : signalStrength > 40
                            ? 'signal_wifi_3_bar'
                            : 'signal_wifi_1_bar',
                    color: signalStrength > 70
                        ? AppTheme.successColor
                        : signalStrength > 40
                            ? AppTheme.warningColor
                            : AppTheme.errorColor,
                    size: 4.w,
                  ),
                ),
              ),
            ],
          ),
          if (isConnected) ...[
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to controller calibration
                    },
                    child: Text('Calibrer'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onDisconnect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorColor,
                      foregroundColor: AppTheme.textPrimary,
                    ),
                    child: Text('Déconnecter'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, String value, Widget icon) {
    return Column(
      children: [
        icon,
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
