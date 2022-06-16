import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:pharmaplay_cpanel/generated/l10n.dart';
import 'package:pharmaplay_cpanel/src/login/login.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const SignupState()) {
    on<SignUpFirstnameChanged>(_onSignUpFirstnameChanged);
    on<SignUpLastnameChanged>(_onSignUpLastnameChanged);
    on<SignUpMobileChanged>(_onSignUpMobileChanged);
    on<SignUpEmailChanged>(_onSignUpEmailChanged);
    on<SignUpPasswordChanged>(_onSignUpPasswordChanged);
    on<SignUpConfirmPasswordChanged>(_onSignUpConfirmPasswordChanged);
    on<SignUpSubmitted>(_onSignUpSubmited);
    //on<SignupEmailChanged>(_onSignupEmailChanged);
    on<SignUpForgotEmailChanged>(_onsignUpForgotEmailChanged);

    //on<SignupPasswordChanged>(_onSignupPasswordChanged);

    on<SignUpConfirmFormEmailChanged>(_onSignUpConfirmFormEmailChanged);
    on<SignUpConfirmFormPasswordChanged>(_onSignUpConfirmFormPasswordChanged);

    on<SignUpConfirmCodeChanged>(_onSignUpConfirmCodeChanged);
    //on<SignUpSubmitted>(_onSiginSignUpSubmitted);
    on<SignUpCConfirmCodeSubmitted>(_onSignUpCConfirmCodeSubmitted);
    on<ResendSignUpCConfirmCodeSubmitted>(_onResendSignUpCConfirmCodeSubmitted);
    on<SignupForgotPasswordSubmitted>(_onSignupForgotPasswordSubmitted);

    // on<RoutToSignUpPageSubmitted>(_onRoutToSignUpPageSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onSignUpFirstnameChanged(
    SignUpFirstnameChanged event,
    Emitter<SignupState> emit,
  ) {
    print('_onSignUpFirstnameChanged');
    final firstname = InputString.dirty(event.firstname);
    emit(state.copyWith(
      firstname: firstname,
      status: Formz.validate([
        state.firstname,
        state.lastname,
        state.mobile,
        state.email,
        state.password,
        state.confirmPassword
      ]),
    ));
  }

  void _onSignUpLastnameChanged(
    SignUpLastnameChanged event,
    Emitter<SignupState> emit,
  ) {
    print(SLang.current.onsignuplastnamechanged);
    final lastname = InputString.dirty(event.lastname);
    emit(state.copyWith(
      lastname: lastname,
      status: Formz.validate([
        state.firstname,
        state.lastname,
        state.mobile,
        state.email,
        state.password,
        state.confirmPassword
      ]),
    ));
  }

  void _onSignUpMobileChanged(
    SignUpMobileChanged event,
    Emitter<SignupState> emit,
  ) {
    print('_onSignUpMobileChanged');
    final mobile = Mobile.dirty(event.mobile);
    emit(state.copyWith(
      mobile: mobile,
      status: Formz.validate([
        state.firstname,
        state.lastname,
        state.mobile,
        state.email,
        state.password,
        state.confirmPassword
      ]),
    ));
  }

  void _onSignUpConfirmCodeChanged(
    SignUpConfirmCodeChanged event,
    Emitter<SignupState> emit,
  ) {
    print('_onSignUpConfirmCodeChanged');
    final confirmCode = InputString.dirty(event.confirmCode);
    print('${state.email}, ${state.password}   ${state.confirmCode} ');
    emit(state.copyWith(
      confirmCode: confirmCode,
      status: Formz.validate([state.email, state.password, state.confirmCode]),
    ));
  }

  void _onsignUpForgotEmailChanged(
    SignUpForgotEmailChanged event,
    Emitter<SignupState> emit,
  ) {
    print(SLang.current.forgotPassword);
    final email = Email.dirty(event.email);
    print('${state.email},   ');
    emit(state.copyWith(
      email: email,
      status: Formz.validate([state.email]),
    ));
  }

  void _onSignUpConfirmFormEmailChanged(
    SignUpConfirmFormEmailChanged event,
    Emitter<SignupState> emit,
  ) {
    print('_onSignUpConfirmFormEmailChanged');
    final email = Email.dirty(event.email);
    print('${state.email}, ${state.password}   ${state.confirmCode} ');
    emit(state.copyWith(
      email: email,
      status: Formz.validate([state.email, state.password, state.confirmCode]),
    ));
  }

  void _onSignUpConfirmFormPasswordChanged(
    SignUpConfirmFormPasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    print('_onSignUpConfirmFormPasswordChanged');
    final password = Password.dirty(event.password);
    print('${state.email}, ${state.password}   ${state.confirmCode} ');
    emit(state.copyWith(
      password: password,
      status: Formz.validate([state.email, state.password, state.confirmCode]),
    ));
  }

  void _onSignUpConfirmPasswordChanged(
    SignUpConfirmPasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    print('_onSignUpConfirmPasswordChanged');
    final confirmPassword = Password.dirty(event.confirmPassword);
    emit(state.copyWith(
      confirmPassword: confirmPassword,
      status: Formz.validate([
        state.firstname,
        state.lastname,
        state.mobile,
        state.email,
        state.password,
        state.confirmPassword
      ]),
    ));
  }

  /*void _onSignupEmailChanged(
    SignupEmailChanged event,
    Emitter<SignupState> emit,
  ) {
    print('_onEmailChanged');
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([state.password, email]),
    ));
  }*/

  /* void _onSignupPasswordChanged(
    SignupPasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    print('_onpasswordChanged');
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([password, state.email]),
    ));
  }
*/
  void _onSignUpEmailChanged(
    SignUpEmailChanged event,
    Emitter<SignupState> emit,
  ) {
    print('_onSignUpEmailChanged');
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([
        state.firstname,
        state.lastname,
        state.mobile,
        state.email,
        state.password,
        state.confirmPassword
      ]),
    ));
  }

  void _onSignUpPasswordChanged(
    SignUpPasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    print('_onSignUpPasswordChanged');
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([
        state.firstname,
        state.lastname,
        state.mobile,
        state.email,
        state.password,
        state.confirmPassword
      ]),
    ));
  }

  /*void _onSiginSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
//-----------------
      final dartz.Either<TokenPair, ApiError> _repoResponse;
      try {
        //TokenPair _tokenInfo;
        _repoResponse = await _authenticationRepository.logInUser(
            email: state.email.value, password: state.password.value);

        _repoResponse.fold((left) {
          print('left');
          // return (left);
          print(left.toJson().toString());
          emit(state.copyWith(
              status: FormzStatus.submissionSuccess,
              errMsg: left.toJson().toString()));
        }, (right) {
          //showInSnackBar(context, ("Signup Successs!!"));
          print('right');
          emit(state.copyWith(
              status: FormzStatus.submissionFailure,
              errMsg: right.toJson().toString()));

          //return (right);
        });
      } catch (err) {
        print('Error connectiing to server ' + err.toString());
        rethrow;
        // showInSnackBar(context, err.toString());
      }
    }
  }*/
  //=======================
  //

  void _onSignUpCConfirmCodeSubmitted(
    SignUpCConfirmCodeSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    print('formstate: ${state.status}');
    print(state.email.value +
        ' password: ' +
        state.password.value +
        ' confirmCode: ' +
        state.confirmCode.value);
    if (!state.status.isValidated) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          errMsg: 'Inpuut Data Error!!'));
      return;
    }
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
//-----------------
    final dartz.Either<TokenPair, ApiError> _repoResponse;
    try {
      //TokenPair _tokenInfo;
      _repoResponse = await _authenticationRepository.logInUserWithVerfication(
          email: state.email.value,
          password: state.password.value,
          confirmCode: state.confirmCode.value);

      _repoResponse.fold((left) {
        print('left');
        // return (left);
        print(left.toJson().toString());
        emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            errMsg: left.toJson().toString()));
      }, (right) {
        //showInSnackBar(context, ("Signup Successs!!"));
        print('right');
        emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            errMsg: right.toJson().toString()));

        //return (right);
      });
    } catch (err) {
      print('Error connectiing to server ' + err.toString());
      rethrow;
      // showInSnackBar(context, err.toString());
    }
  }

  //-==========

  void _onResendSignUpCConfirmCodeSubmitted(
    ResendSignUpCConfirmCodeSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    print('formstate: ${state.status}');
    print(state.email.value + ' password: ' + state.password.value);
    if (!state.status.isValidated) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          errMsg: 'Inpuut Data Error!!'));
      return;
    }
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
//-----------------
    final dartz.Either<TokenPair, ApiError> _repoResponse;
    try {
      //TokenPair _tokenInfo;
      _repoResponse = await _authenticationRepository.resendVerficationCode(
          email: state.email.value, password: state.password.value);

      _repoResponse.fold((left) {
        print('left');
        // return (left);
        print(left.toJson().toString());
        emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            errMsg: left.toJson().toString()));
      }, (right) {
        //showInSnackBar(context, ("Signup Successs!!"));
        print('right');
        emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            errMsg: right.toJson().toString()));

        //return (right);
      });
    } catch (err) {
      print('Error connectiing to server ' + err.toString());
      rethrow;
      // showInSnackBar(context, err.toString());
    }
  }
  //========================

