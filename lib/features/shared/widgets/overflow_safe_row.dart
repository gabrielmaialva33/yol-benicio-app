import 'package:flutter/material.dart';

/// Widget que previne problemas de RenderFlex overflow em Rows
/// Usado para substituir Row em contextos que podem causar problemas de constraints
class OverflowSafeRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final EdgeInsetsGeometry? padding;

  const OverflowSafeRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget rowWidget = IntrinsicHeight(
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: children,
      ),
    );

    if (padding != null) {
      rowWidget = Padding(
        padding: padding!,
        child: rowWidget,
      );
    }

    return rowWidget;
  }
}

/// Widget que previne problemas de RenderFlex overflow em Columns
class OverflowSafeColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final EdgeInsetsGeometry? padding;

  const OverflowSafeColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget columnWidget = IntrinsicWidth(
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: children,
      ),
    );

    if (padding != null) {
      columnWidget = Padding(
        padding: padding!,
        child: columnWidget,
      );
    }

    return columnWidget;
  }
}
