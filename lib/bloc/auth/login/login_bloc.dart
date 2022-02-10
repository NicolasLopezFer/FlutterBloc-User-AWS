import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:user_bloc/Repository/auth_repository.dart';
import 'package:user_bloc/bloc/auth/form_submission_status.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepo;

  LoginBloc({required this.authRepo}) : super(const LoginState()) {
    // Username updated
    on<LoginUsernameChanged>(_onLoginUsernameChanged);

    //Password Updated
    on<LoginPasswordChanged>(_onLoginPasswordChanged);

    // Form submitted
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  void _onLoginUsernameChanged(LoginUsernameChanged event, emit) {
    emit(state.copyWith(username: event.username));
  }

  void _onLoginPasswordChanged(LoginPasswordChanged event, emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onLoginSubmitted(LoginSubmitted event, emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));

    try {
      await authRepo.login();
      emit(state.copyWith(formStatus: SubmissionsSuccess()));
    } catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(e as Exception)));
    }
  }
}
