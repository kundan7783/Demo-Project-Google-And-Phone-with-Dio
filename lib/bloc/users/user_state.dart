import 'package:demo_phone_google_auth/data/models/user_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserSuccess extends UserState {
  final UserResponseModel userData;

  UserSuccess(this.userData);
}

class UserFailure extends UserState {
  final String error;

  UserFailure(this.error);

  @override
  List<Object?> get props => [error];
}
