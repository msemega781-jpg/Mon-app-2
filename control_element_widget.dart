import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ControlElementWidget extends StatefulWidget {
  final Map<String, dynamic> controlData;
  final bool isSelected;
  final VoidCallback onTap;
  final Function(Offset) onDrag;
  final VoidCallback onLongPress;

  const ControlElementWidget({
    Key? key,
    required this.controlData,
    required this.isSelected,
    required this.onTap,
    required this.onDrag,
    required this.onLongPress,
  }) : super(key: key);

  @override
  State<ControlElementWidget> createState() => _ControlElementWidgetState();
}

class _ControlElementWidgetState extends State<ControlElementWidget> {
  Offset? _dragStartPosition;

  @override
  Widget build(BuildContext context) {
    final double elementSize = (widget.controlData['size'] as double) * 10.w;
    final double opacity = widget.controlData['opacity'] as double;
    final String type = widget.controlData['type'] as String;

    return Positioned(
      left: widget.controlData['x'] as double,
      top: widget.controlData['y'] as double,
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        onPanStart: (details) {
          _dragStartPosition = details.globalPosition;
        },
        onPanUpdate: (details) {
          if (_dragStartPosition != null) {
            final delta = details.globalPosition - _dragStartPosition!;
            widget.onDrag(delta);
            _dragStartPosition = details.globalPosition;
          }
        },
        child: Container(
          width: elementSize,
          height: elementSize,
          decoration: BoxDecoration(
            color: _getControlColor(type).withValues(alpha: opacity),
            borderRadius:
                BorderRadius.circular(type == 'joystick' ? elementSize / 2 : 8),
            border: widget.isSelected
                ? Border.all(color: AppTheme.accentColor, width: 2)
                : Border.all(
                    color: AppTheme.borderColor.withValues(alpha: 0.3),
                    width: 1),
            boxShadow: [
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
                child: _buildControlContent(type, elementSize),
              ),
              if (widget.isSelected) ..._buildResizeHandles(elementSize),
            ],
          ),
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

  Widget _buildControlContent(String type, double size) {
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
          widget.controlData['label'] as String? ?? 'A',
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

  List<Widget> _buildResizeHandles(double size) {
    return [
      // Top-left handle
      Positioned(
        top: -4,
        left: -4,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.accentColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
      // Top-right handle
      Positioned(
        top: -4,
        right: -4,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.accentColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
      // Bottom-left handle
      Positioned(
        bottom: -4,
        left: -4,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.accentColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
      // Bottom-right handle
      Positioned(
        bottom: -4,
        right: -4,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.accentColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    ];
  }
}
