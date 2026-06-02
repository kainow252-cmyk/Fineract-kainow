import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../features/home/providers/account_provider.dart';

class ChargeScreen extends ConsumerStatefulWidget {
  const ChargeScreen({super.key});

  @override
  ConsumerState<ChargeScreen> createState() => _ChargeScreenState();
}

class _ChargeScreenState extends ConsumerState<ChargeScreen> {
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String? _qrData;
  bool _qrGenerated = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _generateQr() {
    final amount = _amountCtrl.text.trim();
    if (amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe o valor da cobrança')),
      );
      return;
    }
    final account = ref.read(accountProvider).account;
    // Simula payload PIX BR Code
    final pixPayload =
        '00020126580014br.gov.bcb.pix0136${account?.accountNo ?? 'chave-pix'}5204000053039865802BR5910MeuBanco6009SAO PAULO62070503***6304';
    setState(() {
      _qrData = pixPayload;
      _qrGenerated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Cobrar via PIX')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Formulário ─────────────────────────────────────────
            if (!_qrGenerated) ...[
              const Text(
                'Quanto deseja cobrar?',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  labelText: 'Valor (R\$)',
                  prefixIcon: Icon(Icons.attach_money_rounded),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Descrição (opcional)',
                  prefixIcon: Icon(Icons.notes_rounded),
                ),
              ),
              const SizedBox(height: 12),

              // Valores rápidos
              Wrap(
                spacing: 8,
                children: [10, 25, 50, 100, 200]
                    .map(
                      (v) => ActionChip(
                        label: Text('R\$ $v'),
                        onPressed: () =>
                            _amountCtrl.text = v.toString(),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _generateQr,
                  icon: const Icon(Icons.qr_code_rounded),
                  label: const Text('Gerar QR Code PIX'),
                ),
              ),
            ],

            // ── QR Code gerado ─────────────────────────────────────
            if (_qrGenerated && _qrData != null) ...[
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: AppTheme.success, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      'Cobrança de ${AppFormatters.currency(double.tryParse(_amountCtrl.text.replaceAll(',', '.')) ?? 0)}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 16)
                        ],
                      ),
                      child: QrImageView(
                        data: _qrData!,
                        version: QrVersions.auto,
                        size: 240,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Válido por 30 minutos',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.share_rounded),
                            label: const Text('Compartilhar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                setState(() => _qrGenerated = false),
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Nova cobrança'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
