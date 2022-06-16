import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:authentication_repository/src/api/authentication_api.dart';
import 'package:authentication_repository/src/model/api_error.dart';
import 'package:authentication_repository/src/model/token_pair.dart';
import 'package:dartz/dartz.dart' as dartz;

import 'package:authentication_repository/src/model/api_response.dart';
part 'auth_status.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
  authenticateSignUp,
  authenticateSignIn,
  authenticateConfirmCode,
  authenticateChangePassword,
  authenticationForgotPassword
}

class AuthenticationRepository {
  AuthenticationRepository(this.loggedInFlag, this.tokenPair, this.baseUrl);

  final bool loggedInFlag;
  final TokenPair tokenPair;
  final String baseUrl;
  final _controller = StreamController<AuthRepoState>();

/*Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));

    //bool loggedInFlag = await MySharedPreferences.instance.getBooleanValue("loggedIn");
    if (loggedInFlag) {
      yield AuthenticationStatus.authenticated;
    } else {
      yield AuthenticationStatus.unauthenticated;
    }
    yield* _controller.stream;
  }
*/

  Stream<AuthRepoState> get status async* {
    //bool loggedInFlag = await MySharedPreferences.instance.getBooleanValue("loggedIn");
    if (loggedInFlag) {
      print('loggedInFlag is true');
      yield AuthRepoState.authenticated(tokenPair);
    } else {
      print('loggedInFlag is false');
      yield AuthRepoState.unauthenticated();
    }
    print('yield* _controller.stream');
    yield* _controller.stream;
  }

  Future<dartz.Either<TokenPair, ApiError>> logInUser(
      {required String email, required String password}) async {
    dartz.Either<ApiResponse, ApiError> _loginUserResponse;

    try {
      _loginUserResponse = await apiLoginUser(email, password, baseUrl);
      print('login response :' + _loginUserResponse.toString());

      return _loginUserResponse.fold((left) {
        //print((right as ApiError).error.toString());
        print('left1');
        var _tokenPair = TokenPair.fromJson(json.encode(left.Data));
        print('left2');
        _controller.add(AuthRepoState.authenticated(_tokenPair));

        return dartz.left(_tokenPair);
      }, (right) {
        print('right');
        print(right.toJson().toString());
        if (right.errorNo == "9006") {
          _controller.add(AuthRepoState.authenticateConfirmCode(
              TokenPair(email, password)));
        } else {
          _controller.add(AuthRepoState.unknown());
        }
        return dartz.right(right as ApiError);
      });
    } catch (err) {
      print('Error connectiing to server ' + err.toString());
      throw (err);
      // return dartz.right(ApiError(error: '$err', errorNo: '1900202'));
    }
  }

//-----===== resendVerficationCode

  Future<dartz.Either<TokenPair, ApiError>> resendVerficationCode(
      {required String email, required String password}) async {
    dartz.Either<ApiResponse, ApiError> _loginUserResponse;

    try {
      _loginUserResponse =
          await apiresendVerficationCode(email, password, baseUrl);
      print('login response :' + _loginUserResponse.toString());

      return _loginUserResponse.fold((left) {
        //print((right as ApiError).error.toString());
        print('left1');
        var _tokenPair = TokenPair.fromJson(json.encode(left.Data));
        print('left2');
        _controller.add(AuthRepoState.authenticated(_tokenPair));

        return dartz.left(_tokenPair);
      }, (right) {
        _controller.add(AuthRepoState.unknown());
        print('right');
        print(right.toJson().toString());
        return dartz.right(right as ApiError);
      });
    } catch (err) {
      print('Error connectiing to server ' + err.toString());
      throw (err);
      // return dartz.right(ApiError(error: '$err', errorNo: '1900202'));
    }
  }

//===

  Future<dartz.Either<TokenPair, ApiError>> authRefreshToken(
      {required TokenPair tokenPair}) async {
    dartz.Either<ApiResponse, ApiError> _apiResponse;

    try {
      _apiResponse = await apiAuthRefreshToken(
          // registerUser(
          tokenPair,
          baseUrl);

      return _apiResponse.fold((left) {
        //print((right as ApiError).error.toString());
        print('apiAuthRefreshToken response :' + left.Data.toString());

        print('left1');
        var _tokenPair = TokenPair.fromJson(json.encode(left.Data));
        print('left2');
        // _controller.add(AuthRepoState.authenticated(_tokenPair));

        return dartz.left(_tokenPair);
        print('left2');
      }, (right) {
        // _controller.add(AuthRepoState.unauthenticated());
        print('right');
        // print(right.toJson().toString());
        return dartz.right(right as ApiError);
      });
    } catch (err) {
      print('Error connectiing to server ' + err.toString());
      throw (err);
      // return dartz.right(ApiError(error: '$err', errorNo: '1900202'));
    }
  }

//============

