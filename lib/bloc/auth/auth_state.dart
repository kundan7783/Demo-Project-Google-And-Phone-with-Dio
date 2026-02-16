import 'package:equatable/equatable.dart';

import '../../data/models/auth_response_model.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  final bool isButtonLoading;
  final bool isGoogle;

  AuthLoading({this.isButtonLoading = false, this.isGoogle = false});

  @override
  List<Object?> get props => [isButtonLoading, isGoogle];
}

class AuthSuccess extends AuthState {
  final AuthResponseModel data;
  final bool isGoogleLogin;

  AuthSuccess({required this.data, this.isGoogleLogin = false});

  @override
  List<Object?> get props => [data, isGoogleLogin];
}

class AuthMessage extends AuthState {
  final String message;

  AuthMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}
