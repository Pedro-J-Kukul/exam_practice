// File: lib/widgets/common/custom_card.dart

import 'package:flutter/material.dart';
import '../../utils/app_constants.dart';

/// Reusable card widget with consistent styling
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final double? elevation;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: elevation ?? AppConstants.elevationS,
      color: color,
      child: Padding(padding: padding ?? AppConstants.paddingAll, child: child),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        child: card,
      );
    }

    return card;
  }
}
