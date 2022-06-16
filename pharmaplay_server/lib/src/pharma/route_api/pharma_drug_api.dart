import 'package:pharmaplay_server/pharmaplay_server.dart';
import 'package:pharmaplay_server/src/pharma/repository/pharma_drug_repo.dart';
import 'package:pharmaplay_server/src/utilites/error_response.dart';

class PharmaDrugApi {
  String drugStore;
  DB db;
  PharmaDrugApi(this.db, this.drugStore);
  Handler get router {
    final router = Router();

    //============= /test  ROUTE

    router.post('/test', (Request req) async {
      /*  // final authDetails = req.context['authDetails'] as JWT;
      try {
        final payload = await req.readAsString();
        print(payload);
        final Map<String, dynamic> querybody = json.decode(payload);
        print(querybody);

        List<Drug> drugsInfo = await findDrugByParams(db, drugStore, querybody);
        print("founded_drug------:" + drugsInfo.toString());
        print(drugsInfo.toString());
        String response = "";
        for (int i = 0; i < drugsInfo.length; i++) {
          response = response + (drugsInfo[i].toJson().toString());
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
      // sendMail('ironmask2004@gmail.com', 'Veervication Cdoe from Pharma Play',
      //    'The Code is: ${RandomCode.nextInter()} ');
      return Response.internalServerError(
          body: responseErrMsg("drug test route", "333333"));
    });

    //============= /drugs/INFO ROUTE
    ///----------------------
    //{ "startfrompage": "3" , "pagelength": "2" , "orderbyfields": "drug.\"chemicalDrugID\",drug.\"tradeName\""  }
    router.post('/search', (Request req) async {
      List<DrugRecord> drugInfo;
      // try {
      final payload = await req.readAsString();
      print(payload);
      final String whereCond = json.decode(payload)['wherecond'] ?? '';
      final String localeUI = json.decode(payload)['localeUI'] ?? 'en';
      final Map<String, dynamic> listpagesparms = json.decode(payload);
      print(listpagesparms);

      final int startFromPage = int.parse(listpagesparms['startfrompage'] ?? 0);

      final int pageLength = int.parse(listpagesparms['pagelength'] ?? 0);

      final String orderByfields = listpagesparms['orderbyfields'] ?? '';
      print('startFromPage :   $startFromPage   -- pagelength : $pageLength');

      if (pageLength <= 0 || startFromPage <= 0 || orderByfields.isEmpty) {
        return Response.forbidden(
            responseErrMsg(''' { "startfrompage": "1" , "pagelength": "2" ,
               "orderbyfields": "drug.\"chemicalDrugID\",drug.\"en__brandName\""  ,
               "wherecond": "WHERE drug.\"dosageFormID\" = 44 and drug.\"drugID\" <=8810  " , "localeUI": "en" }''',
                "403"),
            headers: {
              'content-type': 'application/json',
            });
      }

      drugInfo = await findDrugByPage(
          startFromPage: startFromPage,
          pageLength: pageLength,
          orderByfields: orderByfields,
          whereCond: whereCond,
          db: db,
          drugStore: drugStore,
          localeUI: localeUI);

      print("founded_drug------:" + drugInfo.toString());
      /*} catch (err) {
        return Response.forbidden(responseErrMsg("$err", "9004"), headers: {
          'content-type': 'application/json',
        });
      }*/

      var jsonString = json.encode(drugInfo);
      //print('--------------0-0-0-0-0-\n' + jsonString);

      return Response.ok(jsonString, headers: {
        'content-type': 'application/json',
      });
    });
//============== fuzzy search drug

    //============= /drugs/INFO ROUTE
    ///----------------------
    //{ "startfrompage": "3" , "pagelength": "2" , "orderbyfields": "drug.\"chemicalDrugID\",drug.\"tradeName\""  }
    router.post('/fuzzyfindbypage', (Request req) async {
      List<DrugRecord> drugInfo;
      // try {
      final payload = await req.readAsString();
      final String fuzzyCond = json.decode(payload)['fuzzycond'] ?? '';
      final String localeUI = json.decode(payload)['localeUI'] ?? 'en';
      final Map<String, dynamic> listpagesparms = json.decode(payload);
      print(listpagesparms);

      final int startFromPage = int.parse(listpagesparms['startfrompage'] ?? 0);

      final int pageLength = int.parse(listpagesparms['pagelength'] ?? 0);

      final String orderByfields = listpagesparms['orderbyfields'] ?? '';
      print('startFromPage :   $startFromPage   -- pagelength : $pageLength');

      if (pageLength <= 0 ||
          startFromPage <= 0 ||
          orderByfields.isEmpty ||
          fuzzyCond.isEmpty) {
        return Response.forbidden(
            responseErrMsg(''' { "startfrompage": "1" , "pagelength": "2" ,
               "orderbyfields": "drug.\"chemicalDrugID\",drug.\"en__brandName\""  ,
               "fuzzyCond": "رشد" , "localeUI": "en" }''', "403"),
            headers: {
              'content-type': 'application/json',
            });
      }

      print('fuzzyCond: $fuzzyCond');
      drugInfo = await fuzzyFindDrugByPage(
          startFromPage: startFromPage,
          pageLength: pageLength,
          orderByfields: orderByfields,
          fuzzyCond: fuzzyCond,
          db: db,
          drugStore: drugStore,
          localeUI: localeUI);

      print("founded_drug------:" + drugInfo.toString());
      /*} catch (err) {
        return Response.forbidden(responseErrMsg("$err", "9004"), headers: {
          'content-type': 'application/json',
        });
      }*/

      var jsonString = json.encode(drugInfo);
      //print('--------------0-0-0-0-0-\n' + jsonString);

      return Response.ok(jsonString, headers: {
        'content-type': 'application/json',
      });
    });

    //=========================================================
    //=========================================================
    //{ "startfrompage": "1" , "pagelength": "10" ,
    //"weher": { "drug.\"dosageFormID\"": 30 } ,
    // "orderbyfields": "drug.\"chemicalDrugID\",drug.\"tradeName\""  }
    //==== byparam
    router.post('/byparam', (Request req) async {
      List<DrugRecord> drugInfo;
      try {
        final payload = await req.readAsString();

        final Map<String, dynamic> params = json.decode(payload)['weher'] ?? {};

        final Map<String, dynamic> listpagesparms = json.decode(payload) ?? {};
        print(listpagesparms);

        final int startFromPage =
            int.parse(listpagesparms['startfrompage'] ?? 0);

        final int pageLength = int.parse(listpagesparms['pagelength'] ?? 0);

        final String localeUI = listpagesparms['localeUI'] ?? 'en';

        final String orderByfields = listpagesparms['orderbyfields'] ?? '';
        print('startFromPage :   $startFromPage   -- pagelength : $pageLength');

        if (pageLength <= 0 ||
            startFromPage <= 0 ||
            orderByfields == null ||
            orderByfields.isEmpty ||
            params == null ||
            params.isEmpty) {
          return Response.forbidden(
              responseErrMsg('''  Kindly provide correcet values:
                    { "startfrompage": "1" , "pagelength": "10" ,
                    "weher": { "drug.\"dosageFormID\"": 30 } ,
                    "orderbyfields": "drug.\"chemicalDrugID\",drug.\"tradeName\"" , "localeUI": "en"   }''',
                  "403"),
              headers: {
                'content-type': 'application/json',
              });
        }

        drugInfo = await findDrugByParams(
            startFromPage: startFromPage,
            pageLength: pageLength,
            orderByfields: orderByfields,
            params: params,
            db: db,
            drugStore: drugStore,
            localeUI: localeUI);

        // print("founded_drug------:" + drugInfo.toString());
      } catch (err) {
        return Response.forbidden(responseErrMsg("$err", "9004"), headers: {
          'content-type': 'application/json',
        });
      }

      var jsonString = json.encode(drugInfo);
      //print('--------------0-0-0-0-0-\n' + jsonString);

      return Response.ok(jsonString, headers: {
        'content-type': 'application/json',
      });
    });

    //============= /  ROUTE

    router.post('/id', (Request req) async {
      //final authDetails = req.context['authDetails'] as JWT;
      print(req.context.toString());
      DrugRecord drugInfo;
      final payload = await req.readAsString();
      final String localeUI = json.decode(payload)['localeUI'] ?? 'en';
      final Map<String, dynamic> requestBody = json.decode(payload);
      print(requestBody);
      if (requestBody['drugID'] == null || requestBody['drugID'].isEmpty) {
        return Response.forbidden(
            responseErrMsg(
                '  Kindly provide correcet values:    {"drugID": "63"}', "403"),
            headers: {
              'content-type': 'application/json',
            });
      }
      try {
        drugInfo = await findDrugByID(
            requestBody['drugID'].toString(), db, drugStore, localeUI);

        print(
            "founded_drug--dddddddddddddddddddddd----:" + drugInfo.toString());
      } catch (err) {
        return Response.forbidden(responseErrMsg("$err", "9004"), headers: {
          'content-type': 'application/json',
        });
      }
      print('11111');
      final Map<String, dynamic> drugWithresault = {
        "druginfo": drugInfo,
        "requestResult": {'error': 'Success', 'errNO': '200'}
      };

      print('22222');
      print(drugWithresault);
      var jsonString = json.encode(drugWithresault);

      return Response.ok(jsonString, headers: {
        'content-type': 'application/json',
      });
    });

    //============= /drugs/UPDATE  ROUTE

    /* router.post('/update/', (Request req) async {
      String sql;
      Map<String, dynamic> params;
      dynamic resultSet;
      final authDetails = req.context['authDetails'] as JWT;
      print('authDetails.subject.toString ' + authDetails.subject.toString());
      final payload = await req.readAsString();
      final Map<String, dynamic> drugInfo = json.decode(payload);
      print(drugInfo);
      final email = drugInfo['email'];
      final password = drugInfo['password'];
      final firstname = drugInfo['firstname'];
      final lastname = drugInfo['lastname'];
      final mobile = drugInfo['mobile'];

      print('-------------------------');
      Drug oldDrugInfo = await findDrugByID(
          authDetails.subject.toString(), db, drugStore);
      print('-------------------------');
      print("founded_old_drug_data: ------:" + oldDrugInfo.toString());
      //print(oldDrugInfo);
      drugInfo['updatedate'] = DateTime.now();

      Drug updatedDrugInfo =
          oldDrugInfo.copyWithFromMap(drugInfo);

      print("updared _drug_data: ------:" + updatedDrugInfo.toString());

      if (oldDrugInfo.email != updatedDrugInfo.email) {
        if (!EmailValidator.validate(updatedDrugInfo.email)) {
          return Response(HttpStatus.badRequest,
              body: responseErrMsg("Please provide a vaild  Email", '403'));
        }
        sql =
            "SELECT idx  FROM pharmaplay.$drugStore WHERE email =  @email  and idx != @idx";
        params = {
          "email": updatedDrugInfo.email,
          "idx": updatedDrugInfo.idx
        };
        resultSet = await db.query(sql, values: params);

        if (resultSet.length > 0) {
          print(resultSet.toString());
          return Response.forbidden(responseErrMsg(
              "Email:  $email  was already registerd! with some one else !",
              "403"));
        }
      }

      if (oldDrugInfo.firstname != updatedDrugInfo.firstname ||
          oldDrugInfo.lastname != updatedDrugInfo.lastname) {
        sql =
            "SELECT idx  FROM pharmaplay.$drugStore WHERE firstname= @firstname and lastname =  @lastname   and idx != @idx";
        params = {
          "firstname": updatedDrugInfo.firstname,
          "lastname": updatedDrugInfo.lastname,
          "idx": updatedDrugInfo.idx
        };
        resultSet = await db.query(sql, values: params);

        if (resultSet.length > 0) {
          return Response.forbidden(responseErrMsg(
              "Drug name:  $firstname $lastname  was already takedn for some one else !!",
              "403"));
        }
      }

      if (oldDrugInfo.mobile != updatedDrugInfo.mobile) {
        sql =
            "SELECT idx  FROM pharmaplay.$drugStore WHERE mobile =  @mobile and idx != @idx  ";
        params = {"mobile": mobile, "idx": updatedDrugInfo.idx};
        resultSet = await db.query(sql, values: params);

        if (resultSet.length > 0) {
          return Response.forbidden(responseErrMsg(
              "mobile Number:  $mobile  was already taken !!", "403"));
        }
      }
      try {
        // updatedDrugInfo.updatedate = DateTime.now();
        sql =
            'update pharmaplay.$drugStore SET   id=@id, firstname=@firstname, lastname=@lastname, email=@email, password=@password, salt=@salt, mobile=@mobile, createdate=@createdate, updatedate=@updatedate ,  status=@status 	where idx= @idx returning idx';
        params = updatedDrugInfo.toMap();
        resultSet = await db.query(sql, values: params);

        print(resultSet.first.toString());
        if (resultSet.length == 0) {
          return Response.forbidden(
              responseErrMsg(' facing error while updating  drug', "403"));
        }
      } catch (error) {
        print(' error while Updating  drug  ' + error.toString());
        return Response(HttpStatus.badRequest,
            body: responseErrMsg('error while Updateing  drug', '403'));
      }
      return Response.ok(
          responseErrMsg("Successfully Updated drug", "200"));
    });*/

    final handler = Pipeline().addHandler(router);

    //    Pipeline().addMiddleware(checkAuthorisation()).addHandler(router);
    return handler;
  }
}
