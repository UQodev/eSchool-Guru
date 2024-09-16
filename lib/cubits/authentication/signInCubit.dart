import 'package:bloc/bloc.dart';
import 'package:eschool_saas_staff/data/models/userDetails.dart';
import 'package:eschool_saas_staff/data/repositories/authRepository.dart';
import 'package:eschool_saas_staff/utils/api.dart'; // Pastikan path ini sesuai

abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInInProgress extends SignInState {}

class SignInSuccess extends SignInState {
  final String authToken;
  final UserDetails userDetails;

  SignInSuccess({required this.authToken, required this.userDetails});
}

class SignInFailure extends SignInState {
  final String errorMessage;

  SignInFailure(this.errorMessage);
}

class SignInCubit extends Cubit<SignInState> {
  final AuthRepository _authRepository = AuthRepository();

  SignInCubit() : super(SignInInitial());

  Future<void> signInUser({
    required String email,
    required String password,
  }) async {
    emit(SignInInProgress());

    try {
      final result =
          await _authRepository.loginUser(email: email, password: password);

      emit(
        SignInSuccess(authToken: result.token, userDetails: result.userDetails),
      );
    } catch (e) {
      if (e is ApiException) {
        emit(SignInFailure(e.errorMessage));
      } else {
        emit(SignInFailure('An unexpected error occurred.'));
      }
      print(e);
    }
  }
}
