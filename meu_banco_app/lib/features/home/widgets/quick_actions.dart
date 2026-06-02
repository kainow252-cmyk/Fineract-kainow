import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'O que deseja fazer?',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ActionButton(
              icon: Icons.pix_rounded,
              label: 'PIX',
              color: const Color(0xFF32BCAD),
              onTap: () => context.go('/transfer'),
            ),
            _ActionButton(
              icon: Icons.arrow_upward_rounded,
              label: 'Transferir',
              color: AppTheme.primary,
              onTap: () => context.go('/transfer'),
            ),
            _ActionButton(
              icon: Icons.qr_code_rounded,
              label: 'Cobrar',
              color: const Color(0xFF7C3AED),
              onTap: () => context.go('/charge'),
            ),
            _ActionButton(
              icon: Icons.receipt_long_rounded,
              label: 'Extrato',
              color: const Color(0xFFEA580C),
              onTap: () => context.go('/extract'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ActionButton(
              icon: Icons.credit_card_rounded,
              label: 'Cartão',
              color: const Color(0xFF0891B2),
              onTap: () => context.go('/cards'),
            ),
            _ActionButton(
              icon: Icons.account_balance_rounded,
              label: 'Crédito',
              color: const Color(0xFF059669),
              onTap: () => context.go('/loans'),
            ),
            _ActionButton(
              icon: Icons.bar_chart_rounded,
              label: 'Investir',
              color: const Color(0xFFD97706),
              onTap: () {},
            ),
            _ActionButton(
              icon: Icons.more_horiz_rounded,
              label: 'Mais',
              color: AppTheme.textSecondary,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
