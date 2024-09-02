import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'communicationuser_model.g.dart';

@JsonSerializable()
class CommunicationUserModel extends Equatable {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "password")
  final String? password;
  @JsonKey(name: "photoUrl")
  final String? photoUrl;
  @JsonKey(name: "createdBy")
  final String? createdBy;
  @JsonKey(name: "createdAt")
  final String? createdAt;
  @JsonKey(name: "updatedAt")
  final String? updatedAt;
  @JsonKey(name: 'isGroupChat', defaultValue: false)
  final bool? isGroupChat;
  @JsonKey(name: "Users")
  final List<UserModel>? users;
  @JsonKey(name: "Messages")
  final List<ChatModel>? messages;

  const CommunicationUserModel(
      {this.id,
        this.name,
        this.photoUrl,
        this.createdBy,
        this.users,
        this.email,
        this.isGroupChat,
        this.password,
        this.createdAt,
        this.messages,
        this.updatedAt});
  @override
  List<Object> get props => [];
  factory CommunicationUserModel.fromJson(Map<String, dynamic> json) =>
      _$CommunicationUserModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommunicationUserModelToJson(this);
}

@JsonSerializable()
class ChatMessagaeData extends Equatable {
  @JsonKey(name: "messages")
  final List<ChatModel>? messages;
  @JsonKey(name: "pagination")
  final ChatPage? pagination;
  const ChatMessagaeData({this.messages,this.pagination});
  @override
  List<Object> get props => [];
  factory ChatMessagaeData.fromJson(Map<String, dynamic> json) =>
      _$ChatMessagaeDataFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessagaeDataToJson(this);
}

@JsonSerializable()
class   ChatUser extends Equatable {
  @JsonKey(name: "createdAt")
  final String? createdAt;
  @JsonKey(name: "updatedAt")
  final String? updatedAt;
  @JsonKey(name: "unreadMessages")
  final int? unreadMessages;
  @JsonKey(name:"isDeleted")
  final bool? isDeleted;
  @JsonKey(name:"deletedAt")
  final String? deletedAt;
  const ChatUser({this.createdAt, this.updatedAt, this.unreadMessages,this.isDeleted,this.deletedAt});
  @override
  List<Object> get props => [];
  factory ChatUser.fromJson(Map<String, dynamic> json) =>
      _$ChatUserFromJson(json);
  Map<String, dynamic> toJson() => _$ChatUserToJson(this);
}
@JsonSerializable()
class ChatPage extends Equatable {
  @JsonKey(name: "page")
   var page;
  @JsonKey(name: "totalPages")
   var totalpages;
  
  ChatPage({this.page, this.totalpages});
  @override
  List<Object> get props => [];
  factory ChatPage.fromJson(Map<String, dynamic> json) =>
      _$ChatPageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatPageToJson(this);
}
@JsonSerializable()
class ChatModel extends Equatable {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "xid")
  final String? id;
  @JsonKey(name: "chatid")
  final String? chatid;

  @JsonKey(name: "chatSpace")
  final bool? chatSpace;
  @JsonKey(name: "groupid")
  final String? groupid;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "time")
  final String? time;
  @JsonKey(name: "fromuserid")
  final String? fromuserid;
  @JsonKey(name: "fromusername")
  final String? fromusername;
  @JsonKey(name: "createdAt")
  final String? createdAt;
  @JsonKey(name: "updatedAt")
  final String? updatedAt;
  @JsonKey(name: "fromUser")
  final FromUser? fromUser;
  @JsonKey(name: "reply")
  final ReplyTypeModel? reply;
  @JsonKey(name: "firstMessageOfDay")
  final bool? firstMessageOfDay;
  final bool? isDoubleClickCopy;
  @JsonKey(name: "date")
  final String? day;
  final bool? isSelectable;
  @JsonKey(name: "seenBy")
  final List<String>? seenBy;

  const ChatModel(
      {this.type,
      this.message,
      this.chatSpace,
      this.id,
        this.isSelectable,
      this.chatid,
      this.groupid,
        this.isDoubleClickCopy,

      this.fromUser,
        this.reply,
        this.fromusername,
      this.fromuserid,
      this.time,
      this.createdAt,
      this.updatedAt,
      this.seenBy,
      this.day,
      this.firstMessageOfDay});
  @override
  List<Object> get props => [];
  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatModelToJson(this);
}
@JsonSerializable()
class ReplyTypeModel extends Equatable  {
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "type")
  String? type;
  @JsonKey(name: "userid")
  String? userid;
  ReplyTypeModel({ this.name,this.id,this.message,this.type,this.userid});
  @override
  List<Object> get props => [];
  factory ReplyTypeModel.fromJson(Map<String, dynamic> json) =>
      _$ReplyTypeModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReplyTypeModelToJson(this);
}
@JsonSerializable()
class FromUser extends Equatable {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "photo")
  final String? photo;
  const FromUser({this.name, this.email, this.photo});
  @override
  List<Object> get props => [];
  factory FromUser.fromJson(Map<String, dynamic> json) =>
      _$FromUserFromJson(json);
  Map<String, dynamic> toJson() => _$FromUserToJson(this);
}

