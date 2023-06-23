import 'package:bloc/bloc.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(const AuthenticationState());

  void initAuth() {
    //TODO do something to check the login state and set it according
    emit(const AuthenticationState(isLoggedIn: false));
  }

  void authenticate() {
    //TODO implement login service
    print('//Implement login service');
    emit(const AuthenticationState(isLoggedIn: true));
  }

  void logout() {
    //TODO implement logout service
    print('//Implement logout service');
    emit(const AuthenticationState(isLoggedIn: false));
  }
}
