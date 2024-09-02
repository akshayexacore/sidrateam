class ChatTypeModel {
  String name;
  String code;
  ChatTypeModel({required this.name, required this.code});
}

List<ChatTypeModel> chatTypeList = [
  ChatTypeModel(name: 'All Chats', code: ""),
  ChatTypeModel(name: 'Personal', code: "chats"),
  ChatTypeModel(name: 'Group Chat', code: "groups"),
];

class Chatdate {
  String day;
  Chatdate({required this.day});
}
class ReplyType{
  String? name;
  String? id;
  String? message;
  String? type;
  String? userid;
  ReplyType({ this.name,this.id,this.message,this.type,this.userid});
}