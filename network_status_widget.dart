import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NetworkStatusWidget extends StatefulWidget {
  const NetworkStatusWidget({super.key});

  @override
  State<NetworkStatusWidget> createState() => _NetworkStatusWidgetState();
}

class _NetworkStatusWidgetState extends State<NetworkStatusWidget> {
  final List<Map<String, dynamic>> networkMetrics = [
    {
      "label": "Latence",
      "value": "12ms",
      "status": "excellent",
      "color": AppTheme.successColor,
      "icon": "network_ping",
    },
    {
      "label": "Bande Passante",
      "value": "847 Mbps",
      "status": "excellent",
      "color": AppTheme.successColor,
      "icon": "speed",
    },
    {
      "label": "Perte de Paquets",
      "value": "0.1%",
      "status": "bon",
      "color": AppTheme.accentColor,
      "icon": "signal_cellular_alt",
    },
    {
      "label": "Gigue",
      "value": "2.3ms",
      "status": "bon",
      "color": AppTheme.accentColor,
      "icon": "timeline",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'wifi',
                color: AppTheme.successColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'État Réseau',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.successColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'CONNECTÉ',
                      style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.successColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.borderColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'router',
                      color: AppTheme.accentColor,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Connexion Active',
                            style: AppTheme.darkTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          Text(
                            'Wi-Fi 6 - GameNet_5G',
                            style: AppTheme.darkTheme.textTheme.titleSmall
                                ?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomIconWidget(
                      iconName: 'signal_wifi_4_bar',
                      color: AppTheme.successColor,
                      size: 24,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Métriques de Performance',
            style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.5,
            ),
            itemCount: networkMetrics.length,
            itemBuilder: (context, index) {
              final metric = networkMetrics[index];
              return _buildNetworkMetricCard(
                metric['label'] as String,
                metric['value'] as String,
                metric['status'] as String,
                metric['color'] as Color,
                metric['icon'] as String,
              );
            },
          ),
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.accentColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.accentColor,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Streaming Optimal',
                        style:
                            AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Votre connexion supporte le streaming 4K à 60 FPS avec une latence minimale.',
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
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Test de vitesse
                  },
                  icon: CustomIconWidget(
                    iconName: 'speed',
                    color: AppTheme.primaryDark,
                    size: 18,
                  ),
                  label: Text('Test Vitesse'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: AppTheme.primaryDark,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Diagnostics réseau
                  },
                  icon: CustomIconWidget(
                    iconName: 'network_check',
                    color: AppTheme.accentColor,
                    size: 18,
                  ),
                  label: Text('Diagnostics'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.accentColor,
                    side: BorderSide(color: AppTheme.accentColor),
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkMetricCard(
      String label, String value, String status, Color color, String iconName) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 18,
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  label,
                  style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: AppTheme.dataTextTheme().bodyLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.3.h),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status.toUpperCase(),
              style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 8.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
