import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final String iconName;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool showError;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.iconName,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    required this.controller,
    this.validator,
    this.showError = false,
    this.errorText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          height: 6.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: widget.showError
                  ? AppTheme.errorColor
                  : _isFocused
                      ? AppTheme.accentColor
                      : AppTheme.borderColor.withValues(alpha: 0.5),
              width: _isFocused ? 2 : 1,
            ),
          ),
          child: Focus(
            onFocusChange: (hasFocus) {
              setState(() {
                _isFocused = hasFocus;
              });
            },
            child: TextFormField(
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              obscureText: widget.isPassword ? _obscureText : false,
              validator: widget.validator,
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textDisabled,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: widget.iconName,
                    color: _isFocused
                        ? AppTheme.accentColor
                        : AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: CustomIconWidget(
                          iconName:
                              _obscureText ? 'visibility' : 'visibility_off',
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 1.5.h,
                ),
                fillColor: AppTheme.surfaceColor,
                filled: true,
              ),
            ),
          ),
        ),
        widget.showError && widget.errorText != null
            ? Padding(
                padding: EdgeInsets.only(top: 0.5.h, left: 2.w),
                child: Text(
                  widget.errorText!,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.errorColor,
                    fontSize: 10.sp,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
