import 'package:demo_phone_google_auth/bloc/users/user_event.dart';
import 'package:demo_phone_google_auth/bloc/users/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/api/user_api.dart';

class UserBloc extends Bloc<UserEvent,UserState> {
  UserBloc() : super (UserInitial()){
    on<FetchUserEvent>(_onFetchUser);

  }

  Future<void> _onFetchUser(FetchUserEvent event,Emitter<UserState> emit,)async{
    emit(UserLoading());
    try{
      final response = await UserApi.getUserApi();
      emit(UserSuccess(response));
    }catch(error){
      emit(UserFailure(error.toString()));
    }
  }

}


