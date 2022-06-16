import 'package:pharmaplay_server/pharmaplay_server.dart';
import 'package:pharmaplay_server/src/repository/database_api.dart';
import 'package:pharmaplay_server/src/user/model/user.dart';
import 'package:pharmaplay_server/src/user/user_repository/user_repo.dart';
import 'package:pharmaplay_server/src/utilites/error_response.dart';
import 'package:pharmaplay_server/src/utilites/random_code.dart';

class UserApi {
  String authStore;
  DB db;
  UserApi(this.db, this.authStore);
  Handler get router {
    final router = Router();

    //============= /users/test  ROUTE

    router.post('/test', (Request req) async {
      /*  // final authDetails = req.context['authDetails'] as JWT;
      try {
        final payload = await req.readAsString();
        print(payload);
        final Map<String, dynamic> querybody = json.decode(payload);
        print(querybody);

        List<User> usersInfo = await findUserByParams(db, authStore, querybody);
        print("founded_user------:" + usersInfo.toString());
        print(usersInfo.toString());
        String response = "";
        for (int i = 0; i < usersInfo.length; i++) {
          response = response + (usersInfo[i].toJson().toString());
        }

        return Response.ok(response, headers: {
          'content-type': 'application/json',
        });
      } catch (e) {
        print('----------end test  Request--------------');

        return Response.internalServerError(
            body: '{"error" :" There was a problem test  ." ' +
                e.toString() +
                '" ,"errorNo" :"199991" }');
      }
    }
    */
      sendMail('ironmask2004@gmail.com', 'Veervication Cdoe from Pharma Play',
          'The Code is: ${RandomCode.nextInter()} ');
      return Response.internalServerError(
          body: responseErrMsg("VerCode ???-??? ", "199991"));
    });

//============= /users/userstatuslist  ROUTE

    router.post('/userstatuslist', (Request req) async {
      // final authDetails = req.context['authDetails'] as JWT;

      String response = UserStatusEnumMap.toString();

      return Response.ok(response, headers: {
        'content-type': 'application/json',
      });
    });

    //============= /users/INFO ROUTE
    router.get('/info/', (Request req) async {
      final authDetails = req.context['authDetails'] as JWT;
      print('authDetails.subject.toString ' + authDetails.subject.toString());
      User userInfo;
      try {
        userInfo =
            await findUserByID(authDetails.subject.toString(), db, authStore);

        print("founded_user------:" + userInfo.toString());
      } catch (err) {
        return Response.forbidden(responseErrMsg("$err", "9004"), headers: {
          'content-type': 'application/json',
        });
      }

      final Map<String, dynamic> userWithresault = {
        "userinfo": userInfo.toMap(),
        "requestResult": {'error': 'Success', 'errNO': '200'}
      };

      print(userWithresault);
      var jsonString = json.encode(userWithresault);

      return Response.ok(jsonString, headers: {
        'content-type': 'application/json',
      });
    });

    //============= /users/  ROUTE

    router.post('/', (Request req) async {
      final authDetails = req.context['authDetails'] as JWT;
      print('authDetails.subject.toString ' + authDetails.subject.toString());
      User userInfo;
      try {
        userInfo =
            await findUserByID(authDetails.subject.toString(), db, authStore);

        print("founded_user------:" + userInfo.toString());
      } catch (err) {
        return Response.forbidden(responseErrMsg("$err", "9004"), headers: {
          'content-type': 'application/json',
        });
      }

      final Map<String, dynamic> userWithresault = {
        "userinfo": userInfo.toMap(),
        "requestResult": {'error': 'Success', 'errNO': '200'}
      };

      print(userWithresault);
      var jsonString = json.encode(userWithresault);

      return Response.ok(jsonString, headers: {
        'content-type': 'application/json',
      });
    });

    //============= /users/UPDATE  ROUTE

    router.post('/update/', (Request req) async {
      String sql;
      Map<String, dynamic> params;
      dynamic resultSet;
      final authDetails = req.context['authDetails'] as JWT;
      print('authDetails.subject.toString ' + authDetails.subject.toString());
      final payload = await req.readAsString();
      final Map<String, dynamic> userInfo = json.decode(payload);
      print(userInfo);
      final email = userInfo['email'];
      final password = userInfo['password'];
      final firstname = userInfo['firstname'];
      final lastname = userInfo['lastname'];
      final mobile = userInfo['mobile'];

      print('-------------------------');
      User oldUserInfo =
          await findUserByID(authDetails.subject.toString(), db, authStore);
      print('-------------------------');
      print("founded_old_user_data: ------:" + oldUserInfo.toString());
      //print(oldUserInfo);
      userInfo['updatedate'] = DateTime.now();

      if (userInfo['password'] != null) {
        userInfo['password'] = hashPassword(password, oldUserInfo.salt);
      }

      ;
      User updatedUserInfo = oldUserInfo.copyWithFromMap(userInfo);

      print("updared _user_data: ------:" + updatedUserInfo.toString());

      if (oldUserInfo.email != updatedUserInfo.email) {
        if (!EmailValidator.validate(updatedUserInfo.email)) {
          return Response(HttpStatus.badRequest,
              body: responseErrMsg("Please provide a vaild  Email", '403'));
        }
        sql =
            "SELECT idx  FROM pharmaplay.$authStore WHERE email =  @email  and idx != @idx";
        params = {"email": updatedUserInfo.email, "idx": updatedUserInfo.idx};
        resultSet = await db.query(sql, values: params);

        if (resultSet.length > 0) {
          print(resultSet.toString());
          return Response.forbidden(responseErrMsg(
              "Email:  $email  was already registerd! with some one else !",
              "403"));
        }
      }

      if (oldUserInfo.firstname != updatedUserInfo.firstname ||
          oldUserInfo.lastname != updatedUserInfo.lastname) {
        sql =
            "SELECT idx  FROM pharmaplay.$authStore WHERE firstname= @firstname and lastname =  @lastname   and idx != @idx";
        params = {
          "firstname": updatedUserInfo.firstname,
          "lastname": updatedUserInfo.lastname,
          "idx": updatedUserInfo.idx
        };
        resultSet = await db.query(sql, values: params);

        if (resultSet.length > 0) {
          return Response.forbidden(responseErrMsg(
              "User name:  $firstname $lastname  was already takedn for some one else !!",
              "403"));
        }
      }

      if (oldUserInfo.mobile != updatedUserInfo.mobile) {
        sql =
            "SELECT idx  FROM pharmaplay.$authStore WHERE mobile =  @mobile and idx != @idx  ";
        params = {"mobile": mobile, "idx": updatedUserInfo.idx};
        resultSet = await db.query(sql, values: params);

        if (resultSet.length > 0) {
          return Response.forbidden(responseErrMsg(
              "mobile Number:  $mobile  was already taken !!", "403"));
        }
      }
      try {
        // updatedUserInfo.updatedate = DateTime.now();
        sql =
            'update pharmaplay.$authStore SET   id=@id, firstname=@firstname, lastname=@lastname, email=@email, password=@password, salt=@salt, mobile=@mobile, createdate=@createdate, updatedate=@updatedate ,  status=@status 	where idx= @idx returning idx';
        params = updatedUserInfo.toMap();
        resultSet = await db.query(sql, values: params);

        print(resultSet.first.toString());
        if (resultSet.length == 0) {
          return Response.forbidden(
              responseErrMsg(' facing error while updating  user', "403"));
        }
      } catch (error) {
        print(' error while Updating  user  ' + error.toString());
        return Response(HttpStatus.badRequest,
            body: responseErrMsg('error while Updateing  user', '403'));
      }
      return Response.ok(responseErrMsg("Successfully Updated user", "200"));
    });

    final handler =
        Pipeline().addMiddleware(checkAuthorisation()).addHandler(router);
    return handler;
  }
}