//-==========

  void _onSignupForgotPasswordSubmitted(
    SignupForgotPasswordSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    print('formstate: ${state.status}');
    print(state.email.value + ' password: ' + state.password.value);
    if (!state.status.isValidated) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          errMsg: 'Inpuut Data Error!!'));
      return;
    }
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
//-----------------
    final dartz.Either<TokenPair, ApiError> _repoResponse;
    try {
      //TokenPair _tokenInfo;
      _repoResponse = await _authenticationRepository.forgotpassword(
          email: state.email.value);

      _repoResponse.fold((left) {
        print('left');
        // return (left);
        print(left.toJson().toString());
        emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            errMsg: left.toJson().toString()));
      }, (right) {
        print('right');
        emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            errMsg: right.toJson().toString()));

        //return (right);
      });
    } catch (err) {
      print('Error connectiing to server ' + err.toString());
      rethrow;
      // showInSnackBar(context, err.toString());
    }
  }

//===
  void _onSignUpSubmited(
    SignUpSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    print('formstate: ${state.status}');
    if (!state.status.isValidated) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          errMsg: 'Inpuut Data Error!!'));
      return;
    }
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    final dartz.Either<TokenPair, ApiError> _repoResponse;

    print('_SiginSignUpSubmitted');
    print(state.toString());

    if (state.password.value != state.confirmPassword.value) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          errMsg: 'Confirm Password Not Equal Password!!'));
      return;
    }

    try {
      //TokenPair _tokenInfo;
      _repoResponse = await _authenticationRepository.signUpUser(
        firstname: state.firstname.value,
        lastname: state.lastname.value,
        mobile: state.mobile.value,
        email: state.email.value,
        password: state.password.value,
      );

      _repoResponse.fold((left) {
        print('left');
        // return (left);
        print(left.toJson().toString());
        emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            errMsg: left.toJson().toString()));
      }, (right) {
        print('right');
        emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            errMsg: right.toJson().toString()));

        //return (right);
      });
    } catch (err) {
      print('Error From server ' + err.toString());
      rethrow;
      // showInSnackBar(context, err.toString());
    }
  }
}
