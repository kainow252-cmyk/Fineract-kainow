import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../providers/account_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/transaction_item.dart';
import '../../../shared/widgets/loading_shimmer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authProvider);
    final auth = authAsync.value ?? const AuthState();
    final account = ref.watch(accountProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: RefreshIndicator(
        color: AppTheme.primary,
        onRefresh: () => ref.read(accountProvider.notifier).loadAccount(),
        child: CustomScrollView(
          slivers: [
            // ── AppBar ──────────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 0,
              floating: true,
              backgroundColor: AppTheme.primary,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppFormatters.greeting(),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    auth.displayName ?? 'Bem-vindo',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded,
                      color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const CircleAvatar(
                    backgroundColor: Colors.white24,
                    radius: 16,
                    child: Icon(Icons.person, color: Colors.white, size: 20),
                  ),
                  onPressed: () => context.go('/profile'),
                ),
                const SizedBox(width: 8),
              ],
            ),

            // ── Conteúdo ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cartão de saldo
                  if (account.isLoading)
                    const _BalanceShimmer()
                  else if (account.account != null)
                    BalanceCard(account: account.account!)
                  else if (account.error != null)
                    _ErrorCard(message: account.error!),

                  const SizedBox(height: 24),

                  // Ações rápidas
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: QuickActions(),
                  ),

                  const SizedBox(height: 28),

                  // Extrato recente
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Extrato recente',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go('/extract'),
                          child: const Text('Ver tudo'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Lista de transações
                  if (account.isLoading)
                    const LoadingShimmer(itemCount: 4)
                  else if (account.account != null)
                    _TransactionList(account: account.account!)
                  else
                    const _EmptyTransactions(),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Widgets locais ───────────────────────────────────────────────────

class _BalanceShimmer extends StatelessWidget {
  const _BalanceShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off_rounded, color: AppTheme.error),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sem conexão',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.error,
                  ),
                ),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionList extends StatelessWidget {
  final account;
  const _TransactionList({required this.account});

  @override
  Widget build(BuildContext context) {
    final txs = account.transactions as List;
    if (txs.isEmpty) return const _EmptyTransactions();
    final recent = txs.take(5).toList();
    return Column(
      children: recent
          .map((t) => TransactionItem(transaction: t))
          .toList(),
    );
  }
}

class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 60, color: Colors.grey[400]),
            const SizedBox(height: 12),
            const Text(
              'Nenhuma transação ainda',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
