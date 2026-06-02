import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/fineract_client.dart';
import '../../../core/storage/secure_storage.dart';

// ─── Models ───────────────────────────────────────────────────────────
class SavingsAccount {
  final int id;
  final String accountNo;
  final double balance;
  final String status;
  final String productName;
  final String currency;
  final List<Transaction> transactions;

  const SavingsAccount({
    required this.id,
    required this.accountNo,
    required this.balance,
    required this.status,
    required this.productName,
    required this.currency,
    this.transactions = const [],
  });

  factory SavingsAccount.fromJson(Map<String, dynamic> j) {
    final summary = j['summary'] as Map<String, dynamic>?;
    final balance =
        (summary?['availableBalance'] as num?)?.toDouble() ?? 0.0;

    final txList = (j['transactions'] as List<dynamic>?)
            ?.map((t) => Transaction.fromJson(t as Map<String, dynamic>))
            .toList() ??
        [];

    return SavingsAccount(
      id: j['id'] as int,
      accountNo: j['accountNo'] as String? ?? '',
      balance: balance,
      status: (j['status'] as Map?)
              ?.entries
              .firstWhere((e) => e.key == 'value',
                  orElse: () => const MapEntry('value', 'Ativo'))
              .value
              .toString() ??
          'Ativo',
      productName: j['productName'] as String? ?? 'Conta Digital',
      currency: (j['currency'] as Map?)
              ?.entries
              .firstWhere((e) => e.key == 'code',
                  orElse: () => const MapEntry('code', 'BRL'))
              .value
              .toString() ??
          'BRL',
      transactions: txList,
    );
  }
}

class Transaction {
  final int id;
  final String type;
  final double amount;
  final DateTime date;
  final String? note;
  final bool isCredit;

  const Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    this.note,
    required this.isCredit,
  });

  factory Transaction.fromJson(Map<String, dynamic> j) {
    final typeMap = j['transactionType'] as Map<String, dynamic>?;
    final typeName = typeMap?['value']?.toString() ?? 'Transação';
    final isCredit = typeMap?['deposit'] == true ||
        typeMap?['credit'] == true ||
        typeName.toLowerCase().contains('deposit') ||
        typeName.toLowerCase().contains('interest');

    final dateArr = j['date'] as List<dynamic>?;
    DateTime date = DateTime.now();
    if (dateArr != null && dateArr.length >= 3) {
      date = DateTime(
          dateArr[0] as int, dateArr[1] as int, dateArr[2] as int);
    }

    return Transaction(
      id: j['id'] as int,
      type: typeName,
      amount: (j['amount'] as num?)?.toDouble() ?? 0.0,
      date: date,
      note: j['note']?.toString(),
      isCredit: isCredit,
    );
  }
}

// ─── State ────────────────────────────────────────────────────────────
class AccountState {
  final bool isLoading;
  final SavingsAccount? account;
  final String? error;
  final bool balanceVisible;

  const AccountState({
    this.isLoading = false,
    this.account,
    this.error,
    this.balanceVisible = true,
  });

  AccountState copyWith({
    bool? isLoading,
    SavingsAccount? account,
    String? error,
    bool? balanceVisible,
  }) =>
      AccountState(
        isLoading: isLoading ?? this.isLoading,
        account: account ?? this.account,
        error: error,
        balanceVisible: balanceVisible ?? this.balanceVisible,
      );
}

// ─── Notifier (Riverpod v3) ───────────────────────────────────────────
class AccountNotifier extends Notifier<AccountState> {
  @override
  AccountState build() {
    loadAccount();
    return const AccountState(isLoading: true);
  }

  Future<void> loadAccount() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final client = ref.read(fineractClientProvider);
      final accountsData = await client.getAccounts();
      final list =
          accountsData['savingsAccounts'] as List<dynamic>? ?? [];

      if (list.isEmpty) {
        state = state.copyWith(
            isLoading: false, error: 'Nenhuma conta encontrada');
        return;
      }

      final first = list.first as Map<String, dynamic>;
      final accountId = first['id'] as int;

      await SecureStorage.saveUserData(
        username: await SecureStorage.getUsername() ?? '',
        userId: await SecureStorage.getUserId() ?? 0,
        clientId: await SecureStorage.getClientId() ?? 0,
        officeId: 1,
        displayName: await SecureStorage.getDisplayName() ?? '',
        accountId: accountId,
      );

      final details = await client.getAccountDetails(accountId);
      state = state.copyWith(
        isLoading: false,
        account: SavingsAccount.fromJson(details),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erro ao carregar conta',
      );
    }
  }

  void toggleBalanceVisibility() {
    state = state.copyWith(balanceVisible: !state.balanceVisible);
  }

  Future<void> deposit(double amount, String description) async {
    final accountId = state.account?.id;
    if (accountId == null) return;
    final client = ref.read(fineractClientProvider);
    await client.deposit(accountId, amount, description);
    await loadAccount();
  }

  Future<void> withdraw(double amount, String description) async {
    final accountId = state.account?.id;
    if (accountId == null) return;
    final client = ref.read(fineractClientProvider);
    await client.withdraw(accountId, amount, description);
    await loadAccount();
  }
}

// ─── Provider ─────────────────────────────────────────────────────────
final accountProvider =
    NotifierProvider<AccountNotifier, AccountState>(AccountNotifier.new);
