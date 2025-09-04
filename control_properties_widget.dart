import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ControlPropertiesWidget extends StatefulWidget {
  final Map<String, dynamic> controlData;
  final Function(Map<String, dynamic>) onUpdate;
  final VoidCallback onDelete;

  const ControlPropertiesWidget({
    Key? key,
    required this.controlData,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<ControlPropertiesWidget> createState() =>
      _ControlPropertiesWidgetState();
}

class _ControlPropertiesWidgetState extends State<ControlPropertiesWidget> {
  late TextEditingController _labelController;
  late double _size;
  late double _opacity;
  late double _sensitivity;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(
        text: widget.controlData['label'] as String? ?? '');
    _size = widget.controlData['size'] as double? ?? 1.0;
    _opacity = widget.controlData['opacity'] as double? ?? 0.8;
    _sensitivity = widget.controlData['sensitivity'] as double? ?? 1.0;
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
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
                  'Propriétés du Contrôle',
                  style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onDelete,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: 'delete',
                          color: AppTheme.errorColor,
                          size: 5.w,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
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
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    'Informations Générales',
                    [
                      _buildLabelField(),
                      SizedBox(height: 2.h),
                      _buildTypeInfo(),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  _buildSection(
                    'Apparence',
                    [
                      _buildSliderProperty(
                        'Taille',
                        _size,
                        0.5,
                        2.0,
                        (value) {
                          setState(() => _size = value);
                          _updateControl();
                        },
                      ),
                      SizedBox(height: 2.h),
                      _buildSliderProperty(
                        'Opacité',
                        _opacity,
                        0.1,
                        1.0,
                        (value) {
                          setState(() => _opacity = value);
                          _updateControl();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  _buildSection(
                    'Comportement',
                    [
                      _buildSliderProperty(
                        'Sensibilité',
                        _sensitivity,
                        0.1,
                        2.0,
                        (value) {
                          setState(() => _sensitivity = value);
                          _updateControl();
                        },
                      ),
                      SizedBox(height: 2.h),
                      _buildDeadZoneSettings(),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  _buildSection(
                    'Actions Rapides',
                    [
                      _buildQuickActions(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        ...children,
      ],
    );
  }

  Widget _buildLabelField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Libellé',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        SizedBox(height: 0.5.h),
        TextField(
          controller: _labelController,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Entrez le libellé du contrôle',
          ),
          onChanged: (value) => _updateControl(),
        ),
      ],
    );
  }

  Widget _buildTypeInfo() {
    final String type = widget.controlData['type'] as String;
    final String typeLabel = _getTypeLabel(type);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: _getTypeIcon(type),
            color: _getTypeColor(type),
            size: 6.w,
          ),
          SizedBox(width: 3.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Type de Contrôle',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                typeLabel,
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSliderProperty(String label, double value, double min,
      double max, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            Text(
              '${(value * 100).round()}%',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppTheme.accentColor,
            thumbColor: AppTheme.accentColor,
            overlayColor: AppTheme.accentColor.withValues(alpha: 0.2),
            inactiveTrackColor: AppTheme.borderColor,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: 20,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDeadZoneSettings() {
    if (widget.controlData['type'] != 'joystick') {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Zone Morte',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Ajuste la sensibilité du joystick pour éviter les mouvements involontaires',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 1.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.warningColor,
              thumbColor: AppTheme.warningColor,
              overlayColor: AppTheme.warningColor.withValues(alpha: 0.2),
              inactiveTrackColor: AppTheme.borderColor,
            ),
            child: Slider(
              value: 0.1,
              min: 0.0,
              max: 0.5,
              divisions: 10,
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _duplicateControl,
            icon: CustomIconWidget(
              iconName: 'content_copy',
              color: AppTheme.primaryDark,
              size: 4.w,
            ),
            label: Text('Dupliquer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              foregroundColor: AppTheme.primaryDark,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _resetToDefault,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.accentColor,
              size: 4.w,
            ),
            label: Text('Réinitialiser'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.accentColor,
              side: BorderSide(color: AppTheme.accentColor),
            ),
          ),
        ),
      ],
    );
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'joystick':
        return 'Joystick Analogique';
      case 'action_button':
        return 'Bouton d\'Action';
      case 'dpad':
        return 'Pavé Directionnel';
      case 'trigger':
        return 'Gâchette';
      case 'wasd_cluster':
        return 'Cluster WASD';
      case 'macro_button':
        return 'Bouton Macro';
      default:
        return 'Contrôle Personnalisé';
    }
  }

  String _getTypeIcon(String type) {
    switch (type) {
      case 'joystick':
        return 'gamepad';
      case 'action_button':
        return 'radio_button_unchecked';
      case 'dpad':
        return 'control_camera';
      case 'trigger':
        return 'touch_app';
      case 'wasd_cluster':
        return 'keyboard';
      case 'macro_button':
        return 'settings';
      default:
        return 'touch_app';
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'joystick':
        return AppTheme.accentColor;
      case 'action_button':
        return AppTheme.successColor;
      case 'dpad':
        return AppTheme.warningColor;
      case 'trigger':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  void _updateControl() {
    final updatedControl = Map<String, dynamic>.from(widget.controlData);
    updatedControl['label'] = _labelController.text;
    updatedControl['size'] = _size;
    updatedControl['opacity'] = _opacity;
    updatedControl['sensitivity'] = _sensitivity;
    widget.onUpdate(updatedControl);
  }

  void _duplicateControl() {
    final duplicatedControl = Map<String, dynamic>.from(widget.controlData);
    duplicatedControl['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    duplicatedControl['x'] = (duplicatedControl['x'] as double) + 10.w;
    duplicatedControl['y'] = (duplicatedControl['y'] as double) + 5.h;
    widget.onUpdate(duplicatedControl);
    Navigator.pop(context);
  }

  void _resetToDefault() {
    setState(() {
      _size = 1.0;
      _opacity = 0.8;
      _sensitivity = 1.0;
    });
    _updateControl();
  }
}