import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String? linkText;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? valueColor;
  final Color? subtitleColor;
  final Color? linkColor;
  final double? height;
  final bool hasViewIcon;
  final Widget? customContent;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.linkText,
    this.backgroundColor,
    this.titleColor,
    this.valueColor,
    this.subtitleColor,
    this.linkColor,
    this.height,
    this.hasViewIcon = false,
    this.customContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com título e ícone de visualização
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: titleColor ?? const Color(0xFF1E293B),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasViewIcon) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.visibility_outlined,
                      size: 18,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ],
            ),

            if (customContent != null) ...[
              customContent!,
            ] else
              ...[
                if (value.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    value,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: valueColor ?? const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ],

            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: subtitleColor ?? const Color(0xFF64748B),
                ),
              ),
            ],

            if (linkText != null) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  // Handle link tap
                },
                child: Text(
                  linkText!,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: linkColor ?? const Color(0xFF3B82F6),
                    decoration: TextDecoration.underline,
                    decorationColor: linkColor ?? const Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
