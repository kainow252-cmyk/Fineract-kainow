import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Meu Cartão')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Cartão virtual ─────────────────────────────────────
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A237E), Color(0xFF7C3AED)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'MeuBanco',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.credit_card_rounded,
                          color: Colors.white.withOpacity(0.8), size: 32),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    '**** **** **** 4321',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TITULAR',
                              style: TextStyle(
                                  color: Colors.white60, fontSize: 10)),
                          Text('JOÃO DA SILVA',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('VALIDADE',
                              style: TextStyle(
                                  color: Colors.white60, fontSize: 10)),
                          Text('12/28',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('VISA',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Ações do cartão ────────────────────────────────────
            _CardAction(
              icon: Icons.lock_outlined,
              title: 'Bloquear cartão',
              subtitle: 'Temporariamente',
              color: AppTheme.warning,
              onTap: () {},
            ),
            _CardAction(
              icon: Icons.visibility_outlined,
              title: 'Ver dados completos',
              subtitle: 'Número, CVV e senha',
              color: AppTheme.primary,
              onTap: () {},
            ),
            _CardAction(
              icon: Icons.contactless_rounded,
              title: 'Pagamento por aproximação',
              subtitle: 'Ativado',
              color: AppTheme.success,
              onTap: () {},
            ),
            _CardAction(
              icon: Icons.shopping_cart_outlined,
              title: 'Compras online',
              subtitle: 'Ativado',
              color: AppTheme.accent,
              onTap: () {},
            ),
            _CardAction(
              icon: Icons.cancel_outlined,
              title: 'Cancelar cartão',
              subtitle: 'Permanente',
              color: AppTheme.error,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _CardAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _CardAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded,
            color: AppTheme.textSecondary),
      ),
    );
  }
}
