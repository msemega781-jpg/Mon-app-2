import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OptimizationRecommendationsWidget extends StatefulWidget {
  const OptimizationRecommendationsWidget({super.key});

  @override
  State<OptimizationRecommendationsWidget> createState() =>
      _OptimizationRecommendationsWidgetState();
}

class _OptimizationRecommendationsWidgetState
    extends State<OptimizationRecommendationsWidget> {
  final List<Map<String, dynamic>> recommendations = [
    {
      "title": "Fermer les Applications",
      "description": "7 applications en arrière-plan consomment 1.2 GB de RAM",
      "impact": "Gain: +15 FPS",
      "priority": "high",
      "icon": "close",
      "color": AppTheme.errorColor,
      "action": "close_apps",
    },
    {
      "title": "Réduire la Résolution",
      "description": "Passer de 1080p à 900p pour améliorer les performances",
      "impact": "Gain: +12 FPS",
      "priority": "medium",
      "icon": "display_settings",
      "color": AppTheme.warningColor,
      "action": "reduce_resolution",
    },
    {
      "title": "Mode Performance",
      "description": "Activer le mode haute performance du processeur",
      "impact": "Gain: +8 FPS",
      "priority": "medium",
      "icon": "speed",
      "color": AppTheme.accentColor,
      "action": "performance_mode",
    },
    {
      "title": "Optimiser Graphiques",
      "description": "Ajuster les paramètres graphiques pour votre appareil",
      "impact": "Gain: +5 FPS",
      "priority": "low",
      "icon": "tune",
      "color": AppTheme.successColor,
      "action": "optimize_graphics",
    },
  ];

  final List<Map<String, dynamic>> quickActions = [
    {
      "title": "Mode Gaming",
      "description": "Optimisation complète",
      "icon": "sports_esports",
      "color": AppTheme.accentColor,
      "enabled": false,
    },
    {
      "title": "Nettoyage RAM",
      "description": "Libérer la mémoire",
      "icon": "cleaning_services",
      "color": AppTheme.warningColor,
      "enabled": true,
    },
    {
      "title": "Refroidissement",
      "description": "Gestion thermique",
      "icon": "ac_unit",
      "color": AppTheme.successColor,
      "enabled": true,
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
                iconName: 'lightbulb',
                color: AppTheme.warningColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Recommandations',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.warningColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${recommendations.length} SUGGESTIONS',
                  style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.warningColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            'Actions Rapides',
            style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: quickActions.map((action) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      right:
                          quickActions.indexOf(action) < quickActions.length - 1
                              ? 2.w
                              : 0),
                  child: _buildQuickActionCard(
                    action['title'] as String,
                    action['description'] as String,
                    action['icon'] as String,
                    action['color'] as Color,
                    action['enabled'] as bool,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 3.h),
          Text(
            'Optimisations Suggérées',
            style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recommendations.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final recommendation = recommendations[index];
              return _buildRecommendationCard(
                recommendation['title'] as String,
                recommendation['description'] as String,
                recommendation['impact'] as String,
                recommendation['priority'] as String,
                recommendation['icon'] as String,
                recommendation['color'] as Color,
                recommendation['action'] as String,
              );
            },
          ),
          SizedBox(height: 3.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.accentColor.withValues(alpha: 0.1),
                  AppTheme.successColor.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.accentColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'auto_fix_high',
                      color: AppTheme.accentColor,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Optimisation Automatique',
                        style:
                            AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  'Appliquer toutes les optimisations recommandées en un clic pour un gain de performance maximal.',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _applyAllOptimizations();
                    },
                    icon: CustomIconWidget(
                      iconName: 'rocket_launch',
                      color: AppTheme.primaryDark,
                      size: 20,
                    ),
                    label: Text('Optimiser Maintenant'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                      foregroundColor: AppTheme.primaryDark,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(String title, String description,
      String iconName, Color color, bool enabled) {
    return GestureDetector(
      onTap: enabled
          ? () {
              _executeQuickAction(title);
            }
          : null,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: enabled
              ? AppTheme.surfaceColor
              : AppTheme.surfaceColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: enabled
                ? color.withValues(alpha: 0.3)
                : AppTheme.borderColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: enabled ? color : AppTheme.textDisabled,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                color: enabled ? AppTheme.textPrimary : AppTheme.textDisabled,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.5.h),
            Text(
              description,
              style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                color: enabled ? AppTheme.textSecondary : AppTheme.textDisabled,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(
      String title,
      String description,
      String impact,
      String priority,
      String iconName,
      Color color,
      String action) {
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: color,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: AppTheme.darkTheme.textTheme.titleSmall
                                ?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 1.5.w, vertical: 0.3.h),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(priority)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            priority.toUpperCase(),
                            style: AppTheme.darkTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: _getPriorityColor(priority),
                              fontWeight: FontWeight.w600,
                              fontSize: 8.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      description,
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    impact,
                    style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              ElevatedButton(
                onPressed: () {
                  _executeRecommendation(action);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: AppTheme.primaryDark,
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  minimumSize: Size(0, 0),
                ),
                child: Text(
                  'Appliquer',
                  style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.errorColor;
      case 'medium':
        return AppTheme.warningColor;
      case 'low':
        return AppTheme.successColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  void _executeQuickAction(String action) {
    // Simuler l'exécution d'une action rapide
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action activé avec succès'),
        backgroundColor: AppTheme.successColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _executeRecommendation(String action) {
    // Simuler l'exécution d'une recommandation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Optimisation appliquée avec succès'),
        backgroundColor: AppTheme.successColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _applyAllOptimizations() {
    // Simuler l'application de toutes les optimisations
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Toutes les optimisations ont été appliquées'),
        backgroundColor: AppTheme.successColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
