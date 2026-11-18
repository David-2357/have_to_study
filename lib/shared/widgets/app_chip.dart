import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_color_theme.dart';

/// Semantic variants available for [AppChip].
enum AppChipVariant {
  primary,
  success,
  warning,
  error,
  info,
  purple,
  teal,
  neutral,
  custom,
}

/// Centralized chip/tag/pill component across Have to Study.
///
/// Supports an optional [icon], customizable [content] or [label],
/// and semantic [variant] colors responsive to Light and Dark themes.
class AppChip extends StatelessWidget {
  /// Custom widget content (e.g. rich text, row, badge).
  /// If provided, [label] is ignored.
  final Widget? content;

  /// Text content if [content] is omitted.
  final String? label;

  /// Optional leading icon data.
  final IconData? icon;

  /// Optional custom leading icon widget (takes precedence over [icon]).
  final Widget? iconWidget;

  /// Semantic theme variant.
  final AppChipVariant variant;

  /// Custom background color (used when [variant] is [AppChipVariant.custom]
  /// or to explicitly override variant background).
  final Color? customBackgroundColor;

  /// Custom foreground color (used when [variant] is [AppChipVariant.custom]
  /// or to explicitly override text/icon color).
  final Color? customForegroundColor;

  /// Custom border color.
  final Color? customBorderColor;

  /// Padding inside the chip. Defaults to `EdgeInsets.symmetric(horizontal: 8, vertical: 3)`.
  final EdgeInsetsGeometry? padding;

  /// Border radius of the chip container. Defaults to `BorderRadius.circular(6)`.
  final BorderRadiusGeometry? borderRadius;

  /// Custom text style for the label.
  final TextStyle? textStyle;

  /// Size of the leading icon. Defaults to 12.
  final double iconSize;

  /// Spacing between icon and content. Defaults to 4.
  final double spacing;

  /// Optional tap handler for interactive chips.
  final VoidCallback? onTap;

  /// Whether to render as an outlined chip (transparent fill).
  final bool outlined;

  const AppChip({
    super.key,
    this.content,
    this.label,
    this.icon,
    this.iconWidget,
    this.variant = AppChipVariant.neutral,
    this.customBackgroundColor,
    this.customForegroundColor,
    this.customBorderColor,
    this.padding,
    this.borderRadius,
    this.textStyle,
    this.iconSize = 12,
    this.spacing = 4,
    this.onTap,
    this.outlined = false,
  }) : assert(content != null || label != null, 'Either content or label must be provided');

  /// Convenience constructor for text-only or text+icon chips.
  const AppChip.label({
    super.key,
    required String this.label,
    this.icon,
    this.iconWidget,
    this.variant = AppChipVariant.neutral,
    this.customBackgroundColor,
    this.customForegroundColor,
    this.customBorderColor,
    this.padding,
    this.borderRadius,
    this.textStyle,
    this.iconSize = 12,
    this.spacing = 4,
    this.onTap,
    this.outlined = false,
  }) : content = null;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = colors.isDark;

    final resolvedColors = _resolveColors(colors, isDark);
    final effectiveBg = outlined
        ? Colors.transparent
        : (customBackgroundColor ?? resolvedColors.background);
    final effectiveFg = customForegroundColor ?? resolvedColors.foreground;
    final effectiveBorderRadius = (borderRadius ?? BorderRadius.circular(6)) as BorderRadius;

    Border? effectiveBorder;
    if (outlined || customBorderColor != null) {
      effectiveBorder = Border.all(
        color: customBorderColor ?? effectiveFg.withValues(alpha: 0.35),
        width: 1,
      );
    }

    final effectiveTextStyle = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: effectiveFg,
    ).merge(textStyle);

    Widget effectiveChild;
    if (content != null) {
      effectiveChild = content!;
    } else {
      effectiveChild = Text(
        label!,
        style: effectiveTextStyle,
      );
    }

    Widget? leading;
    if (iconWidget != null) {
      leading = iconWidget;
    } else if (icon != null) {
      leading = Icon(
        icon,
        size: iconSize,
        color: effectiveFg,
      );
    }

    Widget inner;
    if (leading != null) {
      inner = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leading,
          SizedBox(width: spacing),
          Flexible(child: effectiveChild),
        ],
      );
    } else {
      inner = effectiveChild;
    }

    final container = Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: effectiveBorderRadius,
        border: effectiveBorder,
      ),
      child: inner,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: effectiveBorderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          child: container,
        ),
      );
    }

    return container;
  }

  _ChipColors _resolveColors(AppColorTheme colors, bool isDark) {
    switch (variant) {
      case AppChipVariant.primary:
        return _ChipColors(
          background: isDark
              ? AppColors.primary.withValues(alpha: 0.25)
              : AppColors.primaryLight,
          foreground: isDark ? const Color(0xFFF87171) : AppColors.primary,
        );
      case AppChipVariant.success:
        return _ChipColors(
          background: isDark
              ? AppColors.success.withValues(alpha: 0.22)
              : AppColors.successLight,
          foreground: isDark ? const Color(0xFF86EFAC) : AppColors.success,
        );
      case AppChipVariant.warning:
        return _ChipColors(
          background: isDark
              ? const Color(0xFFF59E0B).withValues(alpha: 0.22)
              : const Color(0xFFFEF3C7),
          foreground: isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
        );
      case AppChipVariant.error:
        return _ChipColors(
          background: isDark
              ? AppColors.exam.withValues(alpha: 0.22)
              : AppColors.examLight,
          foreground: isDark ? const Color(0xFFFCA5A5) : AppColors.exam,
        );
      case AppChipVariant.info:
        return _ChipColors(
          background: isDark
              ? const Color(0xFF4F46E5).withValues(alpha: 0.22)
              : const Color(0xFFEEF2FF),
          foreground: isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
        );
      case AppChipVariant.purple:
        return _ChipColors(
          background: isDark
              ? AppColors.purple.withValues(alpha: 0.22)
              : AppColors.purpleLight,
          foreground: isDark ? const Color(0xFFD8B4FE) : AppColors.purple,
        );
      case AppChipVariant.teal:
        return _ChipColors(
          background: isDark
              ? AppColors.teal.withValues(alpha: 0.22)
              : AppColors.tealLight,
          foreground: isDark ? const Color(0xFF5EEAD4) : AppColors.teal,
        );
      case AppChipVariant.neutral:
        return _ChipColors(
          background: colors.surfaceVariant,
          foreground: colors.textSecondary,
        );
      case AppChipVariant.custom:
        return _ChipColors(
          background: customBackgroundColor ?? colors.surfaceVariant,
          foreground: customForegroundColor ?? colors.textPrimary,
        );
    }
  }
}

class _ChipColors {
  final Color background;
  final Color foreground;

  const _ChipColors({
    required this.background,
    required this.foreground,
  });
}
