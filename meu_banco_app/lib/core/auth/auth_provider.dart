import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/fineract_client.dart';
import '../../core/storage/secure_storage.dart';

// ─── Estado de autenticação ───────────────────────────────────────────
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final String? token;
  final String? displayName;
  final int? userId;
  final int? clientId;
  final int? accountId;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.token,
    this.displayName,
    this.userId,
    this.clientId,
    this.accountId,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? token,
    String? displayName,
    int? userId,
    int? clientId,
    int? accountId,
    String? errorMessage,
  }) =>
      AuthState(
        status: status ?? this.status,
        token: token ?? this.token,
        displayName: displayName ?? this.displayName,
        userId: userId ?? this.userId,
        clientId: clientId ?? this.clientId,
        accountId: accountId ?? this.accountId,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  bool get isAuthenticated => status == AuthStatus.authenticated;
}

// ─── Notifier (Riverpod v3 — AsyncNotifier) ───────────────────────────
class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    return _loadFromStorage();
  }

  Future<AuthState> _loadFromStorage() async {
    final loggedIn = await SecureStorage.isLoggedIn();
    if (loggedIn) {
      final displayName = await SecureStorage.getDisplayName();
      final userId = await SecureStorage.getUserId();
      final clientId = await SecureStorage.getClientId();
      final accountId = await SecureStorage.getAccountId();
      return AuthState(
        status: AuthStatus.authenticated,
        displayName: displayName,
        userId: userId,
        clientId: clientId,
        accountId: accountId,
      );
    }
    return const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<bool> login(String username, String password) async {
    state = const AsyncValue.loading();
    try {
      final client = ref.read(fineractClientProvider);
      final data = await client.login(username, password);

      final token = data['base64EncodedAuthenticationKey'] as String?;
      final userId = data['userId'] as int?;
      final clientId = data['clientId'] as int?;
      final officeId = data['officeId'] as int?;
      final displayName = data['username'] as String? ?? username;

      if (token == null) {
        state = AsyncValue.data(const AuthState(
          status: AuthStatus.error,
          errorMessage: 'Token não recebido do servidor',
        ));
        return false;
      }

      await SecureStorage.saveToken(token);
      await SecureStorage.saveUserData(
        username: username,
        userId: userId ?? 0,
        clientId: clientId ?? 0,
        officeId: officeId ?? 1,
        displayName: displayName,
      );

      state = AsyncValue.data(AuthState(
        status: AuthStatus.authenticated,
        token: token,
        displayName: displayName,
        userId: userId,
        clientId: clientId,
      ));
      return true;
    } catch (e) {
      String msg = 'Erro ao fazer login';
      if (e.toString().contains('401')) {
        msg = 'Usuário ou senha incorretos';
      } else if (e.toString().contains('SocketException')) {
        msg = 'Sem conexão com a internet';
      }
      state = AsyncValue.data(AuthState(
        status: AuthStatus.error,
        errorMessage: msg,
      ));
      return false;
    }
  }

  Future<void> logout() async {
    await SecureStorage.clearAll();
    state =
        const AsyncValue.data(AuthState(status: AuthStatus.unauthenticated));
  }
}

// ─── Provider ─────────────────────────────────────────────────────────
final authProvider =
    AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