  Future<dartz.Either<TokenPair, ApiError>> forgotpassword(
      {required String email}) async {
    dartz.Either<ApiResponse, ApiError> _apiForgotResponse;

    try {
      _apiForgotResponse = await apiforgotpassword(email, baseUrl);
      print('forgot  response :' + _apiForgotResponse.toString());

      return _apiForgotResponse.fold((left) {
        //print((right as ApiError).error.toString());
        print('left1');
        // var _tokenPair = TokenPair.fromJson(json.encode(left.Data));
        print('left2');
        _controller.add(AuthRepoState.unauthenticated());

        return dartz.left(TokenPair.empty());
      }, (right) {
        _controller.add(AuthRepoState.unknown());
        print('right ff');
        print(right.toJson().toString());
        return dartz.right(right as ApiError);
      });
    } catch (err) {
      print('Error connectiing to server ' + err.toString());
      throw (err);
      // return dartz.right(ApiError(error: '$err', errorNo: '1900202'));
    }
  }

//================== logInUserWithVerfication

  Future<dartz.Either<TokenPair, ApiError>> logInUserWithVerfication(
      {required String email,
      required String password,
      required String confirmCode}) async {
    dartz.Either<ApiResponse, ApiError> _loginUserResponse;

    try {
      _loginUserResponse = await apiLoginUserWithVerfication(
          email, password, confirmCode, baseUrl);
      print('login response :' + _loginUserResponse.toString());

      return _loginUserResponse.fold((left) {
        //print((right as ApiError).error.toString());
        print('left1');
        var _tokenPair = TokenPair.fromJson(json.encode(left.Data));
        print('left2');
        _controller.add(AuthRepoState.authenticated(_tokenPair));

        return dartz.left(_tokenPair);
      }, (right) {
        _controller.add(AuthRepoState.unknown());
        print('right');
        print(right.toJson().toString());
        return dartz.right(right as ApiError);
      });
    } catch (err) {
      print('Error connectiing to server ' + err.toString());
      throw (err);
      // return dartz.right(ApiError(error: '$err', errorNo: '1900202'));
    }
  }

//==================

  Future<dartz.Either<TokenPair, ApiError>> signUpUser(
      {required String firstname,
      required String lastname,
      required String mobile,
      required String email,
      required String password}) async {
    dartz.Either<ApiResponse, ApiError> _SignUpUserResponse;

    try {
      _SignUpUserResponse = await registerUser(
          firstname, lastname, mobile, email, password, baseUrl);
      print('registerUser response :' + _SignUpUserResponse.toString());

      return _SignUpUserResponse.fold((left) {
        //print((right as ApiError).error.toString());
        print('left1');
        // var _tokenPair = TokenPair.fromJson(json.encode(left.Data));
        print('left2');
        _controller.add(
            AuthRepoState.authenticateConfirmCode(TokenPair(email, password)));

        return dartz.left(TokenPair.empty());
      }, (right) {
        // _controller.add(AuthRepoState.unauthenticated());
        print('right');
        // print(right.toJson().toString());
        return dartz.right(right as ApiError);
      });
    } catch (err) {
      print('Error connectiing to server ' + err.toString());
      throw (err);
      // return dartz.right(ApiError(error: '$err', errorNo: '1900202'));
    }
  }

  Future<void> logInByID({required TokenPair tokenPair}) async {
    print('login By ID: ${tokenPair.tokenId}');
    await Future.delayed(const Duration(milliseconds: 300),
        () => _controller.add(AuthRepoState.authenticated(tokenPair)));
  }

//=======================
  Future<void> logOut(String _tokenId) async {
    try {
      final _LogOutUserResponse = await apiLogOutUser(_tokenId, baseUrl);
      print('_LogOutUser  response :' + _LogOutUserResponse.toString());

      return _LogOutUserResponse.fold((left) {
        //print((right as ApiError).error.toString());
        print('left1');
        // var _tokenPair = TokenPair.fromJson(json.encode(left.Data));
        print('left2');
        _controller.add(AuthRepoState.unauthenticated());

        return dartz.left(TokenPair.empty());
      }, (right) {
        // _controller.add(AuthRepoState.unauthenticated());
        print('right');
        // print(right.toJson().toString());
        _controller.add(AuthRepoState.unauthenticated());
        return dartz.right(right as ApiError);
      });
    } catch (err) {
      print('Error connectiing to server ' + err.toString());
      _controller.add(AuthRepoState.unauthenticated());
      throw (err);

      // return dartz.right(ApiError(error: '$err', errorNo: '1900202'));
    }
  }

  void dispose() => _controller.close();
}

//mixin _email {}
