import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CurrentSessionMetricsWidget extends StatefulWidget {
  const CurrentSessionMetricsWidget({super.key});

  @override
  State<CurrentSessionMetricsWidget> createState() =>
      _CurrentSessionMetricsWidgetState();
}

class _CurrentSessionMetricsWidgetState
    extends State<CurrentSessionMetricsWidget> {
  final List<Map<String, dynamic>> frameTimeData = [
    {"time": 0, "frameTime": 16.7},
    {"time": 1, "frameTime": 18.2},
    {"time": 2, "frameTime": 15.9},
    {"time": 3, "frameTime": 17.1},
    {"time": 4, "frameTime": 16.3},
    {"time": 5, "frameTime": 19.4},
    {"time": 6, "frameTime": 16.8},
    {"time": 7, "frameTime": 15.7},
    {"time": 8, "frameTime": 17.9},
    {"time": 9, "frameTime": 16.2},
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
                iconName: 'speed',
                color: AppTheme.accentColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Session Actuelle',
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
                child: Text(
                  'ACTIF',
                  style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'FPS',
                  '58',
                  AppTheme.successColor,
                  'Stable',
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildMetricCard(
                  'Résolution',
                  '1080p',
                  AppTheme.accentColor,
                  '90% échelle',
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Batterie',
                  '12.4W',
                  AppTheme.warningColor,
                  'Consommation',
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildMetricCard(
                  'Temps Frame',
                  '17.2ms',
                  AppTheme.accentColor,
                  'Moyenne',
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            'Graphique Temps de Frame (10s)',
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
                  horizontalInterval: 5,
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
                      interval: 5,
                      reservedSize: 40,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            '${value.toInt()}ms',
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
                minY: 10,
                maxY: 25,
                lineBarsData: [
                  LineChartBarData(
                    spots: frameTimeData.map((data) {
                      return FlSpot(
                        (data['time'] as int).toDouble(),
                        data['frameTime'] as double,
                      );
                    }).toList(),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.accentColor.withValues(alpha: 0.8),
                        AppTheme.accentColor,
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.accentColor.withValues(alpha: 0.3),
                          AppTheme.accentColor.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, Color color, String subtitle) {
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
}
