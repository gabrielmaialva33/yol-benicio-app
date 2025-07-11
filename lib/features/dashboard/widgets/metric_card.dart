import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<MetricItem> metrics;
  final Widget? icon;
  final String? linkText;
  final VoidCallback? onLinkTap;

  const MetricCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.metrics,
    this.icon,
    this.linkText,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5E6278),
                        ),
                      ),
                    ],
                  ),
                ),
                if (icon != null) icon!,
              ],
            ),
            const SizedBox(height: 24),
            // Métricas em linha
            Row(
              children: [
                for (int i = 0; i < metrics.length; i++) ...[
                  Expanded(
                    child: _buildMetricItem(metrics[i]),
                  ),
                  if (i < metrics.length - 1) const SizedBox(width: 32),
                ],
              ],
            ),
            if (linkText != null) ...[
              const SizedBox(height: 16),
              GestureDetector(
                onTap: onLinkTap,
                child: Text(
                  linkText!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF06B6D4),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(MetricItem metric) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          metric.value,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: metric.valueColor ?? const Color(0xFF1F2A37),
            height: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          metric.label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF5E6278),
          ),
        ),
      ],
    );
  }
}

class MetricItem {
  final String label;
  final String value;
  final Color? valueColor;

  MetricItem({
    required this.label,
    required this.value,
    this.valueColor,
  });
}