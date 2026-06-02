import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../features/home/providers/account_provider.dart';
import '../../../features/home/widgets/transaction_item.dart';
import '../../../shared/widgets/loading_shimmer.dart';

class ExtractScreen extends ConsumerWidget {
  const ExtractScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Extrato'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(accountProvider.notifier).loadAccount(),
        child: Column(
          children: [
            // ── Resumo do mês ──────────────────────────────────────
            if (account.account != null)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppTheme.cardGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SummaryItem(
                      label: 'Entradas',
                      value: _calcEntradas(account.account!.transactions),
                      isPositive: true,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white30,
                    ),
                    _SummaryItem(
                      label: 'Saídas',
                      value: _calcSaidas(account.account!.transactions),
                      isPositive: false,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white30,
                    ),
                    _SummaryItem(
                      label: 'Saldo',
                      value: account.account!.balance,
                      isPositive: account.account!.balance >= 0,
                    ),
                  ],
                ),
              ),

            // ── Lista ──────────────────────────────────────────────
            Expanded(
              child: account.isLoading
                  ? const LoadingShimmer(itemCount: 8)
                  : account.account == null
                      ? const Center(child: Text('Sem dados'))
                      : account.account!.transactions.isEmpty
                          ? _empty()
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.only(bottom: 80),
                              itemCount:
                                  account.account!.transactions.length,
                              itemBuilder: (_, i) => TransactionItem(
                                transaction:
                                    account.account!.transactions[i],
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }

  double _calcEntradas(List<Transaction> txs) {
    return txs
        .where((t) => t.isCredit)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double _calcSaidas(List<Transaction> txs) {
    return txs
        .where((t) => !t.isCredit)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  Widget _empty() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'Nenhuma transação encontrada',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final double value;
  final bool isPositive;
  const _SummaryItem(
      {required this.label, required this.value, required this.isPositive});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          AppFormatters.currencyCompact(value),
          style: TextStyle(
            color: isPositive ? Colors.greenAccent : Colors.redAccent,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
