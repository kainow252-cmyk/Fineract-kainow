import 'package:intl/intl.dart';

class AppFormatters {
  // ── Moeda BRL ──────────────────────────────────────────────────────
  static final _currencyFormatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  static String currency(double value) =>
      _currencyFormatter.format(value);

  static String currencyCompact(double value) {
    if (value >= 1000000) {
      return 'R\$ ${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return 'R\$ ${(value / 1000).toStringAsFixed(1)}K';
    }
    return currency(value);
  }

  // ── Datas ──────────────────────────────────────────────────────────
  static final _dateFull = DateFormat('dd/MM/yyyy', 'pt_BR');
  static final _dateShort = DateFormat('dd/MM', 'pt_BR');
  static final _dateTime = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR');
  static final _monthYear = DateFormat('MMMM yyyy', 'pt_BR');

  static String dateFull(DateTime date) => _dateFull.format(date);
  static String dateShort(DateTime date) => _dateShort.format(date);
  static String dateTime(DateTime date) => _dateTime.format(date);
  static String monthYear(DateTime date) => _monthYear.format(date);

  static DateTime? parseDate(List<int>? arr) {
    if (arr == null || arr.isEmpty) return null;
    try {
      return DateTime(arr[0], arr[1], arr[2]);
    } catch (_) {
      return null;
    }
  }

  // ── CPF / CNPJ ────────────────────────────────────────────────────
  static String cpf(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 11) return raw;
    return '${digits.substring(0, 3)}.'
        '${digits.substring(3, 6)}.'
        '${digits.substring(6, 9)}-'
        '${digits.substring(9)}';
  }

  static String maskedCpf(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 11) return raw;
    return '***.'
        '${digits.substring(3, 6)}.'
        '${digits.substring(6, 9)}-**';
  }

  // ── Número de conta ───────────────────────────────────────────────
  static String accountNumber(int id) =>
      id.toString().padLeft(8, '0');

  // ── Saldo mascarado ───────────────────────────────────────────────
  static String maskedBalance() => 'R\$ ••••••';

  // ── Tipo de transação ─────────────────────────────────────────────
  static String transactionType(String type) {
    switch (type.toLowerCase()) {
      case 'deposit':
        return 'Depósito';
      case 'withdrawal':
        return 'Saque';
      case 'transfer':
        return 'Transferência';
      case 'interest posting':
        return 'Rendimento';
      case 'fee deduction':
        return 'Tarifa';
      case 'pix':
        return 'PIX';
      default:
        return type;
    }
  }

  // ── Greeting ───────────────────────────────────────────────────────
  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia';
    if (hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }
}
