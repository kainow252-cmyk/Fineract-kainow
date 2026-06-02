import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/theme/app_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authProvider);
    final auth = authAsync.value ?? const AuthState();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: AppTheme.cardGradient,
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white, size: 44),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    auth.displayName ?? 'Usuário',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Cliente MeuBanco',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Opções ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle('Minha conta'),
                  _ProfileItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Dados pessoais',
                    onTap: () {},
                  ),
                  _ProfileItem(
                    icon: Icons.key_rounded,
                    title: 'Chaves PIX',
                    onTap: () {},
                  ),
                  _ProfileItem(
                    icon: Icons.location_on_outlined,
                    title: 'Endereço',
                    onTap: () {},
                  ),

                  const SizedBox(height: 8),
                  const _SectionTitle('Segurança'),
                  _ProfileItem(
                    icon: Icons.lock_outline_rounded,
                    title: 'Alterar senha',
                    onTap: () {},
                  ),
                  _ProfileItem(
                    icon: Icons.fingerprint_rounded,
                    title: 'Biometria',
                    trailing: Switch(
                      value: true,
                      onChanged: (_) {},
                      activeColor: AppTheme.primary,
                    ),
                  ),
                  _ProfileItem(
                    icon: Icons.shield_outlined,
                    title: 'Autenticação em 2 fatores',
                    trailing: Switch(
                      value: false,
                      onChanged: (_) {},
                      activeColor: AppTheme.primary,
                    ),
                  ),

                  const SizedBox(height: 8),
                  const _SectionTitle('Configurações'),
                  _ProfileItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notificações',
                    onTap: () {},
                  ),
                  _ProfileItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Ajuda e suporte',
                    onTap: () {},
                  ),
                  _ProfileItem(
                    icon: Icons.info_outline_rounded,
                    title: 'Sobre o app',
                    onTap: () {},
                  ),

                  const SizedBox(height: 16),

                  // Sair
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Sair da conta?'),
                            content: const Text(
                                'Você será desconectado do aplicativo.'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: const Text('Cancelar'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.error),
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                child: const Text('Sair'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await ref
                              .read(authProvider.notifier)
                              .logout();
                          if (context.mounted) {
                            context.go('/login');
                          }
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.error,
                        side: const BorderSide(color: AppTheme.error),
                      ),
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Sair da conta'),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppTheme.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _ProfileItem({
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        onTap: onTap,
        tileColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon, color: AppTheme.primary, size: 22),
        title: Text(title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        trailing: trailing ??
            (onTap != null
                ? const Icon(Icons.chevron_right_rounded,
                    color: AppTheme.textSecondary)
                : null),
      ),
    );
  }
}
