import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:pharmaplay_server/pharmaplay_server.dart';
import 'package:pharmaplay_server/src/user/model/usersstatus.dart';
part 'user.g.dart';

// TODO  adding profile photo

/*
SELECT  createdate,  current_timestamp,
TIMESTAMP WITH TIME ZONE 'epoch' + updatedate  * INTERVAL '1 millisecond'  , updatedate
FROM pharmaplay.users000;

SELECT EXTRACT(EPOCH FROM TIMESTAMP WITH TIME ZONE '2001-02-16 20:38:40.12-08');
Result: 982384720.12

SELECT EXTRACT(EPOCH FROM INTERVAL '5 days 3 hours');
Result: 442800
Here is how you can convert an epoch value back to a time stamp:

SELECT TIMESTAMP WITH TIME ZONE 'epoch' + 982384720.12 * INTERVAL '1 second';
*/
@JsonSerializable(explicitToJson: true)
class User extends Equatable {
  User(
      {required this.idx,
      required this.id,
      required this.firstname,
      required this.lastname,
      required this.email,
      required this.password,
      required this.salt,
      required this.mobile,
      required this.avatar,
      required this.createdate,
      required this.updatedate,
      required this.status});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        idx: map['idx'],
        id: map['id'],
        firstname: map['firstname'],
        lastname: map['lastname'],
        email: map['email'],
        password: map['password'],
        salt: map['salt'],
        mobile: map['mobile'],
        avatar: map['avatar'],
        createdate: DateTime.parse(map['createdate'].toString()),
        /* updatedate: DateTime.fromMillisecondsSinceEpoch(
            int.parse(map['updatedate'].toString())),*/
        updatedate: DateTime.parse(map['updatedate'].toString()),
        status: $enumDecode(_$UserStatusEnumMap, map['status'],
            unknownValue: UserStatus.needVerify));
  }

  final String id;
  final int idx;
  final String firstname;
  final String email;
  final String lastname;
  final String mobile;
  final String avatar;
  final String password;
  final String salt;
  final DateTime createdate;

  final DateTime updatedate;
  @JsonKey(unknownEnumValue: UserStatus.needVerify)
  final UserStatus status;

  @override
  List<Object> get props {
    return [
      idx,
      id,
      firstname,
      lastname,
      email,
      password,
      salt,
      mobile,
      avatar,
      createdate,
      updatedate,
      status
    ];
  }

  @override
  bool get stringify => true;

  User copyWith(
      {int? idx,
      String? id,
      String? firstname,
      String? lastname,
      String? email,
      String? password,
      String? salt,
      String? mobile,
      String? avatar,
      DateTime? createdate,
      DateTime? updatedate,
      UserStatus? status}) {
    return User(
        idx: idx ?? this.idx,
        id: id ?? this.id,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        email: email ?? this.email,
        password: password ?? this.password,
        salt: salt ?? this.salt,
        mobile: mobile ?? this.mobile,
        avatar: avatar ?? this.avatar,
        createdate: createdate ?? this.createdate,
        updatedate: updatedate ?? this.updatedate,
        status: status == null
            ? this.status
            : $enumDecode(_$UserStatusEnumMap, status,
                unknownValue: UserStatus.needVerify));
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  User copyWithFromMap(Map<String, dynamic> map) {
    return User(
        idx: map['idx'] ?? idx,
        id: map['id'] ?? id,
        firstname: map['firstname'] ?? firstname,
        lastname: map['lastname'] ?? lastname,
        email: map['email'] ?? email,
        password: map['password'] ?? password,
        salt: map['salt'] ?? salt,
        mobile: map['mobile'] ?? mobile,
        avatar: map['avatar'] ?? avatar,
        createdate: (map['createdate'] == null
            ? createdate
            : DateTime.parse(map['createdate'].toString())),
        updatedate: (map['updatedate'] == null
            ? updatedate
            : DateTime.parse(map['updatedate'].toString())),
        status: map['status'] == null
            ? status
            : $enumDecode(_$UserStatusEnumMap, map['status'],
                unknownValue: UserStatus.needVerify));
  }

  Map<String, dynamic> toMap() {
    return {
      'idx': idx,
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
      'salt': salt,
      'mobile': mobile,
      'avatar': avatar,
      'createdate': createdate.toIso8601String(),
      'updatedate': updatedate.toIso8601String(),
      'status': _$UserStatusEnumMap[status],
    };
  }

  copyWithfromJson(String source) => copyWithFromMap(json.decode(source));
}
