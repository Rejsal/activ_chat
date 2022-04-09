/// created_at : "Sdsd"
/// from_name : "sdsd"
/// from : "dsfds"
/// to : "sfsf"
/// group : "wdsfd"
/// status : "pending"
/// message : "you are invited"
/// type : "chat"
/// game_id : "dsfsd"

class NotificationModel {
  NotificationModel({
    String? id,
    String? createdAt,
    String? fromName,
    String? from,
    String? to,
    String? group,
    String? status,
    String? message,
    String? type,
    String? gameId,
  }) {
    _id = id;
    _createdAt = createdAt;
    _fromName = fromName;
    _from = from;
    _to = to;
    _group = group;
    _status = status;
    _message = message;
    _type = type;
    _gameId = gameId;
  }

  NotificationModel.fromJson(dynamic json, String id) {
    _id = id;
    _createdAt = json['created_at'];
    _fromName = json['from_name'];
    _from = json['from'];
    _to = json['to'];
    _group = json['group'];
    _status = json['status'];
    _message = json['message'];
    _type = json['type'];
    _gameId = json['game_id'];
  }
  String? _id;
  String? _createdAt;
  String? _fromName;
  String? _from;
  String? _to;
  String? _group;
  String? _status;
  String? _message;
  String? _type;
  String? _gameId;
  NotificationModel copyWith({
    String? createdAt,
    String? fromName,
    String? from,
    String? to,
    String? group,
    String? status,
    String? message,
    String? type,
    String? gameId,
  }) =>
      NotificationModel(
        createdAt: createdAt ?? _createdAt,
        fromName: fromName ?? _fromName,
        from: from ?? _from,
        to: to ?? _to,
        group: group ?? _group,
        status: status ?? _status,
        message: message ?? _message,
        type: type ?? _type,
        gameId: gameId ?? _gameId,
      );
  String? get id => _id;
  String? get createdAt => _createdAt;
  String? get fromName => _fromName;
  String? get from => _from;
  String? get to => _to;
  String? get group => _group;
  String? get status => _status;
  String? get message => _message;
  String? get type => _type;
  String? get gameId => _gameId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['created_at'] = _createdAt;
    map['from_name'] = _fromName;
    map['from'] = _from;
    map['to'] = _to;
    map['group'] = _group;
    map['status'] = _status;
    map['message'] = _message;
    map['type'] = _type;
    map['game_id'] = _gameId;
    return map;
  }

  factory NotificationModel.fromFirestore(dynamic documentSnapshot, String id) {
    NotificationModel model =
        NotificationModel.fromJson(documentSnapshot.data(), id);
    return model;
  }
}
