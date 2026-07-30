import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../theme/app_typography.dart';

/// Shared text input — height/radius come from [AppSizes].
class AppInputField extends StatelessWidget {
  const AppInputField({
    super.key,
    required this.controller,
    this.hint,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.height = AppSizes.inputHeight,
    this.isPill = false,
    this.showBorder = true,
    this.borderColor,
    this.fillColor = const Color(0xFF121212),
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String? hint;
  final Widget? prefix;
  final Widget? suffix;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final double height;
  final bool isPill;
  final bool showBorder;
  final Color? borderColor;
  final Color fillColor;
  final int maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final double radius =
        isPill ? AppSizes.inputRadiusPill : AppSizes.inputRadius;
    final bool isMultiline = maxLines > 1;
    final Widget? leading = prefix ??
        (prefixIcon == null
            ? null
            : Icon(
                prefixIcon,
                color: AppColors.goldColor,
                size: AppSizes.inputIconSize,
              ));
    final Widget? trailing = suffix ??
        (suffixIcon == null
            ? null
            : Icon(
                suffixIcon,
                color: AppColors.hint,
                size: AppSizes.inputIconSize,
              ));
    return Container(
      height: isMultiline ? null : height,
      constraints: isMultiline
          ? BoxConstraints(minHeight: height)
          : BoxConstraints.tightFor(height: height),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(radius),
        border: showBorder
            ? Border.all(
                color: borderColor ??
                    AppColors.goldColor.withValues(alpha: 0.35),
                width: 1,
              )
            : null,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.inputHorizontalPadding,
        vertical: isMultiline ? 12 : 0,
      ),
      alignment: isMultiline ? Alignment.topLeft : Alignment.center,
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[
            leading,
            const SizedBox(width: 10),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              obscureText: obscureText,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              autocorrect: false,
              enabled: enabled,
              maxLines: obscureText ? 1 : maxLines,
              maxLength: maxLength,
              textAlign: textAlign,
              inputFormatters: inputFormatters,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: AppTypography.body(color: AppColors.onSurface),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTypography.body(color: AppColors.hint),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                counterText: '',
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing,
          ],
        ],
      ),
    );
  }
}
