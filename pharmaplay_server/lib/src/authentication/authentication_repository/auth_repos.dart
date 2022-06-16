library authentication_repository;

import 'package:pharmaplay_server/pharmaplay_server.dart';
import 'package:pharmaplay_server/src/utilites/error_response.dart';

//----------------------
Future<int?> changeUserStatus(
    String userId, UserStatus newStatus, String authStore, DB db) async {
  List<Map<String, dynamic>> paramslist = [];
  List<String> sqllist = [];

  sqllist.add(
      'UPDATE pharmaplay.$authStore SET status = @status WHERE id = @userid ');
  paramslist.add({"userid": userId, "status": UserStatusEnumMap[newStatus]});
  print(userId);

  print(sqllist);

  var resault = 0;
  try {
    resault = await db.mutliTransaction(sqllist, paramslist);
  } catch (err) {
    print(err.toString());
    rethrow;
  }
  if (resault == 0) {
    throw ('No Status HAs Been Changed!!!');
  } else {
    return UserStatusEnumMap[newStatus];
  }
}

///-------- resend verfication code

Future<Response> resendVerificationCode(
    var userRequestInfo, DB db, String authStore) async {
  print('----------Start resend Code REquest -------------');

  final email = userRequestInfo['email'];
  final password = userRequestInfo['password'];

  // Ensure email and password fields are present
  if (email == null || email.isEmpty || password == null || password.isEmpty) {
    return Response.forbidden(
        responseErrMsg(' Please provide your email and password ', "403"),
        headers: {
          'content-type': 'application/json',
        });
  }
  if (!EmailValidator.validate(email)) {
    return Response.forbidden(
        responseErrMsg(' Please provide a vaild  Email ', "403"),
        headers: {
          'content-type': 'application/json',
        });
  }

  //final user = await store.findOne(where.eq('email', email));
  String sql = "SELECT *  FROM pharmaplay.$authStore WHERE email =  @email ";
  Map<String, dynamic> params = {"email": email};
  dynamic resultSet = await db.query(sql, values: params);

  if (resultSet.length == 0) {
    return Response.forbidden(responseErrMsg('Incorrect user  Login', "403"),
        headers: {
          'content-type': 'application/json',
        });
  }
  print(resultSet.first.toString());

  final user = resultSet.first['$authStore'];

  print('fided user :   ======== ');
  print(user.toString());

  final hashedPassword = hashPassword(password, user['salt']);
  if (hashedPassword != user['password']) {
    return Response.forbidden(
        responseErrMsg('Incorrect  password!! ! ', "3003"),
        headers: {
          'content-type': 'application/json',
        });
  }

  if (user['status'] != 0) {
    return Response.forbidden(
        responseErrMsg(
            'User Email ${user["email"]} & Mobile ${user["mobile"]}  Already Verifide!! ',
            "3003"),
        headers: {
          'content-type': 'application/json',
        });
  }

  List<Map<String, dynamic>> paramslist = [];
  List<String> sqllist = [];

  sqllist.add(
      "   UPDATE  pharmaplay.$authStore SET     updatedate = @updatedate where id= @id");
  paramslist.add(params = {
    "id": user['id'],
    "updatedate": DateTime.now() //.millisecondsSinceEpoch
  });

  sqllist.add('DELETE  FROM pharmaplay.verificationcodes WHERE userid =  @id ');
  paramslist.add(params = {"id": user['id']});

  String verificationcode = RandomCode.nextInter();
  print(verificationcode);

  paramslist
      .add(params = {"id": user['id'], "verificationcode": verificationcode});
  // return (resultSet.first['verificationcodes']['verificationcode']);
  sqllist.add(
      'insert into pharmaplay.verificationcodes ( userid,verificationcode ) values (  @id , @verificationcode  )  returning idx ');

  print(id);

  print(sql);

  try {
    await db.mutliTransaction(sqllist, paramslist);

    //=====

    // resultSet = await db.query(sql, values: params);

  } catch (err) {
    print(err.toString());
    rethrow;
  }

  try {
    await sendVerificationCodeByMail(verificationcode, user['email']);
  } catch (err) {
    print(err.toString());
    rethrow;
  }

  return Response.ok(
      responseErrMsg(
          "Successfully resend new  user  verificationcode  ", "200"),
      headers: {
        'content-type': 'application/json',
      });
}

