import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/fineract_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';

class LoansScreen extends ConsumerStatefulWidget {
  const LoansScreen({super.key});

  @override
  ConsumerState<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends ConsumerState<LoansScreen> {
  bool _isLoading = true;
  List<dynamic> _loans = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLoans();
  }

  Future<void> _loadLoans() async {
    try {
      final client = ref.read(fineractClientProvider);
      final data = await client.getLoans();
      setState(() {
        _loans = data['loanAccounts'] as List<dynamic>? ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().split(':').first;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Crédito')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Simulador rápido ─────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppTheme.cardGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Crédito disponível',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'R\$ 5.000,00',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppTheme.primary,
                            ),
                            child: const Text('Contratar crédito'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Meus empréstimos',
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  if (_error != null)
                    Center(child: Text('Erro: $_error'))
                  else if (_loans.isEmpty)
                    _emptyState()
                  else
                    ..._loans.map((l) => _LoanCard(loan: l)),

                  const SizedBox(height: 24),

                  // ── Produtos de crédito ──────────────────────────
                  const Text(
                    'Produtos disponíveis',
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _ProductCard(
                    title: 'Empréstimo Pessoal',
                    subtitle: 'A partir de 1,99% a.m.',
                    icon: Icons.person_rounded,
                    color: AppTheme.primary,
                  ),
                  _ProductCard(
                    title: 'Crédito para Negócios',
                    subtitle: 'Até R\$ 50.000 para MEI',
                    icon: Icons.business_rounded,
                    color: const Color(0xFF059669),
                  ),
                  _ProductCard(
                    title: 'Antecipação de Recebíveis',
                    subtitle: 'Antecipe suas vendas',
                    icon: Icons.trending_up_rounded,
                    color: const Color(0xFFD97706),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.account_balance_outlined,
                size: 60, color: Colors.grey[400]),
            const SizedBox(height: 12),
            const Text(
              'Nenhum empréstimo ativo',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoanCard extends StatelessWidget {
  final dynamic loan;
  const _LoanCard({required this.loan});

  @override
  Widget build(BuildContext context) {
    final principal =
        (loan['principalDisbursed'] as num?)?.toDouble() ?? 0;
    final outstanding =
        (loan['totalOutstandingDerivedInDefaultCurrency'] as num?)
                ?.toDouble() ??
            0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                const Icon(Icons.account_balance_rounded, color: AppTheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loan['productName']?.toString() ?? 'Empréstimo',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Contratado: ${AppFormatters.currency(principal)}',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Saldo devedor',
                  style: TextStyle(
                      color: AppTheme.textSecondary, fontSize: 11)),
              Text(
                AppFormatters.currency(outstanding),
                style: const TextStyle(
                    color: AppTheme.error, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  const _ProductCard(
      {required this.title,
      required this.subtitle,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {},
      ),
    );
  }
}
