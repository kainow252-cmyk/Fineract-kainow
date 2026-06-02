import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/secure_storage.dart';

// ─── Configuração ────────────────────────────────────────────────────
const String kBaseUrl =
    'https://demo.fineract.dev/fineract-provider/api/v1';
const String kTenantId = 'default';

// ─── Provider ────────────────────────────────────────────────────────
final fineractClientProvider = Provider<FineractClient>((ref) {
  return FineractClient();
});

// ─── Cliente HTTP ─────────────────────────────────────────────────────
class FineractClient {
  late final Dio _dio;

  FineractClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: kBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Fineract-Platform-TenantId': kTenantId,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(_AuthInterceptor());
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  // ── Autenticação ───────────────────────────────────────────────────
  Future<Map<String, dynamic>> login(
      String username, String password) async {
    final credentials =
        'Basic ${_encodeBase64('$username:$password')}';
    final response = await _dio.post(
      '/authentication',
      options: Options(headers: {'Authorization': credentials}),
    );
    return response.data as Map<String, dynamic>;
  }

  // ── Clientes (Self-Service) ────────────────────────────────────────
  Future<Map<String, dynamic>> getClientProfile() async {
    final response = await _dio.get('/self/clients');
    return response.data as Map<String, dynamic>;
  }

  // ── Contas Poupança ───────────────────────────────────────────────
  Future<Map<String, dynamic>> getAccounts() async {
    final response = await _dio.get('/self/savingsaccounts');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAccountDetails(int accountId) async {
    final response = await _dio.get(
      '/self/savingsaccounts/$accountId',
      queryParameters: {'associations': 'transactions'},
    );
    return response.data as Map<String, dynamic>;
  }

  // ── Transações ────────────────────────────────────────────────────
  Future<Map<String, dynamic>> deposit(
      int accountId, double amount, String description) async {
    final response = await _dio.post(
      '/savingsaccounts/$accountId/transactions',
      queryParameters: {'command': 'deposit'},
      data: {
        'transactionDate': _today(),
        'transactionAmount': amount,
        'locale': 'pt',
        'dateFormat': 'dd/MM/yyyy',
        'paymentTypeId': 1,
        'note': description,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> withdraw(
      int accountId, double amount, String description) async {
    final response = await _dio.post(
      '/savingsaccounts/$accountId/transactions',
      queryParameters: {'command': 'withdrawal'},
      data: {
        'transactionDate': _today(),
        'transactionAmount': amount,
        'locale': 'pt',
        'dateFormat': 'dd/MM/yyyy',
        'paymentTypeId': 1,
        'note': description,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  // ── Empréstimos ───────────────────────────────────────────────────
  Future<Map<String, dynamic>> getLoans() async {
    final response = await _dio.get('/self/loans');
    return response.data as Map<String, dynamic>;
  }

  // ── Tipos de pagamento ────────────────────────────────────────────
  Future<List<dynamic>> getPaymentTypes() async {
    final response = await _dio.get('/paymenttypes');
    return response.data as List<dynamic>;
  }

  // ── Helpers ───────────────────────────────────────────────────────
  String _today() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.year}';
  }

  String _encodeBase64(String input) {
    final bytes = input.codeUnits;
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    var result = '';
    for (var i = 0; i < bytes.length; i += 3) {
      final b0 = bytes[i];
      final b1 = i + 1 < bytes.length ? bytes[i + 1] : 0;
      final b2 = i + 2 < bytes.length ? bytes[i + 2] : 0;
      result += chars[(b0 >> 2) & 63];
      result += chars[((b0 << 4) | (b1 >> 4)) & 63];
      result += i + 1 < bytes.length ? chars[((b1 << 2) | (b2 >> 6)) & 63] : '=';
      result += i + 2 < bytes.length ? chars[b2 & 63] : '=';
    }
    return result;
  }
}

// ─── Interceptor de Auth ──────────────────────────────────────────────
class _AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SecureStorage.getToken();
    if (token != null && !options.path.contains('/authentication')) {
      options.headers['Authorization'] = 'Basic $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      SecureStorage.clearAll();
    }
    return handler.next(err);
  }
}
