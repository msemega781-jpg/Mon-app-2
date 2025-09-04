import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PreviewModeWidget extends StatefulWidget {
  final List<Map<String, dynamic>> controls;
  final VoidCallback onExit;

  const PreviewModeWidget({
    Key? key,
    required this.controls,
    required this.onExit,
  }) : super(key: key);

  @override
  State<PreviewModeWidget> createState() => _PreviewModeWidgetState();
}

class _PreviewModeWidgetState extends State<PreviewModeWidget> {
  final Set<String> _activeControls = {};
  final Map<String, Offset> _joystickPositions = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: Stack(
        children: [
          // Game preview background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryDark,
                  AppTheme.secondaryDark,
                  AppTheme.primaryDark,
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'videogame_asset',
                    color: AppTheme.accentColor.withValues(alpha: 0.3),
                    size: 20.w,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Mode Aperçu',
                    style:
                        AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
                      color: AppTheme.textPrimary.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Testez vos contrôles avec retour haptique',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Controls overlay
          ...widget.controls.map((control) => _buildPreviewControl(control)),

          // Exit button
          Positioned(
            top: 8.h,
            right: 4.w,
            child: GestureDetector(
              onTap: widget.onExit,
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.textPrimary,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Quitter',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Active controls indicator
          Positioned(
            top: 8.h,
            left: 4.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: Text(
                'Contrôles actifs: ${_activeControls.length}',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewControl(Map<String, dynamic> control) {
    final String controlId = control['id'] as String;
    final String type = control['type'] as String;
    final double elementSize = (control['size'] as double) * 10.w;
    final double opacity = control['opacity'] as double;
    final bool isActive = _activeControls.contains(controlId);

    return Positioned(
      left: control['x'] as double,
      top: control['y'] as double,
      child: GestureDetector(
        onTapDown: (_) => _activateControl(controlId),
        onTapUp: (_) => _deactivateControl(controlId),
        onTapCancel: () => _deactivateControl(controlId),
        onPanStart: type == 'joystick'
            ? (details) => _activateControl(controlId)
            : null,
        onPanUpdate: type == 'joystick'
            ? (details) => _updateJoystick(controlId, details.localPosition)
            : null,
        onPanEnd:
            type == 'joystick' ? (_) => _deactivateControl(controlId) : null,
        child: Container(
          width: elementSize,
          height: elementSize,
          decoration: BoxDecoration(
            color: _getControlColor(type)
                .withValues(alpha: isActive ? opacity + 0.2 : opacity),
            borderRadius:
                BorderRadius.circular(type == 'joystick' ? elementSize / 2 : 8),
            border: Border.all(
              color: isActive
                  ? AppTheme.accentColor
                  : AppTheme.borderColor.withValues(alpha: 0.3),
              width: isActive ? 2 : 1,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppTheme.accentColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppTheme.shadowColor,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Stack(
            children: [
              Center(
                child: _buildControlContent(type, elementSize, control),
              ),
              if (type == 'joystick' &&
                  _joystickPositions.containsKey(controlId))
                _buildJoystickThumb(
                    elementSize, _joystickPositions[controlId]!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlContent(
      String type, double size, Map<String, dynamic> control) {
    switch (type) {
      case 'joystick':
        return Container(
          width: size * 0.4,
          height: size * 0.4,
          decoration: BoxDecoration(
            color: AppTheme.textPrimary,
            shape: BoxShape.circle,
          ),
        );
      case 'action_button':
        return Text(
          control['label'] as String? ?? 'A',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        );
      case 'dpad':
        return CustomIconWidget(
          iconName: 'gamepad',
          color: AppTheme.textPrimary,
          size: size * 0.5,
        );
      case 'trigger':
        return CustomIconWidget(
          iconName: 'radio_button_unchecked',
          color: AppTheme.textPrimary,
          size: size * 0.6,
        );
      default:
        return CustomIconWidget(
          iconName: 'touch_app',
          color: AppTheme.textPrimary,
          size: size * 0.5,
        );
    }
  }

  Widget _buildJoystickThumb(double containerSize, Offset position) {
    final double thumbSize = containerSize * 0.3;
    final double maxRadius = (containerSize - thumbSize) / 2;

    // Clamp position to circle bounds
    final Offset center = Offset(containerSize / 2, containerSize / 2);
    final Offset relativePosition = position - center;
    final double distance = relativePosition.distance;
    final Offset clampedPosition = distance > maxRadius
        ? center + (relativePosition / distance) * maxRadius
        : position;

    return Positioned(
      left: clampedPosition.dx - thumbSize / 2,
      top: clampedPosition.dy - thumbSize / 2,
      child: Container(
        width: thumbSize,
        height: thumbSize,
        decoration: BoxDecoration(
          color: AppTheme.accentColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowColor,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }

  Color _getControlColor(String type) {
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

  void _activateControl(String controlId) {
    setState(() {
      _activeControls.add(controlId);
    });

    // Provide haptic feedback
    HapticFeedback.lightImpact();
  }

  void _deactivateControl(String controlId) {
    setState(() {
      _activeControls.remove(controlId);
      _joystickPositions.remove(controlId);
    });
  }

  void _updateJoystick(String controlId, Offset position) {
    setState(() {
      _joystickPositions[controlId] = position;
    });

    // Provide subtle haptic feedback for joystick movement
    HapticFeedback.selectionClick();
  }
}
