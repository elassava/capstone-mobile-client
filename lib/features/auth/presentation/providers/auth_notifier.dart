import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

/// Auth State
class AuthState {
  final bool isLoading;
  final AuthResponse? authResponse;
  final String? error;
  final bool isSuccess;

  const AuthState({
    this.isLoading = false,
    this.authResponse,
    this.error,
    this.isSuccess = false,
  });

  AuthState copyWith({
    bool? isLoading,
    AuthResponse? authResponse,
    String? error,
    bool? isSuccess,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      authResponse: authResponse ?? this.authResponse,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

/// Auth Notifier - Manages authentication state
class AuthNotifier extends StateNotifier<AuthState> {
  final RegisterUseCase _registerUseCase;
  final LoginUseCase _loginUseCase;

  AuthNotifier(this._registerUseCase, this._loginUseCase) : super(const AuthState());

  /// Register new user
  Future<void> register({
    required String email,
    required String password,
  }) async {
    // Set loading state
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);

    try {
      // Call use case
      final authResponse = await _registerUseCase.execute(
        email: email,
        password: password,
      );

      // Success state
      state = state.copyWith(
        isLoading: false,
        authResponse: authResponse,
        isSuccess: true,
        error: null,
      );
    } catch (e) {
      // Error state
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
        isSuccess: false,
      );
    }
  }

  /// Login user
  Future<void> login({
    required String email,
    required String password,
  }) async {
    // Set loading state
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);

    try {
      // Call use case
      final authResponse = await _loginUseCase.execute(
        email: email,
        password: password,
      );

      // Success state
      state = state.copyWith(
        isLoading: false,
        authResponse: authResponse,
        isSuccess: true,
        error: null,
      );
    } catch (e) {
      // Error state
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
        isSuccess: false,
      );
    }
  }

  /// Reset state
  void reset() {
    state = const AuthState();
  }
}