@JsonSerializable()
class UserModel extends Equatable {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "password")
  final String? password;
  @JsonKey(name: 'connected', defaultValue: false)
  final bool? connected;
  @JsonKey(name: "photo")
  final String? photo;
  @JsonKey(name: "ChatUser")
  final ChatUser? chatUser;

  const UserModel(
      {this.id,
        this.name,
        this.photo,
        this.chatUser,
        this.email,
        this.password,
        this.connected});
  @override
  List<Object> get props => [];
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class UserModelInventory extends Equatable {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "email")
  final String? mail;
  @JsonKey(name: "first_name")
  final String? name;
  @JsonKey(name: "last_name")
  final String? lastName;
  @JsonKey(name: "role")
  final String? photo;
  const UserModelInventory(
      {this.id, this.mail, this.name, this.lastName, this.photo});
  @override
  List<Object> get props => [];
  factory UserModelInventory.fromJson(Map<String, dynamic> json) =>
      _$UserModelInventoryFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelInventoryToJson(this);
}

@JsonSerializable()
class ProfileGetModel extends Equatable {
  @JsonKey(name: "media")
  final Media? media;
  @JsonKey(name: "groups")
  final List<Groups>? groups;
  const ProfileGetModel({this.media, this.groups});
  List<Object> get props => [];
  factory ProfileGetModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileGetModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileGetModelToJson(this);
}

@JsonSerializable()
class ProfileGroupGetModel extends Equatable {
  @JsonKey(name: "response_code")
  final int? responsecode;
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "data")
  final GroupProfileDataModel? data;
  const ProfileGroupGetModel({this.responsecode,this.status,this.data});
  List<Object> get props => [];
  factory ProfileGroupGetModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileGroupGetModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileGroupGetModelToJson(this);
}
@JsonSerializable()
class GroupProfileDataModel extends Equatable {
  @JsonKey(name: "photoUrl")
  final String? photo;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "description")
  final String? discription;
  const GroupProfileDataModel({this.photo,this.name,this.discription});
  List<Object> get props => [];
  factory GroupProfileDataModel.fromJson(Map<String, dynamic> json) =>
      _$GroupProfileDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupProfileDataModelToJson(this);
}

@JsonSerializable()
class Media extends Equatable {
  @JsonKey(name: "Users")
  final List<UserModel>? users;
  @JsonKey(name: "Messages")
  final List<ChatModel>? messages;
  const Media({this.users, this.messages});
  List<Object> get props => [];
  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);
  Map<String, dynamic> toJson() => _$MediaToJson(this);
}

@JsonSerializable()
class Groups extends Equatable {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "id")
  final String? id;
  const Groups({this.name, this.id});
  List<Object> get props => [];
  factory Groups.fromJson(Map<String, dynamic> json) => _$GroupsFromJson(json);
  Map<String, dynamic> toJson() => _$GroupsToJson(this);
}
