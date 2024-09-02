// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetTaskTypeList _$GetTaskTypeListFromJson(Map<String, dynamic> json) =>
    GetTaskTypeList(
      description: json['description'] as String?,
      id: (json['id'] as num?)?.toInt(),
      typeName: json['type_name'] as String?,
      isActive: json['is_active'] as bool? ?? false,
      isDelete: json['is_delete'] as bool? ?? false,
    );

Map<String, dynamic> _$GetTaskTypeListToJson(GetTaskTypeList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type_name': instance.typeName,
      'description': instance.description,
      'is_active': instance.isActive,
      'is_delete': instance.isDelete,
    };

GetTaskList _$GetTaskListFromJson(Map<String, dynamic> json) => GetTaskList(
      name: json['name'] as String?,
      profile: json['profile_pic'] as String?,
      parentDict: json['parent_task_dict'] == null
          ? null
          : ParentDict.fromJson(
              json['parent_task_dict'] as Map<String, dynamic>),
      parentGroupId: (json['parent_group_id'] as num?)?.toInt(),
      assignByDict: json['assigned_by_dict'] == null
          ? null
          : PerfomerModel.fromJson(
              json['assigned_by_dict'] as Map<String, dynamic>),
      assignToDict: json['assigned_to_dict'] == null
          ? null
          : PerfomerModel.fromJson(
              json['assigned_to_dict'] as Map<String, dynamic>),
      reportingPersonDict: json['reporting_person_dict'] == null
          ? null
          : PerfomerModel.fromJson(
              json['reporting_person_dict'] as Map<String, dynamic>),
      reviewCount: (json['review_count'] as num?)?.toInt(),
      groupId: (json['group_id'] as num?)?.toInt(),
      assignNameCard: json['assigning_name'] as String?,
      topic: json['topic'] as String?,
      duration: json['duration'] as String?,
      imgCount: (json['image_count'] as num?)?.toInt(),
      taskTypeName: json['task_type_name'] as String?,
      paymentMeta: json['payment_data'] == null
          ? null
          : CostingMeta.fromJson(json['payment_data'] as Map<String, dynamic>),
      rewardsData: json['rewards_data'] == null
          ? null
          : CostingMeta.fromJson(json['rewards_data'] as Map<String, dynamic>),
      reportId: (json['report_id'] as num?)?.toInt(),
      currency: json['currency_code'] as String?,
      isReported: json['is_reported'] as bool? ?? false,
      locayionUrl: json['location_url'] as String?,
      jobTitle: json['job_title'] as String?,
      jobDiscription: json['job_description'] as String?,
      assignToEmail: json['assigned_to'] as String?,
      assignToName: json['assigned_to_name'] as String?,
      description: json['description'] as String?,
      paymentId: (json['payment_id'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      rewardid: (json['reward_id'] as num?)?.toInt(),
      reportingPersonCode: json['reporting_person_code'] as String?,
      isNotify: json['is_notify'] as bool? ?? false,
      createdPersonCode: json['created_person_code'] as String?,
      createdOn: json['created_on'] as String?,
      longitude: json['longitude'] as String?,
      latitude: json['latitude'] as String?,
      isActive: json['is_active'] as bool? ?? false,
      isDelete: json['is_delete'] as bool? ?? false,
      priority: json['priority'] as String?,
      endDate: json['end_date'] as String?,
      isPinned: json['is_pinned'] as bool? ?? false,
      startDate: json['start_date'] as String?,
      statusName: json['status_name'] as String?,
      reportingPerson: json['reporting_person'] as String?,
      statusStagesId: (json['status_stages_id'] as num?)?.toInt(),
      createdBy: (json['created_by'] as num?)?.toInt(),
      assigningCode: json['assigning_code'] as String?,
      assigningType: json['assigning_type'] as String?,
      jobId: (json['job_id'] as num?)?.toInt(),
      assignName: json['assigned_by_name'] as String?,
      reportingName: json['reporting_person_name'] as String?,
      lastModified: json['last_modified'] as String?,
      left: (json['lft'] as num?)?.toInt(),
      level: (json['level'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      parent: (json['parent'] as num?)?.toInt(),
      priorityLevel: (json['priority_level'] as num?)?.toInt(),
      remarks: json['remarks'] as String?,
      right: (json['rght'] as num?)?.toInt(),
      taskCode: json['task_code'] as String?,
      metaData: json['task_meta'] == null
          ? null
          : CostingMeta.fromJson(json['task_meta'] as Map<String, dynamic>),
      taskName: json['task_name'] as String?,
      taskType: (json['task_type'] as num?)?.toInt(),
      treeId: (json['tree_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GetTaskListToJson(GetTaskList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'task_name': instance.taskName,
      'topic': instance.topic,
      'duration': instance.duration,
      'task_type_name': instance.taskTypeName,
      'job_title': instance.jobTitle,
      'job_description': instance.jobDiscription,
      'name': instance.name,
      'report_id': instance.reportId,
      'group_id': instance.groupId,
      'currency_code': instance.currency,
      'profile_pic': instance.profile,
      'is_notify': instance.isNotify,
      'assigned_to': instance.assignToEmail,
      'assigned_to_name': instance.assignToName,
      'task_code': instance.taskCode,
      'reporting_person_code': instance.reportingPersonCode,
      'created_person_code': instance.createdPersonCode,
      'description': instance.description,
      'priority_level': instance.priorityLevel,
      'payment_id': instance.paymentId,
      'reward_id': instance.rewardid,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'is_active': instance.isActive,
      'is_delete': instance.isDelete,
      'is_pinned': instance.isPinned,
      'is_reported': instance.isReported,
      'assigning_type': instance.assigningType,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'status_name': instance.statusName,
      'reporting_person_name': instance.reportingName,
      'assigned_by_name': instance.assignName,
      'assigning_name': instance.assignNameCard,
      'assigning_code': instance.assigningCode,
      'notes': instance.notes,
      'remarks': instance.remarks,
      'priority': instance.priority,
      'created_on': instance.createdOn,
      'last_modified': instance.lastModified,
      'task_meta': instance.metaData,
      'payment_data': instance.paymentMeta,
      'rewards_data': instance.rewardsData,
      'lft': instance.left,
      'rght': instance.right,
      'tree_id': instance.treeId,
      'level': instance.level,
      'parent': instance.parent,
      'parent_group_id': instance.parentGroupId,
      'job_id': instance.jobId,
      'image_count': instance.imgCount,
      'review_count': instance.reviewCount,
      'task_type': instance.taskType,
      'status_stages_id': instance.statusStagesId,
      'reporting_person': instance.reportingPerson,
      'location_url': instance.locayionUrl,
      'created_by': instance.createdBy,
      'assigned_by_dict': instance.assignByDict,
      'assigned_to_dict': instance.assignToDict,
      'reporting_person_dict': instance.reportingPersonDict,
      'parent_task_dict': instance.parentDict,
    };

ParentDict _$ParentDictFromJson(Map<String, dynamic> json) => ParentDict(
      description: json['description'] as String?,
      taskName: json['task_name'] as String?,
    );

Map<String, dynamic> _$ParentDictToJson(ParentDict instance) =>
    <String, dynamic>{
      'task_name': instance.taskName,
      'description': instance.description,
    };

GetCountTask _$GetCountTaskFromJson(Map<String, dynamic> json) => GetCountTask(
      assignTask: (json['Assigned Task'] as num?)?.toInt(),
      taskCompleted: (json['Task Completed'] as num?)?.toInt(),
      taskOnProgress: (json['Task on Progress'] as num?)?.toInt(),
      taskPending: (json['Task Pending'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GetCountTaskToJson(GetCountTask instance) =>
    <String, dynamic>{
      'Assigned Task': instance.assignTask,
      'Task Completed': instance.taskCompleted,
      'Task on Progress': instance.taskOnProgress,
      'Task Pending': instance.taskPending,
    };

GetReadCreateTask _$GetReadCreateTaskFromJson(Map<String, dynamic> json) =>
    GetReadCreateTask(
      assignType: (json['assigning_type'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      priority: (json['priority'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      duration: (json['duration_option'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$GetReadCreateTaskToJson(GetReadCreateTask instance) =>
    <String, dynamic>{
      'priority': instance.priority,
      'assigning_type': instance.assignType,
      'duration_option': instance.duration,
    };

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) => PaymentModel(
      taskId: (json['task_id'] as num?)?.toInt(),
      assigningName: json['assigning_name'] as String?,
      costingMeta: json['costing_meta'] == null
          ? null
          : CostingMeta.fromJson(json['costing_meta'] as Map<String, dynamic>),
      jobId: (json['job_id'] as num?)?.toInt(),
      description: json['description'] as String?,
      assigningCode: json['assigning_code'] as String?,
      assigningType: json['assigning_type'] as String?,
      budget: (json['budget'] as num?)?.toDouble(),
      expense: (json['expense'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      id: (json['id'] as num?)?.toInt(),
      isDelete: json['is_delete'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? false,
      costCode: json['cost_code'] as String?,
    );

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'job_id': instance.jobId,
      'task_id': instance.taskId,
      'assigning_type': instance.assigningType,
      'budget': instance.budget,
      'assigning_code': instance.assigningCode,
      'assigning_name': instance.assigningName,
      'description': instance.description,
      'notes': instance.notes,
      'expense': instance.expense,
      'cost_code': instance.costCode,
      'costing_meta': instance.costingMeta,
      'is_active': instance.isActive,
      'is_delete': instance.isDelete,
    };

CostingMeta _$CostingMetaFromJson(Map<String, dynamic> json) => CostingMeta(
      image1: json['image1'] as String?,
      note: json['attachment_note'] as String?,
      name: json['name'] as String?,
      notes: json['notes'] as String?,
      descriptionreward: json['description'] as String?,
      description: json['attachment_description'] as String?,
      image2: json['image2'] as String?,
      image3: json['image3'] as String?,
      image4: json['image4'] as String?,
      image5: json['image5'] as String?,
    );

Map<String, dynamic> _$CostingMetaToJson(CostingMeta instance) =>
    <String, dynamic>{
      'image1': instance.image1,
      'image2': instance.image2,
      'image3': instance.image3,
      'image4': instance.image4,
      'image5': instance.image5,
      'attachment_note': instance.note,
      'name': instance.name,
      'description': instance.descriptionreward,
      'notes': instance.notes,
      'attachment_description': instance.description,
    };

PointsList _$PointsListFromJson(Map<String, dynamic> json) => PointsList(
      id: (json['id'] as num?)?.toInt(),
      isDelete: json['is_delete'] as bool? ?? false,
      name: json['name'] as String?,
      isActive: json['is_active'] as bool? ?? false,
      points: (json['points'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PointsListToJson(PointsList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'points': instance.points,
      'is_active': instance.isActive,
      'is_delete': instance.isDelete,
    };

ReadRewards _$ReadRewardsFromJson(Map<String, dynamic> json) => ReadRewards(
      id: (json['id'] as num?)?.toInt(),
      rewardsMeta: json['rewards_meta'] == null
          ? null
          : CostingMeta.fromJson(json['rewards_meta'] as Map<String, dynamic>),
      isDelete: json['is_delete'] as bool? ?? false,
      name: json['name'] as String?,
      isActive: json['is_active'] as bool? ?? false,
      description: json['description'] as String?,
      notes: json['notes'] as String?,
      types: json['types'] as String?,
      typeId: (json['type_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReadRewardsToJson(ReadRewards instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'notes': instance.notes,
      'rewards_meta': instance.rewardsMeta,
      'types': instance.types,
      'type_id': instance.typeId,
      'is_active': instance.isActive,
      'is_delete': instance.isDelete,
    };

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
      notes: json['notes'] as String?,
      reviewMeta: json['review_meta'] == null
          ? null
          : CostingMeta.fromJson(json['review_meta'] as Map<String, dynamic>),
      review: json['review'] as String?,
      parent: (json['parent'] as num?)?.toInt(),
      taskId: (json['task_id'] as num?)?.toInt(),
      image: json['image'] as String?,
      reviewdBy: (json['reviewed_by'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      isActive: json['is_active'] as bool? ?? false,
      isDelete: json['is_delete'] as bool? ?? false,
      reviewedPersonCode: json['reviewed_person_code'] as String?,
      reviewedPersonName: json['reviewed_person_name'] as String?,
      reviewOn: json['reviewed_on'] as String?,
    );

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parent': instance.parent,
      'reviewed_by': instance.reviewdBy,
      'notes': instance.notes,
      'review': instance.review,
      'image': instance.image,
      'task_id': instance.taskId,
      'reviewed_on': instance.reviewOn,
      'review_meta': instance.reviewMeta,
      'is_active': instance.isActive,
      'is_delete': instance.isDelete,
      'reviewed_person_code': instance.reviewedPersonCode,
      'reviewed_person_name': instance.reviewedPersonName,
    };

ReviewModelList _$ReviewModelListFromJson(Map<String, dynamic> json) =>
    ReviewModelList(
      notes: json['notes'] as String?,
      review: json['review'] as String?,
      parent: (json['parent'] as num?)?.toInt(),
      taskId: (json['task_id'] as num?)?.toInt(),
      image: (json['image'] as num?)?.toInt(),
      reviewdBy: (json['reviewed_by'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      isActive: json['is_active'] as bool? ?? false,
      isDelete: json['is_delete'] as bool? ?? false,
      reviewedPersonCode: json['reviewed_person_code'] as String?,
      reviewedPersonName: json['reviewed_person_name'] as String?,
      reviewOn: json['reviewed_on'] as String?,
    );

Map<String, dynamic> _$ReviewModelListToJson(ReviewModelList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parent': instance.parent,
      'reviewed_by': instance.reviewdBy,
      'notes': instance.notes,
      'review': instance.review,
      'image': instance.image,
      'task_id': instance.taskId,
      'reviewed_on': instance.reviewOn,
      'is_active': instance.isActive,
      'is_delete': instance.isDelete,
      'reviewed_person_code': instance.reviewedPersonCode,
      'reviewed_person_name': instance.reviewedPersonName,
    };

ReadPerformanceAppraisal _$ReadPerformanceAppraisalFromJson(
        Map<String, dynamic> json) =>
    ReadPerformanceAppraisal(
      performanceList: (json['performance_appraisal'] as List<dynamic>?)
          ?.map((e) => PerformanceList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReadPerformanceAppraisalToJson(
        ReadPerformanceAppraisal instance) =>
    <String, dynamic>{
      'performance_appraisal': instance.performanceList,
    };

PerformanceList _$PerformanceListFromJson(Map<String, dynamic> json) =>
    PerformanceList(
      id: (json['id'] as num?)?.toInt(),
      pointId: json['points_id'] == null
          ? null
          : PointId.fromJson(json['points_id'] as Map<String, dynamic>),
      userId: (json['user_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      taskId: (json['task_id'] as num?)?.toInt(),
      points: (json['points'] as num?)?.toInt(),
      user: (json['user'] as num?)?.toInt(),
      taskIdId: (json['task_id_id'] as num?)?.toInt(),
      isActive: json['is_active'] as bool? ?? false,
      isDelete: json['is_delete'] as bool? ?? false,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$PerformanceListToJson(PerformanceList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'points_id': instance.pointId,
      'user_id': instance.userId,
      'points': instance.points,
      'user': instance.user,
      'task_id': instance.taskId,
      'task_id_id': instance.taskIdId,
      'name': instance.name,
      'description': instance.description,
      'is_active': instance.isActive,
      'is_delete': instance.isDelete,
    };

PointId _$PointIdFromJson(Map<String, dynamic> json) => PointId(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      points: (json['points'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PointIdToJson(PointId instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'points': instance.points,
    };

CriteriaRead _$CriteriaReadFromJson(Map<String, dynamic> json) => CriteriaRead(
      attittude: (json['Technical Skills and Innovation'] as List<dynamic>?)
          ?.map((e) => Punchuality.fromJson(e as Map<String, dynamic>))
          .toList(),
      overAllPoints: (json['Overall Points'] as List<dynamic>?)
          ?.map((e) => Punchuality.fromJson(e as Map<String, dynamic>))
          .toList(),
      projectCompletion:
          (json['Team Collaboration and Leadership'] as List<dynamic>?)
              ?.map((e) => Punchuality.fromJson(e as Map<String, dynamic>))
              .toList(),
      punctuality: (json['Task Quality'] as List<dynamic>?)
          ?.map((e) => Punchuality.fromJson(e as Map<String, dynamic>))
          .toList(),
      teamManagement: (json['Business Requirements'] as List<dynamic>?)
          ?.map((e) => Punchuality.fromJson(e as Map<String, dynamic>))
          .toList(),
      timeMange: (json['Efficient Time Management'] as List<dynamic>?)
          ?.map((e) => Punchuality.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CriteriaReadToJson(CriteriaRead instance) =>
    <String, dynamic>{
      'Overall Points': instance.overAllPoints,
      'Task Quality': instance.punctuality,
      'Technical Skills and Innovation': instance.attittude,
      'Team Collaboration and Leadership': instance.projectCompletion,
      'Business Requirements': instance.teamManagement,
      'Efficient Time Management': instance.timeMange,
    };

Punchuality _$PunchualityFromJson(Map<String, dynamic> json) => Punchuality(
      name: json['name'] as String?,
      points: (json['average_points'] as num?)?.toDouble(),
      email: json['email'] as String?,
    );

Map<String, dynamic> _$PunchualityToJson(Punchuality instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'average_points': instance.points,
    };

ReportModel _$ReportModelFromJson(Map<String, dynamic> json) => ReportModel(
      taskId: (json['task_id'] as num?)?.toInt(),
      reportStatus: json['report_status'] as String?,
      reply: json['reply'] as String?,
      id: (json['id'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      taskDescription: json['task_description'] as String?,
      taskName: json['task_name'] as String?,
      topicName: json['topic_name'] as String?,
      userName: json['user_name'] as String?,
    );

Map<String, dynamic> _$ReportModelToJson(ReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'task_id': instance.taskId,
      'task_name': instance.taskName,
      'task_description': instance.taskDescription,
      'topic_name': instance.topicName,
      'notes': instance.notes,
      'user_name': instance.userName,
      'reply': instance.reply,
      'report_status': instance.reportStatus,
    };

NotificationList _$NotificationListFromJson(Map<String, dynamic> json) =>
    NotificationList(
      description: json['description'] as String?,
      count: (json['notification_count'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      userCode: json['user_code'] as String?,
      appNotificationCode: json['app_notification_code'] as String?,
      createOn: json['created_on'] as String?,
      isNew: json['is_new'] as bool? ?? false,
      notificationType: json['notification_type'] as String?,
      notificationTypeId: json['notification_type_id'] as String?,
      isActive: json['is_active'] as bool? ?? false,
      isDelete: json['is_delete'] as bool? ?? false,
    );

Map<String, dynamic> _$NotificationListToJson(NotificationList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notification_count': instance.count,
      'app_notification_code': instance.appNotificationCode,
      'notification_type': instance.notificationType,
      'notification_type_id': instance.notificationTypeId,
      'user_code': instance.userCode,
      'description': instance.description,
      'created_on': instance.createOn,
      'is_active': instance.isActive,
      'is_delete': instance.isDelete,
      'is_new': instance.isNew,
    };

ReadMarkRead _$ReadMarkReadFromJson(Map<String, dynamic> json) => ReadMarkRead(
      key: json['key'] as String?,
      value: json['value'] as String?,
    );

Map<String, dynamic> _$ReadMarkReadToJson(ReadMarkRead instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
    };

PerfomerModel _$PerfomerModelFromJson(Map<String, dynamic> json) =>
    PerfomerModel(
      fName: json['first_name'] as String?,
      userCode: json['user_code'] as String?,
      lName: json['last_name'] as String?,
      profile: json['profile_pic'] as String?,
      email: json['email'] as String?,
      points: (json['highest_average_points'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PerfomerModelToJson(PerfomerModel instance) =>
    <String, dynamic>{
      'first_name': instance.fName,
      'last_name': instance.lName,
      'email': instance.email,
      'user_code': instance.userCode,
      'profile_pic': instance.profile,
      'highest_average_points': instance.points,
    };

SearchMapResultsModel _$SearchMapResultsModelFromJson(
        Map<String, dynamic> json) =>
    SearchMapResultsModel(
      id: (json['id'] as num?)?.toInt(),
      locationData: json['geometry'] == null
          ? null
          : GeometryLocation.fromJson(json['geometry'] as Map<String, dynamic>),
      formattedAddress: json['formatted_address'] as String?,
    );

Map<String, dynamic> _$SearchMapResultsModelToJson(
        SearchMapResultsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'geometry': instance.locationData,
      'formatted_address': instance.formattedAddress,
    };

GeometryLocation _$GeometryLocationFromJson(Map<String, dynamic> json) =>
    GeometryLocation(
      id: (json['id'] as num?)?.toInt(),
      latAndLang: json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GeometryLocationToJson(GeometryLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'location': instance.latAndLang,
    };

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };
