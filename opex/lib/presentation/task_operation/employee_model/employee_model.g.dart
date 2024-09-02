// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetEmployeeList _$GetEmployeeListFromJson(Map<String, dynamic> json) =>
    GetEmployeeList(
      gender: json['gender'] as String?,
      userMete: json['user_meta'] == null
          ? null
          : UserMete.fromJson(json['user_meta'] as Map<String, dynamic>),
      whatsapp: json['whatsapp_number'] as String?,
      userCode: json['user_code'] as String?,
      contactNum: json['contact_number_details'] == null
          ? null
          : ContactModel.fromJson(
              json['contact_number_details'] as Map<String, dynamic>),
      WhatsappNum: json['whatsapp_number_details'] == null
          ? null
          : ContactModel.fromJson(
              json['whatsapp_number_details'] as Map<String, dynamic>),
      departmentCode: json['department_code'] as String?,
      orgCode: json['organization_code'] as String?,
      id: (json['id'] as num?)?.toInt(),
      isActive: json['is_active'] as bool? ?? false,
      netCode: json['network_code'] as String?,
      email: json['email'] as String?,
      primaryMail: json['primary_mail'] as String?,
      primaryMobile: json['contact_number'] as String?,
      fname: json['first_name'] as String?,
      lname: json['last_name'] as String?,
      country: json['nationality'] as String?,
      dob: json['date_of_birth'] as String?,
      profile: json['profile_pic'] as String?,
      dateJoined: json['date_joined'] as String?,
      roleName: json['role_name'] as String?,
      code: json['employee_code'] as String?,
      orgType: json['organization_type'] as String?,
      altMobile: json['alternative_mobile_no'] as String?,
      altEmail: json['alternative_email'] as String?,
      designation: json['designation_code'] as String?,
      legalentityCode: json['legalentity_code'] as String?,
      accessSite: json['acess_site'] as String?,
      userLogin: (json['user_login'] as num?)?.toInt(),
      role: json['role'] as String?,
    );

Map<String, dynamic> _$GetEmployeeListToJson(GetEmployeeList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'primary_mail': instance.primaryMail,
      'email': instance.email,
      'contact_number': instance.primaryMobile,
      'whatsapp_number': instance.whatsapp,
      'first_name': instance.fname,
      'last_name': instance.lname,
      'gender': instance.gender,
      'is_active': instance.isActive,
      'nationality': instance.country,
      'date_of_birth': instance.dob,
      'profile_pic': instance.profile,
      'date_joined': instance.dateJoined,
      'role_name': instance.roleName,
      'employee_code': instance.code,
      'user_code': instance.userCode,
      'organization_type': instance.orgType,
      'organization_code': instance.orgCode,
      'network_code': instance.netCode,
      'department_code': instance.departmentCode,
      'alternative_mobile_no': instance.altMobile,
      'alternative_email': instance.altEmail,
      'designation_code': instance.designation,
      'legalentity_code': instance.legalentityCode,
      'acess_site': instance.accessSite,
      'user_login': instance.userLogin,
      'role': instance.role,
      'user_meta': instance.userMete,
      'contact_number_details': instance.contactNum,
      'whatsapp_number_details': instance.WhatsappNum,
    };