//----------------------
Future<bool> userVerifyCode(
    String userId, DB db, String authStore, String verificationcode) async {
  print('userId: $userId, $db , $authStore   : $verificationcode ');
  try {
    Map<String, dynamic> params = {
      "userid": userId,
      "verificationcode": verificationcode
    };
    String sql =
        'SELECT userid   FROM pharmaplay.verificationcodes  WHERE userid =  @userid  and verificationcode = @verificationcode ';
    print(userId);
    print(params);
    print(sql);

    dynamic resultSet = await db.query(sql, values: params);

    if (resultSet.length > 0) {
      List<Map<String, dynamic>> paramslist = [];
      List<String> sqllist = [];
      sqllist.add(
          'DELETE FROM pharmaplay.verificationcodes WHERE userid =  @userid   and verificationcode = @verificationcode ');
      paramslist.add(
          params = {"userid": userId, "verificationcode": verificationcode});

      sqllist.add(
          'UPDATE pharmaplay.$authStore SET status = @status WHERE id = @userid ');
      paramslist.add(params = {"userid": userId, "status": 1});

      await db.mutliTransaction(sqllist, paramslist);

      return true;
    } else {
      print(' User with verificationcode   Not Found ');
      return false;
    }
  } catch (err) {
    print(err.toString());
    rethrow;
  }
}

//----------------------
Future<Response> createUserWithVerifcationCode(
    var userRequestInfo, DB db, String authStore) async {
  final email = userRequestInfo['email'];
  final password = userRequestInfo['password'];
  final firstname = userRequestInfo['firstname'];
  final lastname = userRequestInfo['lastname'];
  final mobile = userRequestInfo['mobile'];
  final String avatar = userRequestInfo['avatar'] ?? "0";

  // Ensure email and password fields are present
  if (email == null || email.isEmpty || password == null || password.isEmpty) {
    // return Response(HttpStatus.badRequest,
    // body: 'Please provide your email and password');

    return Response.forbidden(
        responseErrMsg("Please provide your email and password ", "403"));
  }
  if (!EmailValidator.validate(email)) {
    return Response(HttpStatus.badRequest,
        body: responseErrMsg("Please provide a vaild  Email ", '403'));
  }

  print(firstname);
  print(lastname);
  if (firstname == null ||
      firstname.isEmpty ||
      lastname == null ||
      lastname.isEmpty) {
    return Response.forbidden(
        responseErrMsg("Please provide your firstname and lastname ", "403"));
  }

  if (mobile == null || mobile.isEmpty) {
    return Response.forbidden(
        responseErrMsg("Please provide your Mobile Number!! ", "403"));
  }
  String sql = "SELECT idx  FROM pharmaplay.$authStore WHERE email =  @email ";
  Map<String, dynamic> params = {"email": email};
  dynamic resultSet = await db.query(sql, values: params);

  if (resultSet.length > 0) {
    return Response.forbidden(
        responseErrMsg("Email:  $email  was already registerd!!", "403"));
  }

  sql =
      "SELECT idx  FROM pharmaplay.$authStore WHERE firstname= @firstname and lastname =  @lastname ";
  params = {"firstname": firstname, "lastname": lastname};
  resultSet = await db.query(sql, values: params);

  if (resultSet.length > 0) {
    return Response.forbidden(responseErrMsg(
        "User name:  $firstname $lastname  was already registerd!!", "403"));
  }

  sql = "SELECT idx  FROM pharmaplay.$authStore WHERE mobile =  @mobile ";
  params = {"mobile": mobile};
  resultSet = await db.query(sql, values: params);

  if (resultSet.length > 0) {
    return Response.forbidden(
        responseErrMsg(
            "mobile Number:  $mobile  was already registerd!!", "403"),
        headers: {
          'content-type': 'application/json',
        });
  }

  final id = ObjectId().toString();
  final salt = generateSalt();
  final hashedPassword = hashPassword(password, salt);
  // String vrifycode;

  List<Map<String, dynamic>> paramslist = [];
  List<String> sqllist = [];

  sqllist.add(
      "insert into  pharmaplay.$authStore (firstname,lastname, id, email, password,salt,mobile, avatar, createdate, updatedate) values (@firstname,@lastname, @id, @email, @password,@salt , @mobile , @avatar ,  @createdate, @updatedate ) returning idx");
  paramslist.add(params = {
    "firstname": firstname,
    "lastname": lastname,
    "id": id,
    "email": email,
    "password": hashedPassword,
    "salt": salt,
    "mobile": mobile,
    "avatar": avatar,
    "createdate": DateTime.now(),
    "updatedate": DateTime.now() //.millisecondsSinceEpoch
  });

  sqllist
      .add('DELETE  FROM pharmaplay.verificationcodes WHERE userid =  @id  ');
  paramslist.add(params = {"id": id});

  String verificationcode = RandomCode.nextInter();
  print(verificationcode);

  paramslist.add(params = {"id": id, "verificationcode": verificationcode});
  // return (resultSet.first['verificationcodes']['verificationcode']);
  sqllist.add(
      'insert into pharmaplay.verificationcodes ( userid,verificationcode ) values (  @id , @verificationcode  )  returning idx ');

  print(id);

  print(sql);

  try {
    await db.mutliTransaction(sqllist, paramslist);

    //=====

    // resultSet = await db.query(sql, values: params);

  } catch (err) {
    print(err.toString());
    rethrow;
  }
  try {
    await sendVerificationCodeByMail(verificationcode, email);
  } catch (err) {
    print(err.toString());
    rethrow;
  }

  return Response.ok(responseErrMsg("Successfully registered user   ", "200"),
      headers: {
        'content-type': 'application/json',
      });
}

