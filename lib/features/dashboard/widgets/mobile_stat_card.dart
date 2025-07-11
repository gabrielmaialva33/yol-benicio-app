import 'package:flutter/material.dart';

class MobileStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String? additionalInfo;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? valueColor;
  final Color? subtitleColor;
  final Color? infoColor;
  final double? height;
  final bool isRevenueCard;

  const MobileStatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.additionalInfo,
    this.backgroundColor,
    this.titleColor,
    this.valueColor,
    this.subtitleColor,
    this.infoColor,
    this.height,
    this.isRevenueCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? (isRevenueCard ? 168 : 129),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: titleColor ?? const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),

          // Valor principal
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isRevenueCard ? 24 : 28,
              fontWeight: FontWeight.w700,
              color: valueColor ?? const Color(0xFF1E293B),
            ),
          ),

          if (subtitle != null) ...[
            const SizedBox(height: 4),
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

          if (additionalInfo != null && isRevenueCard) ...[
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                additionalInfo!,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: infoColor ?? const Color(0xFFEF4444),
                ),
              ),
            ),
          ] else
            if (additionalInfo != null) ...[
              const SizedBox(height: 4),
              Text(
                additionalInfo!,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: infoColor ?? const Color(0xFF64748B),
                ),
              ),
            ],
        ],
      ),
    );
  }
}

// Widget especializado para estatísticas de pastas
class FolderStatCard extends StatelessWidget {
  final String activeValue;
  final String closedValue;
  final String totalValue;
  final String deliveredValue;
  final String delayedValue;

  const FolderStatCard({
    super.key,
    required this.activeValue,
    required this.closedValue,
    required this.totalValue,
    required this.deliveredValue,
    required this.delayedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título principal
          const Text(
            'Pastas',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),

          // Linha com Ativas e Fechadas
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activeValue,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const Text(
                      'Ativas',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      closedValue,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const Text(
                      'Fechadas',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Total
          Text(
            totalValue,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const Text(
            'Total',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),

          // Linha com Entregues e Atrasadas
          Row(
            children: [
              Text(
                deliveredValue,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF10B981),
                ),
              ),
              const Text(
                ' entregues, ',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                delayedValue,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFEF4444),
                ),
              ),
              const Text(
                ' atrasadas',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
