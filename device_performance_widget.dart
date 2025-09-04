import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DevicePerformanceWidget extends StatefulWidget {
  const DevicePerformanceWidget({super.key});

  @override
  State<DevicePerformanceWidget> createState() =>
      _DevicePerformanceWidgetState();
}

class _DevicePerformanceWidgetState extends State<DevicePerformanceWidget> {
  final List<Map<String, dynamic>> cpuUsageData = [
    {"time": 0, "usage": 45.2},
    {"time": 1, "usage": 52.1},
    {"time": 2, "usage": 48.7},
    {"time": 3, "usage": 55.3},
    {"time": 4, "usage": 49.8},
    {"time": 5, "usage": 58.2},
    {"time": 6, "usage": 51.4},
    {"time": 7, "usage": 47.9},
    {"time": 8, "usage": 53.6},
    {"time": 9, "usage": 50.1},
  ];

  final List<Map<String, dynamic>> gpuUsageData = [
    {"time": 0, "usage": 72.5},
    {"time": 1, "usage": 78.3},
    {"time": 2, "usage": 75.1},
    {"time": 3, "usage": 81.2},
    {"time": 4, "usage": 76.8},
    {"time": 5, "usage": 84.1},
    {"time": 6, "usage": 79.4},
    {"time": 7, "usage": 73.7},
    {"time": 8, "usage": 80.9},
    {"time": 9, "usage": 77.2},
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
                iconName: 'memory',
                color: AppTheme.warningColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Performance Appareil',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildUsageCard(
                  'CPU',
                  '52%',
                  AppTheme.accentColor,
                  'Snapdragon 8 Gen 2',
                  0.52,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildUsageCard(
                  'GPU',
                  '78%',
                  AppTheme.warningColor,
                  'Adreno 740',
                  0.78,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStorageCard(
                  'RAM',
                  '6.2 GB',
                  '8 GB',
                  AppTheme.errorColor,
                  0.775,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStorageCard(
                  'Stockage',
                  '89 GB',
                  '128 GB',
                  AppTheme.successColor,
                  0.695,
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
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'thermostat',
                  color: AppTheme.successColor,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'État Thermique',
                        style:
                            AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      Text(
                        'Normal - 42°C',
                        style:
                            AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.successColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'OPTIMAL',
                    style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Historique CPU/GPU (10s)',
            style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            height: 20.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppTheme.borderColor.withValues(alpha: 0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 2,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            '${value.toInt()}s',
                            style: AppTheme.dataTextTheme().bodySmall?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      reservedSize: 40,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            '${value.toInt()}%',
                            style: AppTheme.dataTextTheme().bodySmall?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: AppTheme.borderColor.withValues(alpha: 0.3),
                  ),
                ),
                minX: 0,
                maxX: 9,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: cpuUsageData.map((data) {
                      return FlSpot(
                        (data['time'] as int).toDouble(),
                        data['usage'] as double,
                      );
                    }).toList(),
                    isCurved: true,
                    color: AppTheme.accentColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: gpuUsageData.map((data) {
                      return FlSpot(
                        (data['time'] as int).toDouble(),
                        data['usage'] as double,
                      );
                    }).toList(),
                    isCurved: true,
                    color: AppTheme.warningColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('CPU', AppTheme.accentColor),
              SizedBox(width: 4.w),
              _buildLegendItem('GPU', AppTheme.warningColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsageCard(String title, String value, Color color,
      String subtitle, double progress) {
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
        children: [
          Text(
            title,
            style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: AppTheme.dataTextTheme().headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.borderColor.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
          SizedBox(height: 0.5.h),
          Text(
            subtitle,
            style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageCard(
      String title, String used, String total, Color color, double progress) {
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
        children: [
          Text(
            title,
            style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            '$used / $total',
            style: AppTheme.dataTextTheme().bodyLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.borderColor.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
