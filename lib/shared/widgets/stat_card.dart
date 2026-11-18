import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_color_theme.dart';
import 'app_chip.dart';

/// Centralized statistics / metric card component used across Have to Study.
///
/// Features a header title with an icon in the upper right corner,
/// primary metric value (text or widget), and optional subtitle, badge,
/// or progress indicator. Fully reactive to Light and Dark themes.
class StatCard extends StatelessWidget {
  /// Category/metric title at the top left (e.g. "TIEMPO TOTAL", "RACHA DE HOY").
  final String title;

  /// Primary metric value display (e.g. "3h 45m", "8 bloques").
  final String value;

  /// Optional custom widget if rich text or custom layout is needed for the value.
  final Widget? valueWidget;

  /// Corner icon.
  final IconData icon;

  /// Base semantic color for the icon. Automatically adjusted for dark theme contrast.
  final Color iconColor;

  /// Optional explicit background for the icon circle in light mode.
  final Color? iconBg;

  /// Whether to render the corner icon in a circular container. Defaults to true.
  final bool showIconContainer;

  /// Subtitle or descriptive metadata text below the value.
  final String? subtitle;

  /// Optional color for [subtitle]. Defaults to [colors.textSecondary].
  final Color? subtitleColor;

  /// Optional leading icon for the subtitle (e.g. trending up/down).
  final IconData? subtitleIcon;

  /// Whether to render [subtitle] inside an [AppChip] badge.
  final bool hasBadge;

  /// Semantic variant for the subtitle badge if [hasBadge] is true. Defaults to [AppChipVariant.info].
  final AppChipVariant badgeVariant;

  /// Optional progress bar value (0.0 to 1.0).
  final double? progress;

  /// Color of the progress bar value. Defaults to [AppColors.primary].
  final Color? progressColor;

  /// Card internal padding. Defaults to `EdgeInsets.all(14)`.
  final EdgeInsetsGeometry padding;

  /// Corner radius of the card. Defaults to 18.
  final double borderRadius;

  /// Primary value font size. Defaults to 22.
  final double valueFontSize;

  /// Whether to wrap the card in an [Expanded] widget for horizontal rows. Defaults to false.
  final bool isExpanded;

  /// Optional tap callback for interactive cards.
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    this.value = '',
    this.valueWidget,
    required this.icon,
    required this.iconColor,
    this.iconBg,
    this.showIconContainer = true,
    this.subtitle,
    this.subtitleColor,
    this.subtitleIcon,
    this.hasBadge = false,
    this.badgeVariant = AppChipVariant.info,
    this.progress,
    this.progressColor,
    this.padding = const EdgeInsets.all(14),
    this.borderRadius = 18,
    this.valueFontSize = 22,
    this.isExpanded = false,
    this.onTap,
  });

  Color _resolveIconColor(bool isDark) {
    if (!isDark) return iconColor;
    if (iconColor == AppColors.primary || iconColor == const Color(0xFFC0392B)) {
      return const Color(0xFFF87171);
    }
    if (iconColor == AppColors.teal || iconColor == const Color(0xFF16A085)) {
      return const Color(0xFF5EEAD4);
    }
    if (iconColor == AppColors.info || iconColor == const Color(0xFF2980B9)) {
      return const Color(0xFF60A5FA);
    }
    if (iconColor == const Color(0xFF4F46E5) || iconColor == const Color(0xFF818CF8)) {
      return const Color(0xFF818CF8);
    }
    if (iconColor == const Color(0xFF9333EA) || iconColor == const Color(0xFF8B5CF6) || iconColor == AppColors.purple) {
      return const Color(0xFFD8B4FE);
    }
    if (iconColor == const Color(0xFFEA580C) || iconColor == const Color(0xFFE67E22)) {
      return const Color(0xFFFBBF24);
    }
    return iconColor;
  }

  Color _resolveIconBg(bool isDark, Color effectiveIconColor) {
    if (isDark) {
      return effectiveIconColor.withValues(alpha: 0.22);
    }
    if (iconBg != null) {
      return iconBg!;
    }
    if (iconColor == AppColors.primary) {
      return AppColors.primaryLight;
    }
    if (iconColor == AppColors.teal) {
      return AppColors.tealLight;
    }
    if (iconColor == AppColors.info) {
      return const Color(0xFFEBF5FB);
    }
    return iconColor.withValues(alpha: 0.12);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = colors.isDark;

    final effectiveIconColor = _resolveIconColor(isDark);
    final effectiveIconBg = _resolveIconBg(isDark, effectiveIconColor);

    final cardChild = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fila Superior: Título y Corner Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: colors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              if (showIconContainer)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: effectiveIconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: effectiveIconColor, size: 14),
                )
              else
                Icon(icon, color: effectiveIconColor, size: 14),
            ],
          ),

          const SizedBox(height: 8),

          // Valor Principal
          if (valueWidget != null)
            valueWidget!
          else
            Text(
              value,
              style: TextStyle(
                fontSize: valueFontSize,
                fontWeight: FontWeight.w900,
                color: colors.textPrimary,
                letterSpacing: -0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

          // Barra de progreso opcional
          if (progress != null) ...[
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progress!.clamp(0.0, 1.0),
                backgroundColor: isDark ? colors.surfaceVariant : const Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation<Color>(progressColor ?? AppColors.primary),
                minHeight: 4,
              ),
            ),
          ],

          // Subtítulo / Métrica secundaria / Badge
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            const SizedBox(height: 4),
            if (hasBadge)
              AppChip(
                label: subtitle!,
                variant: badgeVariant,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                borderRadius: BorderRadius.circular(6),
                textStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (subtitleIcon != null) ...[
                    Icon(
                      subtitleIcon,
                      size: 12,
                      color: subtitleColor ?? colors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Flexible(
                    child: Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: subtitleColor ?? colors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
          ],
        ],
      ),
    );

    final finalWidget = onTap != null
        ? Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius),
              child: cardChild,
            ),
          )
        : cardChild;

    return isExpanded ? Expanded(child: finalWidget) : finalWidget;
  }
}
