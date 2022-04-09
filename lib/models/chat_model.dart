/// group : "fdfd"
/// from_id : "wsfwdf"
/// from_name : "sdfsdf"
/// message : "sffwef"
/// date : "ffew"
/// type : "game"
/// game_id : "sfdsf"

class ChatModel {
  ChatModel({
    String? id,
    String? group,
    String? fromId,
    String? fromName,
    String? message,
    String? date,
    String? type,
    String? gameId,
  }) {
    _id = id;
    _group = group;
    _fromId = fromId;
    _fromName = fromName;
    _message = message;
    _date = date;
    _type = type;
    _gameId = gameId;
  }

  ChatModel.fromJson(dynamic json, String uid) {
    _id = uid;
    _group = json['group'];
    _fromId = json['from_id'];
    _fromName = json['from_name'];
    _message = json['message'];
    _date = json['date'];
    _type = json['type'];
    _gameId = json['game_id'];
  }
  String? _id;
  String? _group;
  String? _fromId;
  String? _fromName;
  String? _message;
  String? _date;
  String? _type;
  String? _gameId;
  ChatModel copyWith({
    String? group,
    String? fromId,
    String? fromName,
    String? message,
    String? date,
    String? type,
    String? gameId,
  }) =>
      ChatModel(
        group: group ?? _group,
        fromId: fromId ?? _fromId,
        fromName: fromName ?? _fromName,
        message: message ?? _message,
        date: date ?? _date,
        type: type ?? _type,
        gameId: gameId ?? _gameId,
      );
  String? get id => _id;
  String? get group => _group;
  String? get fromId => _fromId;
  String? get fromName => _fromName;
  String? get message => _message;
  String? get date => _date;
  String? get type => _type;
  String? get gameId => _gameId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['group'] = _group;
    map['from_id'] = _fromId;
    map['from_name'] = _fromName;
    map['message'] = _message;
    map['date'] = _date;
    map['type'] = _type;
    map['game_id'] = _gameId;
    return map;
  }

  factory ChatModel.fromFirestore(dynamic documentSnapshot, String id) {
    ChatModel model = ChatModel.fromJson(documentSnapshot.data(), id);
    return model;
  }
}