///----------------- Login User

Future<Response> userLogin(var userRequestInfo, DB db, String authStore,
    TokenService tokenService) async {
  final email = userRequestInfo['email'];
  final password = userRequestInfo['password'];

  // Ensure email and password fields are present
  if (email == null || email.isEmpty || password == null || password.isEmpty) {
    return Response(HttpStatus.badRequest,
        body:
            responseErrMsg("Please provide your email and password!!", "9004"),
        headers: {
          'content-type': 'application/json',
        });
  }
  if (!EmailValidator.validate(email)) {
    return Response.forbidden(
        responseErrMsg("Please provide a vaild  Email!!", "9004"),
        headers: {
          'content-type': 'application/json',
        });
  }

  //final user = await store.findOne(where.eq('email', email));
  String sql = "SELECT *  FROM pharmaplay.$authStore WHERE email =  @email ";
  Map<String, dynamic> params = {"email": email};
  print(sql);
  dynamic resultSet = await db.query(sql, values: params);

  if (resultSet.length == 0) {
    return Response.forbidden(responseErrMsg("Incorrect user  Login!!", "9004"),
        headers: {
          'content-type': 'application/json',
        });
  }
  print(resultSet.first.toString());

  final user = resultSet.first['$authStore'];
  // User Myuser = User.fromMap(user);

  // print("My userrrrrr: " + Myuser.toString());

  print('fided user :   ======== ');
  print(user.toString());

  final hashedPassword = hashPassword(password, user['salt']);
  if (hashedPassword != user['password']) {
    return Response.forbidden(responseErrMsg("Incorrect Paswword ", "9005"),
        headers: {
          'content-type': 'application/json',
        });
  }

  if (user['status'] == 0) {
    print(userRequestInfo['verificationcode']);
    if (userRequestInfo['verificationcode'] == null) {
      return Response.forbidden(
          responseErrMsg("User Need Verification !", "9006"),
          headers: {
            'content-type': 'application/json',
          });
    } else {
      print('user code verificationcode');
      bool ans = await userVerifyCode(
          user['id'], db, authStore, userRequestInfo['verificationcode']);

      if (!ans) {
        return Response.forbidden(
            responseErrMsg("  user Verification Error!!   ", "9007"),
            headers: {
              'content-type': 'application/json',
            });
      }
    }
  }

//---change status to logedin
  if (user['status'] != UserStatusEnumMap[UserStatus.loggedIn]) {
    try {
      user['status'] = await changeUserStatus(
          user['id'], UserStatus.loggedIn, authStore, db);
    } catch (e) {
      return Response.internalServerError(
          body: responseErrMsg(
              ' There was a problem change status to  loggedIn:  ${e.toString()}',
              "9004"),
          headers: {
            'content-type': 'application/json',
          });
    }
  }
//---
  try {
    // Generate JWT and send with response
    print('User ID:' + user['id']);
    // final userId = (user['id'] as ObjectId).toHexString();
    final userId = ObjectId.fromHexString(user['id']).toString();
    print('------User ID:---' + userId);
    final tokenPair = await tokenService.createTokenPair(userId);
    final Map<String, dynamic> userInfo = {
      "userInfo": User.fromMap(user).toJson(),
      "tokenInfo": {
        "tokenId": tokenPair.tokenId,
        "refreshToken": tokenPair.refreshToken
      },
      "requestResult": {
        "error": "Suucess",
        "errNO": "200",
      }
    };

    var jsonString = json.encode(userInfo);

    print('-----======================================--' + jsonString);
    return Response.ok(jsonString, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
    });
  } catch (e) {
    print('----------end Login Request--------------');

    return Response.internalServerError(
        body: responseErrMsg(
            " There was a problem logging you in. Please try again. ${e.toString()}",
            "199991"));
  }
}

