import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PresetTemplatesWidget extends StatelessWidget {
  final Function(List<Map<String, dynamic>>) onPresetLoad;

  const PresetTemplatesWidget({
    Key? key,
    required this.onPresetLoad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppTheme.borderColor, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Modèles Prédéfinis',
                  style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textSecondary,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(4.w),
              children: [
                _buildPresetCard(
                  'Configuration FPS',
                  'Optimisé pour les jeux de tir à la première personne',
                  'gamepad',
                  AppTheme.accentColor,
                  () => _loadFPSPreset(),
                ),
                SizedBox(height: 2.h),
                _buildPresetCard(
                  'Configuration RPG',
                  'Parfait pour les jeux de rôle et d\'aventure',
                  'explore',
                  AppTheme.successColor,
                  () => _loadRPGPreset(),
                ),
                SizedBox(height: 2.h),
                _buildPresetCard(
                  'Contrôles de Course',
                  'Conçu pour les jeux de course et simulation',
                  'directions_car',
                  AppTheme.warningColor,
                  () => _loadRacingPreset(),
                ),
                SizedBox(height: 2.h),
                _buildPresetCard(
                  'Jeux de Plateforme',
                  'Idéal pour les jeux de plateforme 2D',
                  'videogame_asset',
                  AppTheme.errorColor,
                  () => _loadPlatformPreset(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetCard(String title, String description, String iconName,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: AppTheme.borderColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: color,
                  size: 6.w,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: AppTheme.textSecondary,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }

  void _loadFPSPreset() {
    final fpsControls = [
      {
        'id': 'fps_joystick_move',
        'type': 'joystick',
        'label': 'Mouvement',
        'x': 8.w,
        'y': 65.h,
        'size': 1.2,
        'opacity': 0.7,
        'sensitivity': 1.0,
      },
      {
        'id': 'fps_joystick_look',
        'type': 'joystick',
        'label': 'Regard',
        'x': 75.w,
        'y': 65.h,
        'size': 1.2,
        'opacity': 0.7,
        'sensitivity': 1.2,
      },
      {
        'id': 'fps_fire',
        'type': 'action_button',
        'label': 'Tir',
        'x': 85.w,
        'y': 45.h,
        'size': 1.0,
        'opacity': 0.8,
        'sensitivity': 1.0,
      },
      {
        'id': 'fps_aim',
        'type': 'trigger',
        'label': 'Visée',
        'x': 5.w,
        'y': 45.h,
        'size': 0.8,
        'opacity': 0.6,
        'sensitivity': 1.0,
      },
      {
        'id': 'fps_reload',
        'type': 'action_button',
        'label': 'R',
        'x': 75.w,
        'y': 35.h,
        'size': 0.8,
        'opacity': 0.7,
        'sensitivity': 1.0,
      },
      {
        'id': 'fps_jump',
        'type': 'action_button',
        'label': 'Saut',
        'x': 85.w,
        'y': 25.h,
        'size': 0.9,
        'opacity': 0.7,
        'sensitivity': 1.0,
      },
    ];
    onPresetLoad(fpsControls);
  }

  void _loadRPGPreset() {
    final rpgControls = [
      {
        'id': 'rpg_joystick',
        'type': 'joystick',
        'label': 'Mouvement',
        'x': 10.w,
        'y': 70.h,
        'size': 1.1,
        'opacity': 0.8,
        'sensitivity': 0.9,
      },
      {
        'id': 'rpg_action_a',
        'type': 'action_button',
        'label': 'A',
        'x': 80.w,
        'y': 60.h,
        'size': 1.0,
        'opacity': 0.8,
        'sensitivity': 1.0,
      },
      {
        'id': 'rpg_action_b',
        'type': 'action_button',
        'label': 'B',
        'x': 85.w,
        'y': 50.h,
        'size': 1.0,
        'opacity': 0.8,
        'sensitivity': 1.0,
      },
      {
        'id': 'rpg_menu',
        'type': 'action_button',
        'label': 'Menu',
        'x': 45.w,
        'y': 10.h,
        'size': 0.8,
        'opacity': 0.6,
        'sensitivity': 1.0,
      },
      {
        'id': 'rpg_inventory',
        'type': 'action_button',
        'label': 'Inv',
        'x': 75.w,
        'y': 30.h,
        'size': 0.8,
        'opacity': 0.7,
        'sensitivity': 1.0,
      },
    ];
    onPresetLoad(rpgControls);
  }

  void _loadRacingPreset() {
    final racingControls = [
      {
        'id': 'racing_steering',
        'type': 'joystick',
        'label': 'Direction',
        'x': 45.w,
        'y': 70.h,
        'size': 1.3,
        'opacity': 0.7,
        'sensitivity': 1.1,
      },
      {
        'id': 'racing_accelerate',
        'type': 'trigger',
        'label': 'Accél.',
        'x': 80.w,
        'y': 50.h,
        'size': 1.2,
        'opacity': 0.8,
        'sensitivity': 1.0,
      },
      {
        'id': 'racing_brake',
        'type': 'trigger',
        'label': 'Frein',
        'x': 10.w,
        'y': 50.h,
        'size': 1.2,
        'opacity': 0.8,
        'sensitivity': 1.0,
      },
      {
        'id': 'racing_handbrake',
        'type': 'action_button',
        'label': 'HB',
        'x': 85.w,
        'y': 30.h,
        'size': 0.9,
        'opacity': 0.7,
        'sensitivity': 1.0,
      },
    ];
    onPresetLoad(racingControls);
  }

  void _loadPlatformPreset() {
    final platformControls = [
      {
        'id': 'platform_dpad',
        'type': 'dpad',
        'label': 'D-Pad',
        'x': 8.w,
        'y': 65.h,
        'size': 1.1,
        'opacity': 0.8,
        'sensitivity': 1.0,
      },
      {
        'id': 'platform_jump',
        'type': 'action_button',
        'label': 'Saut',
        'x': 80.w,
        'y': 60.h,
        'size': 1.1,
        'opacity': 0.8,
        'sensitivity': 1.0,
      },
      {
        'id': 'platform_action',
        'type': 'action_button',
        'label': 'Action',
        'x': 85.w,
        'y': 45.h,
        'size': 1.0,
        'opacity': 0.8,
        'sensitivity': 1.0,
      },
      {
        'id': 'platform_run',
        'type': 'action_button',
        'label': 'Course',
        'x': 75.w,
        'y': 30.h,
        'size': 0.9,
        'opacity': 0.7,
        'sensitivity': 1.0,
      },
    ];
    onPresetLoad(platformControls);
  }
}
