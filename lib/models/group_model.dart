/// id : "2"
/// name : "test"
/// created_at : "dfdf"
/// users : ["df","dfd"]
/// last_message : "fdf"
/// last_message_date : "test"
/// last_message_sent_by : "name"

class GroupModel {
  GroupModel({
    String? id,
    String? name,
    String? createdAt,
    List<String>? users,
    String? lastMessage,
    String? lastMessageDate,
    String? lastMessageSentBy,
  }) {
    _id = id;
    _name = name;
    _createdAt = createdAt;
    _users = users;
    _lastMessage = lastMessage;
    _lastMessageDate = lastMessageDate;
    _lastMessageSentBy = lastMessageSentBy;
  }

  GroupModel.fromJson(dynamic json, String uid) {
    _id = uid;
    _name = json['name'];
    _createdAt = json['created_at'];
    _users = json['users'] != null ? json['users'].cast<String>() : [];
    _lastMessage = json['last_message'];
    _lastMessageDate = json['last_message_date'];
    _lastMessageSentBy = json['last_message_sent_by'];
  }
  String? _id;
  String? _name;
  String? _createdAt;
  List<String>? _users;
  String? _lastMessage;
  String? _lastMessageDate;
  String? _lastMessageSentBy;
  GroupModel copyWith({
    String? id,
    String? name,
    String? createdAt,
    List<String>? users,
    String? lastMessage,
    String? lastMessageDate,
    String? lastMessageSentBy,
  }) =>
      GroupModel(
        id: id ?? _id,
        name: name ?? _name,
        createdAt: createdAt ?? _createdAt,
        users: users ?? _users,
        lastMessage: lastMessage ?? _lastMessage,
        lastMessageDate: lastMessageDate ?? _lastMessageDate,
        lastMessageSentBy: lastMessageSentBy ?? _lastMessageSentBy,
      );
  String? get id => _id;
  String? get name => _name;
  String? get createdAt => _createdAt;
  List<String>? get users => _users;
  String? get lastMessage => _lastMessage;
  String? get lastMessageDate => _lastMessageDate;
  String? get lastMessageSentBy => _lastMessageSentBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['created_at'] = _createdAt;
    map['users'] = _users;
    map['last_message'] = _lastMessage;
    map['last_message_date'] = _lastMessageDate;
    map['last_message_sent_by'] = _lastMessageSentBy;
    return map;
  }

  factory GroupModel.fromFirestore(dynamic documentSnapshot, String id) {
    GroupModel model = GroupModel.fromJson(documentSnapshot.data(), id);
    return model;
  }
}
