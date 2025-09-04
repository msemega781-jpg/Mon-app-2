import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ButtonMappingWidget extends StatefulWidget {
  final Map<String, dynamic> mappingData;
  final Function(Map<String, dynamic>) onMappingChanged;

  const ButtonMappingWidget({
    Key? key,
    required this.mappingData,
    required this.onMappingChanged,
  }) : super(key: key);

  @override
  State<ButtonMappingWidget> createState() => _ButtonMappingWidgetState();
}

class _ButtonMappingWidgetState extends State<ButtonMappingWidget> {
  String? _selectedButton;
  bool _isRemapping = false;

  final List<Map<String, dynamic>> _controllerButtons = [
    {
      'id': 'a',
      'label': 'A',
      'position': {'x': 0.75, 'y': 0.6}
    },
    {
      'id': 'b',
      'label': 'B',
      'position': {'x': 0.8, 'y': 0.5}
    },
    {
      'id': 'x',
      'label': 'X',
      'position': {'x': 0.7, 'y': 0.5}
    },
    {
      'id': 'y',
      'label': 'Y',
      'position': {'x': 0.75, 'y': 0.4}
    },
    {
      'id': 'lb',
      'label': 'LB',
      'position': {'x': 0.2, 'y': 0.2}
    },
    {
      'id': 'rb',
      'label': 'RB',
      'position': {'x': 0.8, 'y': 0.2}
    },
    {
      'id': 'lt',
      'label': 'LT',
      'position': {'x': 0.15, 'y': 0.1}
    },
    {
      'id': 'rt',
      'label': 'RT',
      'position': {'x': 0.85, 'y': 0.1}
    },
    {
      'id': 'dpad_up',
      'label': '↑',
      'position': {'x': 0.25, 'y': 0.4}
    },
    {
      'id': 'dpad_down',
      'label': '↓',
      'position': {'x': 0.25, 'y': 0.6}
    },
    {
      'id': 'dpad_left',
      'label': '←',
      'position': {'x': 0.2, 'y': 0.5}
    },
    {
      'id': 'dpad_right',
      'label': '→',
      'position': {'x': 0.3, 'y': 0.5}
    },
    {
      'id': 'left_stick',
      'label': 'LS',
      'position': {'x': 0.35, 'y': 0.7}
    },
    {
      'id': 'right_stick',
      'label': 'RS',
      'position': {'x': 0.65, 'y': 0.7}
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'gamepad',
                color: AppTheme.accentColor,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Configuration des Boutons',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: _resetToDefault,
                child: Text('Réinitialiser'),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            height: 40.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.primaryDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppTheme.borderColor.withValues(alpha: 0.5)),
            ),
            child: Stack(
              children: [
                // Controller outline
                Center(
                  child: Container(
                    width: 80.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                  ),
                ),
                // Buttons
                ..._controllerButtons
                    .map((button) => _buildControllerButton(button)),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          if (_selectedButton != null) _buildMappingOptions(),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _createMacro,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.warningColor,
                    foregroundColor: AppTheme.primaryDark,
                  ),
                  child: Text('Créer Macro'),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: _testMapping,
                  child: Text('Tester'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControllerButton(Map<String, dynamic> button) {
    final position = button['position'] as Map<String, dynamic>;
    final isSelected = _selectedButton == button['id'];
    final currentMapping =
        widget.mappingData[button['id']] as String? ?? button['label'];

    return Positioned(
      left: (position['x'] as double) * 80.w,
      top: (position['y'] as double) * 35.h,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedButton = button['id'];
          });
        },
        child: Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.accentColor : AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(4.w),
            border: Border.all(
              color: isSelected ? AppTheme.accentColor : AppTheme.borderColor,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppTheme.accentColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              currentMapping,
              style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                color: isSelected ? AppTheme.primaryDark : AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMappingOptions() {
    final actions = [
      'Saut',
      'Tir',
      'Recharger',
      'Courir',
      'Accroupir',
      'Viser',
      'Grenade',
      'Couteau',
      'Changer Arme',
      'Interaction',
      'Menu',
      'Carte'
    ];

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assigner à ${_selectedButton?.toUpperCase()}:',
            style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: actions
                .map((action) => GestureDetector(
                      onTap: () => _assignAction(action),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: Text(
                          action,
                          style: AppTheme.darkTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  void _assignAction(String action) {
    if (_selectedButton != null) {
      final updatedMapping = Map<String, dynamic>.from(widget.mappingData);
      updatedMapping[_selectedButton!] = action;
      widget.onMappingChanged(updatedMapping);
      setState(() {
        _selectedButton = null;
      });
    }
  }

  void _resetToDefault() {
    final defaultMapping = <String, dynamic>{};
    for (final button in _controllerButtons) {
      defaultMapping[button['id']] = button['label'];
    }
    widget.onMappingChanged(defaultMapping);
    setState(() {
      _selectedButton = null;
    });
  }

  void _createMacro() {
    // Show macro creation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkTheme.colorScheme.surface,
        title: Text(
          'Créer une Macro',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'Fonctionnalité de création de macro sera disponible prochainement.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _testMapping() {
    // Show test mode dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkTheme.colorScheme.surface,
        title: Text(
          'Mode Test',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'Appuyez sur les boutons de votre contrôleur pour tester la configuration.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