//==================mLogout user ==================//
Future<Response> userLogout(
    var auth, String authStore, DB db, TokenService tokenService) async {
  if (auth == null) {
    return Response.forbidden(
        responseErrMsg(' Not authorised to perform this operation.', "403"),
        headers: {
          'content-type': 'application/json',
        });
  }

  final userId = ((auth as JWT)).subject.toString();
  try {
    Map<dynamic, dynamic> result =
        await tokenService.AllRefreshTokenByScanUserId(userId);
    print('llllllllllllllllllllll' + result.toString());
    print(result.length);
    if (result.length == 1) {
//---change status to logedout

      try {
        await changeUserStatus(userId, UserStatus.loggedOut, authStore, db);
      } catch (e) {
        return Response.internalServerError(
            body: responseErrMsg(
                " There was a problem change status to  loggedOut  Please try again. ${e.toString()}",
                "199991"));
      }
//---
    }
  } catch (e) {
    return Response.internalServerError(
        body: responseErrMsg(
            "There was an issue getting sessions  out $e. Please check and try again.",
            "199991"));
  }

  try {
    print('iiiiiiiiiiiiiiiiiiiiiii    subject   rrrrrrrrrrrr:  $userId');

    await tokenService.removeRefreshToken(
        ((auth as JWT)).jwtId.toString(), userId);
  } catch (e) {
    return Response.internalServerError(
        body: responseErrMsg(
            "There was an issue logging out. Please check and try again.",
            "199991"));
  }

  return Response.ok(responseErrMsg("Successfully Loggedout user", "200"));
}

//=========== User Unrigster ====================//

userunRegister(var auth, JWT authDetails, String authStore, DB db,
    TokenService tokenService) async {
  print('Unirgster id : $auth  ::::: JWT $authDetails');
  try {
//-----------
    final String id = authDetails.subject.toString();
    String sql =
        "delete  FROM pharmaplay.$authStore WHERE id =  @id returning 1 ";
    Map<String, dynamic> params = {"id": id};
    dynamic resultSet = await db.query(sql, values: params);

    if (resultSet.length == 0) {
      return Response.forbidden(responseErrMsg("Failed to remove user", "403"));
    }
    print(resultSet.first.toString());
//------------
    final userId = ((auth as JWT)).subject.toString();
    print(userId);
    await tokenService.removeAllRefreshTokenByUserId(userId);
  } catch (e) {
    return Response.internalServerError(
        body: responseErrMsg(
            "There was an issue unregistering  user. Please check and try again.",
            "199991"));
  }

  return Response.ok(responseErrMsg("Successfully Unrigested  user ", "200"));
}