GetTaskGroupList _$GetTaskGroupListFromJson(Map<String, dynamic> json) =>
    GetTaskGroupList(
      groupCode: json['group_code'] as String?,
      userId:
          (json['user_id'] as List<dynamic>?)?.map((e) => e as String).toList(),
      gName: json['group_name'] as String?,
      description: json['description'] as String?,
      id: (json['id'] as num?)?.toInt(),
      isActive: json['is_active'] as bool? ?? false,
      isDelete: json['is_delete'] as bool? ?? false,
      userList: (json['users'] as List<dynamic>?)
          ?.map((e) => GetUserList.fromJson(e as Map<String, dynamic>))
          .toList(),
      menberCount: (json['members_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GetTaskGroupListToJson(GetTaskGroupList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'group_code': instance.groupCode,
      'members_count': instance.menberCount,
      'group_name': instance.gName,
      'description': instance.description,
      'users': instance.userList,
      'user_id': instance.userId,
      'is_active': instance.isActive,
      'is_delete': instance.isDelete,
    };

GetUserList _$GetUserListFromJson(Map<String, dynamic> json) => GetUserList(
      email: json['email'] as String?,
      profile: json['profile_pic'] as String?,
      lName: json['last_name'] as String?,
      fName: json['first_name'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
      isActive: json['is_active'] as bool? ?? false,
      userCode: json['user_code'] as String?,
      code: json['code'] as String?,
      role: json['role'] as String?,
      userGroupId: (json['user_group_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GetUserListToJson(GetUserList instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'code': instance.code,
      'user_code': instance.userCode,
      'profile_pic': instance.profile,
      'first_name': instance.fName,
      'last_name': instance.lName,
      'is_active': instance.isActive,
      'email': instance.email,
      'role': instance.role,
      'user_group_id': instance.userGroupId,
    };

ActivityList _$ActivityListFromJson(Map<String, dynamic> json) => ActivityList(
      description: json['description'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      isActive: json['is_active'] as bool? ?? false,
      createdOn: json['created_on'] as String?,
      endDate: json['end_date'] as String?,
      startDate: json['start_date'] as String?,
      typeName: json['type_name'] as String?,
      isDelete: json['is_delete'] as bool? ?? false,
      title: json['title'] as String?,
      typeId: (json['type_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ActivityListToJson(ActivityList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'type_id': instance.typeId,
      'type_name': instance.typeName,
      'description': instance.description,
      'title': instance.title,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'created_on': instance.createdOn,
      'is_active': instance.isActive,
      'is_delete': instance.isDelete,
    };

LogInData _$LogInDataFromJson(Map<String, dynamic> json) => LogInData(
      logInId: (json['login_id'] as num?)?.toInt(),
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
      username: json['username'] as String?,
      fname: json['fname'] as String?,
      lname: json['lname'] as String?,
      employeeCode: json['code'] as String?,
      token: json['token'] as String?,
      role: (json['role'] as List<dynamic>?)?.map((e) => e as String).toList(),
      legalEntry: json['legal_entiry'] as String?,
      orgType: json['organization_type'] as String?,
      orgCode: json['organization_code'] as String?,
    );

Map<String, dynamic> _$LogInDataToJson(LogInData instance) => <String, dynamic>{
      'login_id': instance.logInId,
      'email': instance.email,
      'mobile': instance.mobile,
      'username': instance.username,
      'fname': instance.fname,
      'lname': instance.lname,
      'code': instance.employeeCode,
      'token': instance.token,
      'role': instance.role,
      'legal_entiry': instance.legalEntry,
      'organization_type': instance.orgType,
      'organization_code': instance.orgCode,
    };

EmployeeCreateRead _$EmployeeCreateReadFromJson(Map<String, dynamic> json) =>
    EmployeeCreateRead(
      userRole: (json['user_roles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      gender:
          (json['gender'] as List<dynamic>?)?.map((e) => e as String).toList(),
      userData: (json['user_data'] as List<dynamic>?)
          ?.map((e) => GetEmployeeList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EmployeeCreateReadToJson(EmployeeCreateRead instance) =>
    <String, dynamic>{
      'gender': instance.gender,
      'user_roles': instance.userRole,
      'user_data': instance.userData,
    };

UserMete _$UserMeteFromJson(Map<String, dynamic> json) => UserMete(
      roleName: json['official_role_name'] as String?,
      roleList: (json['additional_roles_list'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      profile: json['profile_pic'] as String?,
      roleId: (json['official_role'] as num?)?.toInt(),
      roleListId: (json['additional_roles'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$UserMeteToJson(UserMete instance) => <String, dynamic>{
      'official_role_name': instance.roleName,
      'official_role': instance.roleId,
      'profile_pic': instance.profile,
      'additional_roles_list': instance.roleList,
      'additional_roles': instance.roleListId,
    };

CommunicationTaskGroup _$CommunicationTaskGroupFromJson(
        Map<String, dynamic> json) =>
    CommunicationTaskGroup(
      createdBy: json['createdBy'] as String?,
      friendList: (json['friends'] as List<dynamic>?)
          ?.map((e) => FriendListModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      taskCode: json['task_code'] as String?,
      taskName: json['task_name'] as String?,
    );

Map<String, dynamic> _$CommunicationTaskGroupToJson(
        CommunicationTaskGroup instance) =>
    <String, dynamic>{
      'task_name': instance.taskName,
      'task_code': instance.taskCode,
      'createdBy': instance.createdBy,
      'friends': instance.friendList,
    };

FriendListModel _$FriendListModelFromJson(Map<String, dynamic> json) =>
    FriendListModel(
      email: json['email'] as String?,
      fName: json['fname'] as String?,
      lName: json['lname'] as String?,
      userCode: json['user_code'] as String?,
    );

Map<String, dynamic> _$FriendListModelToJson(FriendListModel instance) =>
    <String, dynamic>{
      'user_code': instance.userCode,
      'fname': instance.fName,
      'lname': instance.lName,
      'email': instance.email,
    };

createTaskGroupChat _$createTaskGroupChatFromJson(Map<String, dynamic> json) =>
    createTaskGroupChat(
      groupid: json['groupid'] as String?,
      groupName: json['groupName'] as String?,
      createdBy: json['createdBy'] as String?,
    );

Map<String, dynamic> _$createTaskGroupChatToJson(
        createTaskGroupChat instance) =>
    <String, dynamic>{
      'groupid': instance.groupid,
      'groupName': instance.groupName,
      'createdBy': instance.createdBy,
    };

ContactModel _$ContactModelFromJson(Map<String, dynamic> json) => ContactModel(
      countryCode: json['country_code'] as String?,
      number: json['number'] as String?,
    );

Map<String, dynamic> _$ContactModelToJson(ContactModel instance) =>
    <String, dynamic>{
      'country_code': instance.countryCode,
      'number': instance.number,
    };
