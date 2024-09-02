// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'communicationuser_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunicationUserModel _$CommunicationUserModelFromJson(
        Map<String, dynamic> json) =>
    CommunicationUserModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      photoUrl: json['photoUrl'] as String?,
      createdBy: json['createdBy'] as String?,
      users: (json['Users'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      email: json['email'] as String?,
      isGroupChat: json['isGroupChat'] as bool? ?? false,
      password: json['password'] as String?,
      createdAt: json['createdAt'] as String?,
      messages: (json['Messages'] as List<dynamic>?)
          ?.map((e) => ChatModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$CommunicationUserModelToJson(
        CommunicationUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'photoUrl': instance.photoUrl,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'isGroupChat': instance.isGroupChat,
      'Users': instance.users,
      'Messages': instance.messages,
    };

ChatMessagaeData _$ChatMessagaeDataFromJson(Map<String, dynamic> json) =>
    ChatMessagaeData(
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => ChatModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] == null
          ? null
          : ChatPage.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatMessagaeDataToJson(ChatMessagaeData instance) =>
    <String, dynamic>{
      'messages': instance.messages,
      'pagination': instance.pagination,
    };

ChatUser _$ChatUserFromJson(Map<String, dynamic> json) => ChatUser(
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      unreadMessages: (json['unreadMessages'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
      deletedAt: json['deletedAt'] as String?,
    );

Map<String, dynamic> _$ChatUserToJson(ChatUser instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'unreadMessages': instance.unreadMessages,
      'isDeleted': instance.isDeleted,
      'deletedAt': instance.deletedAt,
    };

ChatPage _$ChatPageFromJson(Map<String, dynamic> json) => ChatPage(
      page: json['page'],
      totalpages: json['totalPages'],
    );

Map<String, dynamic> _$ChatPageToJson(ChatPage instance) => <String, dynamic>{
      'page': instance.page,
      'totalPages': instance.totalpages,
    };

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) => ChatModel(
      type: json['type'] as String?,
      message: json['message'] as String?,
      chatSpace: json['chatSpace'] as bool?,
      id: json['xid'] as String?,
      isSelectable: json['isSelectable'] as bool?,
      chatid: json['chatid'] as String?,
      groupid: json['groupid'] as String?,
      fromUser: json['fromUser'] == null
          ? null
          : FromUser.fromJson(json['fromUser'] as Map<String, dynamic>),
      reply: json['reply'] == null
          ? null
          : ReplyTypeModel.fromJson(json['reply'] as Map<String, dynamic>),
      fromusername: json['fromusername'] as String?,
      fromuserid: json['fromuserid'] as String?,
      time: json['time'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      seenBy:
          (json['seenBy'] as List<dynamic>?)?.map((e) => e as String).toList(),
      day: json['date'] as String?,
      firstMessageOfDay: json['firstMessageOfDay'] as bool?,
    );

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
      'message': instance.message,
      'xid': instance.id,
      'chatid': instance.chatid,
      'chatSpace': instance.chatSpace,
      'groupid': instance.groupid,
      'type': instance.type,
      'time': instance.time,
      'fromuserid': instance.fromuserid,
      'fromusername': instance.fromusername,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'fromUser': instance.fromUser,
      'reply': instance.reply,
      'firstMessageOfDay': instance.firstMessageOfDay,
      'date': instance.day,
      'isSelectable': instance.isSelectable,
      'seenBy': instance.seenBy,
    };

ReplyTypeModel _$ReplyTypeModelFromJson(Map<String, dynamic> json) =>
    ReplyTypeModel(
      name: json['name'] as String?,
      id: json['id'] as String?,
      message: json['message'] as String?,
      type: json['type'] as String?,
      userid: json['userid'] as String?,
    );

Map<String, dynamic> _$ReplyTypeModelToJson(ReplyTypeModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'message': instance.message,
      'type': instance.type,
      'userid': instance.userid,
    };

FromUser _$FromUserFromJson(Map<String, dynamic> json) => FromUser(
      name: json['name'] as String?,
      email: json['email'] as String?,
      photo: json['photo'] as String?,
    );

Map<String, dynamic> _$FromUserToJson(FromUser instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'photo': instance.photo,
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      photo: json['photo'] as String?,
      chatUser: json['ChatUser'] == null
          ? null
          : ChatUser.fromJson(json['ChatUser'] as Map<String, dynamic>),
      email: json['email'] as String?,
      password: json['password'] as String?,
      connected: json['connected'] as bool? ?? false,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'connected': instance.connected,
      'photo': instance.photo,
      'ChatUser': instance.chatUser,
    };

UserModelInventory _$UserModelInventoryFromJson(Map<String, dynamic> json) =>
    UserModelInventory(
      id: (json['id'] as num?)?.toInt(),
      mail: json['email'] as String?,
      name: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      photo: json['role'] as String?,
    );

Map<String, dynamic> _$UserModelInventoryToJson(UserModelInventory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.mail,
      'first_name': instance.name,
      'last_name': instance.lastName,
      'role': instance.photo,
    };

ProfileGetModel _$ProfileGetModelFromJson(Map<String, dynamic> json) =>
    ProfileGetModel(
      media: json['media'] == null
          ? null
          : Media.fromJson(json['media'] as Map<String, dynamic>),
      groups: (json['groups'] as List<dynamic>?)
          ?.map((e) => Groups.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProfileGetModelToJson(ProfileGetModel instance) =>
    <String, dynamic>{
      'media': instance.media,
      'groups': instance.groups,
    };

ProfileGroupGetModel _$ProfileGroupGetModelFromJson(
        Map<String, dynamic> json) =>
    ProfileGroupGetModel(
      responsecode: (json['response_code'] as num?)?.toInt(),
      status: json['status'] as String?,
      data: json['data'] == null
          ? null
          : GroupProfileDataModel.fromJson(
              json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileGroupGetModelToJson(
        ProfileGroupGetModel instance) =>
    <String, dynamic>{
      'response_code': instance.responsecode,
      'status': instance.status,
      'data': instance.data,
    };

GroupProfileDataModel _$GroupProfileDataModelFromJson(
        Map<String, dynamic> json) =>
    GroupProfileDataModel(
      photo: json['photoUrl'] as String?,
      name: json['name'] as String?,
      discription: json['description'] as String?,
    );

Map<String, dynamic> _$GroupProfileDataModelToJson(
        GroupProfileDataModel instance) =>
    <String, dynamic>{
      'photoUrl': instance.photo,
      'name': instance.name,
      'description': instance.discription,
    };

Media _$MediaFromJson(Map<String, dynamic> json) => Media(
      users: (json['Users'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      messages: (json['Messages'] as List<dynamic>?)
          ?.map((e) => ChatModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MediaToJson(Media instance) => <String, dynamic>{
      'Users': instance.users,
      'Messages': instance.messages,
    };

Groups _$GroupsFromJson(Map<String, dynamic> json) => Groups(
      name: json['name'] as String?,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$GroupsToJson(Groups instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
    };
