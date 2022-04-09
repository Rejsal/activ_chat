/// id : "sdfd"
/// uid : "dsfdf"
/// name : "sddsf"
/// email : "sdsf"

class UserModel {
  UserModel({
    String? id,
    String? uid,
    String? name,
    String? email,
  }) {
    _id = id;
    _uid = uid;
    _name = name;
    _email = email;
  }

  UserModel.fromJson(dynamic json, String id) {
    _id = id;
    _uid = json['uid'];
    _name = json['name'];
    _email = json['email'];
  }
  String? _id;
  String? _uid;
  String? _name;
  String? _email;
  UserModel copyWith({
    String? id,
    String? uid,
    String? name,
    String? email,
  }) =>
      UserModel(
        id: id ?? _id,
        uid: uid ?? _uid,
        name: name ?? _name,
        email: email ?? _email,
      );
  String? get id => _id;
  String? get uid => _uid;
  String? get name => _name;
  String? get email => _email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = _uid;
    map['name'] = _name;
    map['email'] = _email;
    return map;
  }

  factory UserModel.fromFirestore(dynamic documentSnapshot, String id) {
    UserModel model = UserModel.fromJson(documentSnapshot.data(), id);
    return model;
  }
}
