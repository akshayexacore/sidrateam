import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../../core/utils/data_response.dart';
import '../../home/model/joblist_model.dart';
import '../model/task_models.dart';
import '../task_datasource.dart';
import '../task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskDataSource _taskDataSource = TaskDataSource();
  final TaskRepo _taskRepo = TaskRepo();
  List<GetTaskList> tasklist = [];
  String? next;
  TaskBloc() : super(GetTaskTypeListInitial());

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is GetTaskTypeListEvent) {
      yield* getTaskTypeListState();
    }
    if (event is GetTaskListEvent) {
      yield* getTaskListState(id:event.id,
      prev: event.prev,
      next: event.next,
      search: event.search,
      filter: event.filter,
      priority: event.priority,
      status: event.status);
    }
    if (event is GetAllJobsListEvent) {
      yield* getAllJobsListState(
          prev: event.prev,
          next: event.next,
          search: event.search,
          filter: event.filter,
          priority: event.priority,
          status: event.status,
      reportingPersonFilter: event.reportingPersonFilter);
    }
    if (event is GetOrganisationPerformanceList) {
      yield* getOrganisationPerformanceList(
          month: event.month,
          year: event.year,);
    }
    if (event is GetNotificationListEvent) {
      yield* getNotificationList(
      prev: event.prev,
      next: event.next,
      search: event.search);
    }
    if (event is NotificationIconEvent) {
      yield* NotificationIcon();
    }
    if (event is GetPendingTaskListEvent) {
      yield* getPendingTaskListState();
    }
    if (event is GetPinnedTaskListEvent) {
      yield* getPinnedTaskListState();
    }
    if (event is GetTopicListEvent) {
      yield* getTopicListState();
    }
    if (event is GetSubTaskListEvent) {
      yield* getSubTaskListState(event.taskId);
    }
    if (event is GetReviewListEvent) {
      yield* getReviewListState(event.taskId);
    }
    if (event is GetPerformanceListEvent) {
      yield* getPerformanceList(event.taskid,event.code);
    }
    else if (event is GetTaskReadListEvent) {
      yield* getTaskRead(event.id);
    }
    else if (event is GetTaskReadCreateEvent) {
      yield* getTaskCreationRead();
    }
    else if (event is GetJobReadCreateEvent) {
      yield* getJobCreationRead();
    }
    if (event is GetReadRewardsEvent) {
      yield* getReadRewards(event.id,event.isTask);
    }
     if (event is GetPerformanceReadEvent) {
      yield* getPerformanceRead(event.id);
    }
     if (event is GetTotalPerformanceEvent) {
      yield* getTotalPerformance(event.employeeCode,event.id);
    }
    if (event is DeleteTaskEvent) {
      yield* deleteTask(jobId: event.taskId);
    }
    if (event is DeleteReviewEvent) {
      yield* deleteReview(reviewId: event.reviewId);
    }
     if (event is GetPaymentReadListEvent) {
      yield* getPaymentRead(event.id,event.isTask);
    }
    else if (event is GetAssignCountEvent) {
      yield* getAssignCount(event.id);
    }
    if (event is CreateTaskEvent) {
      yield* createTaskstate(
        endTime: event.endTime??"",
        startTime: event.startTime??"",
        longitude: event.longitude,
          durationOption: event.durationOption,
          latitude: event.latitude,
          startDate: event.startDate.trim(),
          endDate: event.endDate.trim(),
          reportingPerson: event.reportingPerson,
          priority: event.priority.trim(),
          isActive: event.isActive,
          discription: event.discription.trim(),
          createdBy: event.createdBy,
        AssigningCode: event.AssigningCode.trim(),
        AssigningType: event.AssigningType.trim(),
        createdOn: event.createdOn.trim(),
        jobId: event.jobId,
        lastmodified: event.lastmodified?.trim(),
        notas: event.notas.trim(),
        parant: event.parant,
        priorityLeval: event.priorityLeval,
        remarks: event.remarks.trim(),
        taskName: event.taskName.trim(),
        taskType: event.taskType,
        statusStagesId: event.statusStagesId,

      );
    }
    if (event is CreateReportEvent) {
      yield* createReport(

        notes: event.notes,
        taskId: event.taskId,
        toipicId: event.toipicId,
        userId: event.userId
      );
    }
    if (event is ReplayReportEvent) {
      yield* replayReport(

        replayType: event.replayType,
         reAssignCode: event.reAssignCode,
         id: event.id,
        replay: event.replay,
        reportStatus: event.reportStatus
      );
    }
    if (event is UpdateTaskEvent) {
      yield* updateTaskstate(
        startTime: event.startTime,
         endTime: event.endTime,
         durationOption: event.durationOption,
        attachNote: event.attachmentNote?.trim(),
        attachdescription: event.attachmentDescription?.trim(),
        img5: event.img5,
        img1: event.img1,
        img2: event.img2,
        img3: event.img3,
        img4: event.img4,
        latitude: event.latitude,
        longitude: event.longitude,
        startDate: event.startDate.trim(),
        endDate: event.endDate.trim(),
        reportingPerson: event.reportingPerson,
        priority: event.priority.trim(),
        isActive: event.isActive,
        discription: event.discription.trim(),
        createdBy: event.createdBy,
        AssigningCode: event.AssigningCode.trim(),
        AssigningType: event.AssigningType.trim(),
        createdOn: event.createdOn.trim(),
        jobid: event.jobid,
        id:event.id,
        lastmodified: event.lastmodified?.trim(),
        notas: event.notas.trim(),
        parant: event.parant,
        priorityLeval: event.priorityLeval,
        remarks: event.remarks.trim(),
        taskName: event.taskName.trim(),
        taskType: event.taskType,
        statusStagesId: event.statusStagesId,

      );
    }
    if (event is UpdateReportingTaskEvent) {
      yield* updateReportingTaskstate(
        durationOption: event.durationOption,
        startTime: event.startTime,
        endTime: event.endTime,
        attachNote: event.attachmentNote?.trim(),
        attachdescription: event.attachmentDescription?.trim(),
        img5: event.img5,
        img1: event.img1,
        img2: event.img2,
        img3: event.img3,
        img4: event.img4,
        latitude: event.latitude,
        longitude: event.longitude,
        startDate: event.startDate.trim(),
        endDate: event.endDate.trim(),
        reportingPerson: event.reportingPerson,
        priority: event.priority.trim(),
        isActive: event.isActive,
        discription: event.discription.trim(),
        createdBy: event.createdBy,
        AssigningCode: event.AssigningCode.trim(),
        AssigningType: event.AssigningType.trim(),
        createdOn: event.createdOn.trim(),
        jobid: event.jobid,
        id:event.id,
        lastmodified: event.lastmodified?.trim(),
        notas: event.notas.trim(),
        parant: event.parant,
        priorityLeval: event.priorityLeval,
        remarks: event.remarks.trim(),
        taskName: event.taskName.trim(),
        taskType: event.taskType,
        statusStagesId: event.statusStagesId,

      );
    }
    if (event is CreateReviewTaskEvent) {
      yield* createReviewTask(
        image: event.image??0,
        parant: event.parant,
        taskId: event.taskId,
        notes: event.notes??"",
        review: event.review??"",
        reviewedBy: event.reviewdBy.trim()


      );
    }
    if (event is UpdateReviewTaskEvent) {
      yield* updateReviewTask(
        taskId: event.taskId,
          image: event.image,
          parant: event.parant,
          id: event.id,
          notas: event.notes??"",
          review: event.review??"",
          reviewdBy: event.reviewdBy.trim(),
        isActive: event.isActive


      );
    }
    if (event is CreatePerfomanceAppraisalTaskEvent) {
      yield* createPerformanceAppraisalTask(
          name: event.name.trim(),
          discription: event.discription.trim(),
          taskId: event.taskId,
          userId: event.userId,
          pointId: event.pointId,
      );
    }
    if (event is CreateRewardTaskEvent) {
      yield* createReward(
        type: event.type??"",
          typeId: event.typeId??0,
          img5: event.img5,
          img4: event.img4,
          img3: event.img3,
          img2: event.img2,
          img1: event.img1,
          discription: event.discription.trim(),
          name: event.name.trim(),
          notes: event.notes.trim(),
      );
    }
    if (event is UpdateRewardTaskEvent) {
      yield* updateRewards(
        type: event.type??"",
        typeId: event.typeId??0,
        img5: event.img5,
        img1: event.img1,
        img2: event.img2,
        img3: event.img3,
        img4: event.img4,
        discription: event.discription.trim(),
        name: event.name.trim(),
        notes: event.notes.trim(),
        isActive: event.isActive,
        id: event.id,
      );
    }
    if (event is CreatePaymentEvent) {
      yield* createPaymentstate(

        discription: event.discription.trim(),
        AssigningCode: event.AssigningCode.trim(),
        assigningType: event.assigningType.trim(),
        jobId: event.jobId,
        taskId: event.taskId,
        notas: event.notas.trim(),
        budget: event.budget,
        expense: event.expense,
        img1: event.img1,
        img2: event.img2,
        img3: event.img3,
        img4: event.img4,
        img5: event.img5

      );
    }
    if (event is UpdatePaymentEvent) {
      yield* updatePaymentstate(
        payId: event.payId,

        img1: event.img1,
        img2: event.img2,
        img3: event.img3,
        img4: event.img4,
        img5: event.img5,
        discription: event.discription.trim(),
        AssigningCode: event.AssigningCode.trim(),
        assigningType: event.assigningType.trim(),
        jobId: event.jobId,
        taskId: event.taskId,
        notas: event.notas.trim(),
        budget: event.budget,
        expense: event.expense,
        isActive: event.isActive

      );
    }
    if (event is GetPointsListEvent) {
      yield* getPointsList();
    }
    if (event is TaskAssignedGroupListEvent) {
      yield* TaskAssignedGroupListState(event.code.trim(),event.prev?.trim());
    }
    else if (event is GetCriteriaReadEvent) {
      yield* getCriteriaRead(event.taskCode);
    }
    if (event is NotificationDueEvent) {
      yield* getNotificationDue(event.id);
    }
    if (event is ReportListAdminEvent) {
      yield* ReportListAdminList(
          next: event.next?.trim(),
          prev: event.prev?.trim(),
      );
    }
    if (event is ReportListUserEvent) {
      yield* ReportListUserList(

          next: event.next?.trim(),
          prev: event.prev?.trim(),
      );
    }
    if (event is SearchMapResults) {
      yield* searchMapLocation(searchQuery: event.searchQuery);
    }
  }


  //jobListState
  Stream<TaskState> getTaskTypeListState() async* {
    yield GetTaskTypeListLoading();

    final dataResponse = await _taskRepo.getTaskTypeList();

    if (dataResponse.data.isNotEmpty) {
      yield GetTaskTypeListSuccess(dataResponse.data);
    } else {
      yield GetTaskTypeListFailed();
    }
  }

  Stream<TaskState> getTaskListState({
    String? search,String? next,String? prev,int? id,bool? filter,String? status,String? priority
  }) async* {
    yield GetTaskListLoading();
    final dataResponse = await _taskRepo.getTaskList(search,next,prev,id,filter,status,priority);
    if (dataResponse.data !=null ) {
      yield GetTaskListSuccess(
          prevPageUrl: dataResponse.previousUrl??"",
          nextPageUrl: dataResponse.nextPageUrl ?? "",
          taskList:  dataResponse.data);  }

    else {
      yield GetTaskListFailed("failed");
    }
  }

  //all
  Stream<TaskState> getAllJobsListState({
    String? search,String? next,String? prev,bool? filter,String? status,String? priority,String? reportingPersonFilter
  }) async* {
    yield GetAllJobsListLoading();
    final dataResponse = await _taskRepo.getAllJobsList(search,next,prev,filter,status,priority,reportingPersonFilter);
    if (dataResponse.data !=null) {
      yield GetAllJobsListSuccess(
          prevPageUrl: dataResponse.previousUrl??"",
          nextPageUrl: dataResponse.nextPageUrl ?? "",
          taskList:  dataResponse.data);  }

    else {
      yield GetAllJobsListFailed("failed");
    }
  }


  //orgPerlist
  Stream<TaskState> getOrganisationPerformanceList({
    int? year,int? month,
  }) async* {
    yield GetOrgPerfListLoading();
    final dataResponse = await _taskRepo.getOrganisationPerformanceList(year,month);
    if (dataResponse.data !=null &&dataResponse.data.isNotEmpty) {
      yield GetOrgPerfListSuccess(
          prevPageUrl: dataResponse.previousUrl??"",
          nextPageUrl: dataResponse.nextPageUrl ?? "",
          taskList:  dataResponse.data);  }

    else {
      yield GetOrgPerfListFailed("failed");
    }
  }

  //notification
  Stream<TaskState> getNotificationList({
    String? search,String? next,String? prev
  }) async* {
    yield GetNotificationListLoading();
    final dataResponse = await _taskRepo.getNotificationList(search,next,prev);
    if (dataResponse.data !=null ) {
      yield GetNotificationListSuccess(
          prevPageUrl: dataResponse.previousUrl??"",
          nextPageUrl: dataResponse.nextPageUrl ?? "",
          notificationList:  dataResponse.data);  }

    else {
      yield GetNotificationListFailed("failed");
    }
  }

  //notification
  Stream<TaskState> getNotificationDue(int id) async* {

    yield NotificationDueLoading();

    final dataResponse = await _taskDataSource.getNotificationDue(id);

    if (dataResponse=="success") {
      yield NotificationDueSuccess();
    } else {
      yield NotificationDueFailed("");
    }
  }

  //pendinglist
  Stream<TaskState> getPendingTaskListState() async* {
    yield GetPendingTaskListLoading();

    final dataResponse = await _taskRepo.getPendingTaskList();

    if (dataResponse.data.isNotEmpty) {
      yield GetPendingTaskListSuccess(dataResponse.data??[]);
    } else {
      yield GetPendingTaskListFailed();
    }
  }
  //pinnedtask
  Stream<TaskState> getPinnedTaskListState() async* {
    yield GetPinnedTaskListLoading();

    final dataResponse = await _taskRepo.getPinnedTaskList();

    if (dataResponse.data.isNotEmpty) {
      yield GetPinnedTaskListSuccess(dataResponse.data);
    } else {
      yield GetPinnedTaskListFailed();
    }
  }

  //topic
  Stream<TaskState> getTopicListState() async* {
    yield GetTopicListLoading();

    final dataResponse = await _taskRepo.getTopicList();

    if (dataResponse.data.isNotEmpty) {
      yield GetTopicListSuccess(dataResponse.data);
    } else {
      yield GetTopicListFailed();
    }
  }

  //taskRead

  Stream<TaskState> getTaskRead(int id) async* {

    yield GetTaskReadLoading();

    final dataResponse = await _taskRepo.getTaskReadData(id);

    if (dataResponse.hasData) {
      yield GetTaskReadSuccess(getTaskRead: dataResponse.data);
    } else {
      yield GetTaskReadFailed(dataResponse.error.toString(),
      );
    }
  }
//
Stream<TaskState> getTaskCreationRead() async* {

    yield GetTaskReadCreateLoading();

    final dataResponse = await _taskRepo.getTaskCreationRead();

    if (dataResponse.hasData) {
      yield GetTaskReadCreateSuccess(createRead: dataResponse.data);
    } else {
      yield GetTaskReadCreateFailed(dataResponse.error.toString(),
      );
    }
  }
  ///
  Stream<TaskState> getJobCreationRead() async* {

    yield GetJobReadCreateLoading();

    final dataResponse = await _taskRepo.getJobCreationRead();

    if (dataResponse.hasData) {
      yield GetJobReadCreateSuccess(createRead: dataResponse.data);
    } else {
      yield GetJobReadCreateFailed(dataResponse.error.toString(),
      );
    }
  }

  //readRewards
  Stream<TaskState> getReadRewards(int id,bool isTask) async* {

    yield GetReadRewadsLoading();

    final dataResponse = await _taskRepo.getReadRewards(id,isTask);

    if (dataResponse.hasData) {
      yield GetReadRewadsSuccess(readRewards: dataResponse.data);
    } else {
      yield GetReadRewadsFailed(dataResponse.error.toString(),
      );
    }
  }

  //readPerformance
  Stream<TaskState> getPerformanceRead(int id) async* {

    yield GetReadPerformanceLoading();

    final dataResponse = await _taskRepo.getPerformanceRead(id);

    if (dataResponse.hasData) {
      yield GetReadPerformanceSuccess(performanceList: dataResponse.data);
    } else {
      yield GetReadPerformanceFailed(dataResponse.error.toString(),
      );
    }
  }

  //totalPerfomane
  Stream<TaskState> getTotalPerformance(String? employeeCode,int? id) async* {

    yield GetTotalPerformanceLoading();

    final dataResponse = await _taskRepo.getTotalPerformance(employeeCode,id);

    if (dataResponse.hasData) {
      yield GetTotalPerformanceSuccess(totalMark: dataResponse.data);
    } else {
      yield GetTotalPerformanceFailed(dataResponse.error.toString(),
      );
    }
  }

  //assigntaskcount
  Stream<TaskState> getAssignCount(int id) async* {

    yield GetAssignCountLoading();

    final dataResponse = await _taskRepo.getAssignCount(id);

    if (dataResponse.hasData) {
      yield GetAssignCountSuccess(getCountTask: dataResponse.data);
    } else {
      yield GetAssignCountFailed(dataResponse.error.toString());
    }
  }
  //createJob
  Stream<TaskState> createTaskstate(
      {
        required int? parant,
        required int jobId,
        required int taskType,
        final int? statusStagesId,
        required String reportingPerson,
        required String createdBy,
        required String taskName,
        required String discription,
        required int priorityLeval,
        required String startDate,
        required String endDate,
        required String startTime,
        required String endTime,
        required bool isActive,
        required String AssigningType,
        required String AssigningCode,
        required String notas,
        required String remarks,
        required String priority,
        required String createdOn,
        required String? lastmodified,
        required String? longitude,
        required String? latitude,
        required String durationOption,
      }) async* {
    yield CreateTaskLoading();

    final dataResponse = await _taskRepo.taskCreatePost(
      latitude: latitude,
      startTime: startTime,
      endTime: endTime,
      durationOption: durationOption,
      longitude: longitude,
      statusStagesId:statusStagesId,
        startDate: startDate,
        endDate: endDate,
        createdBy: createdBy,
        discription: discription,
        isActive: isActive,
        priority: priority,
        reportingPerson: reportingPerson,
      taskType: taskType,
      taskName: taskName,
      remarks: remarks,
      priorityLeval: priorityLeval,
      parant: parant,
      notas: notas,
      lastmodified: lastmodified,
      jobId: jobId,
      createdOn: createdOn,
      AssigningType: AssigningType,
      AssigningCode: AssigningCode,


    );

    if (dataResponse.data==true) {
      print("sucsess ");
      yield CreateTaskSuccess(dataResponse.error??"");
    } else {
      print("failed ${dataResponse.error}");
      yield CreateTaskFailed(
        dataResponse.error ?? "",);
    }
  }
  //report create
  Stream<TaskState> createReport(
      {
        required int? taskId,
        required String? userId,
        required int? toipicId,
        required String? notes
      }) async* {
    yield CreateReportLoading();

    final dataResponse = await _taskRepo.createReport(
userId: userId,
      toipicId: toipicId,
      taskId: taskId,
      notes: notes

    );

    if (dataResponse.data==true) {
      print("sucsess ");
      yield CreateReportSuccess(dataResponse.error??"");
    } else {
      print("failed ${dataResponse.error}");
      yield CreateReportFailed(
        dataResponse.error ?? "",);
    }
  }
  //updateTask
  Stream<TaskState> updateTaskstate(
      {
        required dynamic img1,
        required dynamic img2,
        required dynamic img3,
        required dynamic img4,
        required dynamic img5,
        required String? attachdescription,
        required String? attachNote,
        required int? parant,
        required int taskType,
        required int id,
        final int? statusStagesId,
        required String reportingPerson,
        required String createdBy,
        required String taskName,
        required String discription,
        required int priorityLeval,
        required String startDate,
        required String endDate,
        required bool isActive,
        required String AssigningType,
        required String AssigningCode,
        required String notas,
        required String remarks,
        required String priority,
        required String createdOn,
        required String? lastmodified,
        required int? jobid,
        required String? longitude,
        required String? latitude,
        required String durationOption,
        required String startTime,
        required String endTime,
      }) async* {
    yield UpdateTaskLoading();

    final dataResponse = await _taskRepo.taskUpdatePost(
      longitude: longitude,
      durationOption: durationOption,
      endTime: endTime,
      startTime: startTime,
      latitude: latitude,
      img4: img4,
      img3: img3,
      img2: img2,
      img1: img1,
      img5: img5,
      attachdescription: attachdescription,
      attachNote: attachNote,
      statusStagesId:statusStagesId,
      startDate: startDate,
      endDate: endDate,
      createdBy: createdBy,
      discription: discription,
      isActive: isActive,
      priority: priority,
      reportingPerson: reportingPerson,
      taskType: taskType,
      taskName: taskName,
      remarks: remarks,
      id: id,
      priorityLeval: priorityLeval,
      parant: parant,
      notas: notas,
      lastmodified: lastmodified,
      jobid: jobid,
      createdOn: createdOn,
      AssigningType: AssigningType,
      AssigningCode: AssigningCode,

    );

    if (dataResponse.data==true) {
      print("task succcess atv repo");
      yield UpdateTaskSuccess(dataResponse.error??"",);
    } else {
      yield UpdateTaskFailed(
        dataResponse.error ?? "",);
    }
  }
  Stream<TaskState> updateReportingTaskstate(
      {
        required dynamic img1,
        required dynamic img2,
        required dynamic img3,
        required dynamic img4,
        required dynamic img5,
        required String? attachdescription,
        required String? attachNote,
        required int? parant,
        required int taskType,
        required int id,
        final int? statusStagesId,
        required String reportingPerson,
        required String createdBy,
        required String taskName,
        required String discription,
        required int priorityLeval,
        required String startDate,
        required String endDate,
        required bool isActive,
        required String AssigningType,
        required String AssigningCode,
        required String notas,
        required String remarks,
        required String priority,
        required String createdOn,
        required String? lastmodified,
        required int? jobid,
        required String? longitude,
        required String? latitude,
        required String durationOption,
        required String startTime,
        required String endTime,
      }) async* {
    yield UpdateReportingTaskLoading();

    final dataResponse = await _taskRepo.taskUpdatePost(
      longitude: longitude,
      durationOption: durationOption,
      endTime: endTime,
      startTime: startTime,
      latitude: latitude,
      img4: img4,
      img3: img3,
      img2: img2,
      img1: img1,
      img5: img5,
      attachdescription: attachdescription,
      attachNote: attachNote,
      statusStagesId:statusStagesId,
      startDate: startDate,
      endDate: endDate,
      createdBy: createdBy,
      discription: discription,
      isActive: isActive,
      priority: priority,
      reportingPerson: reportingPerson,
      taskType: taskType,
      taskName: taskName,
      remarks: remarks,
      id: id,
      priorityLeval: priorityLeval,
      parant: parant,
      notas: notas,
      lastmodified: lastmodified,
      jobid: jobid,
      createdOn: createdOn,
      AssigningType: AssigningType,
      AssigningCode: AssigningCode,

    );

    if (dataResponse.data==true) {
      print("task succcess atv repo");
      yield UpdateReportingSuccess(dataResponse.error??"",);
    } else {
      yield UpdateReportingFailed(
        dataResponse.error ?? "",);
    }
  }
  //deleteTask
  Stream<TaskState> deleteTask({required int jobId}) async* {
    yield DeleteTaskLoading();
    final dataResponse = await _taskDataSource.deleteTask(jobId);
    if (dataResponse == "success") {
      yield DeleteTaskSuccess();
    } else {
      yield DeleteTaskFailed();
    }
  }
  //deletereview
  Stream<TaskState> deleteReview({required int reviewId}) async* {
    yield DeleteReviewLoading();
    final dataResponse = await _taskDataSource.deleteReview(reviewId);
    print("ddddd$dataResponse");
    if (dataResponse == "success") {
      print("delete inside$dataResponse");
      yield DeleteReviewSuccess(dataResponse);
    } else {
      yield DeleteReviewFailed();
    }
  }
  //subtasklist
  Stream<TaskState> getSubTaskListState(int? taskId) async* {
    yield GetSubTaskListLoading();

    final dataResponse = await _taskRepo.getSubTaskList(taskId);

    if (dataResponse.data.isNotEmpty) {
      print("sub tast is a success");
      yield GetSubTaskListSuccess(dataResponse.data);
    } else {
      yield GetSubTaskListFailed();
    }
  }
  //performanceList
  Stream<TaskState> getPerformanceList(int taskid,String? code) async* {
    yield GetPerformanceListLoading();

    final dataResponse = await _taskRepo.getPerformanceList(taskid,code);

    if (dataResponse.data.isNotEmpty) {
      print("sub tast is a success");
      yield GetPerformanceListSuccess(dataResponse.data);
    } else {
      yield GetPerformanceListFailed();
    }
  }
  //reviewlist
  Stream<TaskState> getReviewListState(int? taskId) async* {
    yield GetReviewListLoading();

    final dataResponse = await _taskRepo.getReviewList(taskId);

    if (dataResponse.data.isNotEmpty) {
      print("review list a success");
      yield GetReviewListSuccess(dataResponse.data);
    } else {
      yield const GetReviewListFailed([]);
    }
  }

  //paymentCreate
  Stream<TaskState> createPaymentstate(
      {
        required int? jobId,
        required int? taskId,
        required String assigningType,
        required double budget,
        required String AssigningCode,
        required String notas,
        required String discription,
        required double expense,
        required int img1,
        required int img2,
        required int img3,
        required int img4,
        required int img5,
      }) async* {
    yield CreatePaymentLoading();

    final dataResponse = await _taskRepo.paymentCreatePost(
      discription: discription,
      jobId: jobId,
      notas: notas,
      taskId: taskId,
      assigningType: assigningType,
      AssigningCode: AssigningCode,
      budget: budget,
      expense: expense,
      img5: img5,
      img4: img4,
      img3: img3,
      img2: img2,
      img1: img1

    );

    if (dataResponse.data) {
      print("task succcess atv repo");
      yield CreatePaymentSuccess(dataResponse.error??"",);
    } else {
      yield CreatePaymentFailed(
        dataResponse.error ?? "");
    }
  }
  //readPayment
  Stream<TaskState> getPaymentRead(int id,bool isTask) async* {

    yield GetPaymentReadLoading();

    final dataResponse = await _taskRepo.getPaymentRead(id,isTask);

    if (dataResponse.hasData) {
      yield GetPaymentReadSuccess(paymentRead: dataResponse.data);
    } else {
      yield GetPaymentReadFailed(dataResponse.error.toString(),
      );
    }
  }

  //updatePayment
  Stream<TaskState> updatePaymentstate(
      {
        required int? payId,
        required int? jobId,
        required int? taskId,
        required String assigningType,
        required double budget,
        required String AssigningCode,
        required String notas,
        required String discription,
        required double expense,
        required bool isActive,
        required dynamic img1,
        required dynamic img2,
        required dynamic img3,
        required dynamic img4,
        required dynamic img5,
      }) async* {
    yield UpdatePaymentLoading();

    final dataResponse = await _taskRepo.paymentUpdatePost(
        discription: discription,
        jobId: jobId,
        notas: notas,
        taskId: taskId,
        assigningType: assigningType,
        AssigningCode: AssigningCode,
        budget: budget,
        expense: expense,
      isActive: isActive,
      payId: payId,
      img1: img1,
      img5: img5,
      img4: img4,
      img3: img3,
      img2: img2

    );

    if (dataResponse.data) {
      print("task succcess atv repo");
      yield UpdatePaymentSuccess(dataResponse.error??"",);
    } else {
      yield UpdatePaymentFailed(
          dataResponse.error ?? "");
    }
  }
  //createReview
  Stream<TaskState> createReviewTask(
      {
        required int? parant,
        required int taskId,
        required int image,
        required String reviewedBy,
        required String review,
        required String notes,

      }) async* {
    yield CreateReviewLoading();

    final dataResponse = await _taskRepo.createReviewTask(
      image:image,
      parant: parant,
      taskId: taskId,
      notes: notes,
      review: review,
      reviewedBy: reviewedBy,
    );

    if (dataResponse.data) {
      print("task succcess atv repo");
      yield CreateReviewSuccess(dataResponse.error??"",);
    } else {
      yield CreateReviewFailed(
        dataResponse.error ?? "",);
    }
  }
  //updateReview
  Stream<TaskState> updateReviewTask(
      {
        required int? parant,
        required int? id,
        required bool? isActive,
        required String reviewdBy,
        required dynamic image,
        required String review,
        required String notas,
        required int taskId,

      }) async* {
    yield UpdateReviewLoading();

    final dataResponse = await _taskRepo.updateReviewTask(
      image:image,
      parant: parant,
      review: review,
      reviewdBy: reviewdBy,
      id: id,
      taskId: taskId,
      isActive: isActive,
      notas: notas
    );

    if (dataResponse.data) {
      print("task succcess atv repo");
      yield UpdateReviewSuccess(dataResponse.error??"",);
    } else {
      yield UpdateReviewFailed(
        dataResponse.error ?? "",);
    }
  }
  //createPerfomance
  Stream<TaskState> createPerformanceAppraisalTask(
      {
        required String? userId,
        required int taskId,
        required int pointId,
        required String name,
        required String discription,

      }) async* {
    yield CreatePerformanceLoading();

    final dataResponse = await _taskRepo.createPerformanceAppraisalTask(
      name:name,
      discription: discription,
      taskId: taskId,
      userId: userId,
      pointId: pointId,

    );

    if (dataResponse.data) {
      print("task succcess atv repo");
      yield CreatePerformanceSuccess(dataResponse.error??"",);
    } else {
      yield CreatePerformanceFailed(
        dataResponse.error ?? "",);
    }
  }
  //createRewads
  Stream<TaskState> createReward(
      {

        required int img1,
        required int img2,
        required int img3,
        required int img4,
        required int img5,
        required String discription,
        required String name,
        required String notes,
        required String type,
        required int typeId,

      }) async* {
    yield CreateRewardLoading();

    final dataResponse = await _taskRepo.createReward(
      img1: img1,
      img2: img2,
      img3: img3,
      img4: img4,
      img5: img5,
      typeId: typeId,
      type: type,
      discription: discription,
      name: name,
      notes: notes,
    );

    if (dataResponse!=null) {
      print("sucsess ");
      yield CreateRewardSuccess(dataResponse.error??"");
    } else {
      print("failed ");
      yield CreateRewardFailed(
        dataResponse.error ?? "",);
    }
  }

  //updateRewards
  Stream<TaskState> updateRewards(
      {

        required dynamic img1,
        required dynamic img2,
        required dynamic img3,
        required dynamic img4,
        required dynamic img5,
        required String discription,
        required String name,
        required String notes,
        required String type,
        required int typeId,
        required int id,
        required bool isActive,

      }) async* {
    yield UpdateRewardLoading();

    final dataResponse = await _taskRepo.updateRewards(
      img4: img4,
      img3: img3,
      img2: img2,
      img1: img1,
      img5: img5,
      typeId: typeId,
      type: type,
      discription: discription,
      name: name,
      notes: notes,
      id: id,
      isActive: isActive
    );

    if (dataResponse!=null) {
      print("sucsess ");
      yield UpdateRewardSuccess(dataResponse.error??"");
    } else {
      print("failed ");
      yield UpdateRewardFailed(
        dataResponse.error ?? "",);
    }
  }

  //pointListing
  Stream<TaskState> getPointsList() async* {
    yield GetPointListLoading();

    final dataResponse = await _taskRepo.getPointsList();

    if (dataResponse.data.isNotEmpty) {
      print("sub tast is a success");
      yield GetPointListSuccess(dataResponse.data);
    } else {
      yield GetPointListFailed();
    }
  }

  //perfom
  Stream<TaskState> TaskAssignedGroupListState(String code,String? prev) async* {
    tasklist=[];
    yield GetTaskAssignedGroupListLoading();

    final dataResponse = await _taskRepo.TaskAssignedGroupListState(code, prev);

    dataResponse.fold((l) => emit(GetTaskAssignedGroupListFailed()), (r) {
      next = r.nextPage;

      r.data?.forEach((element) {
        tasklist.add((element));
      });

      emit(GetTaskAssignedGroupListSuccess(
          offerPeriod: PaginatedResponse(tasklist, r.nextPage, r.previousUrl)));
    });
  }

  //
  Stream<TaskState> getCriteriaRead(String taskCode) async* {

    yield GetCriteriaReadLoading();

    final dataResponse = await _taskRepo.getCriteriaRead(taskCode);

    if (dataResponse.hasData) {
      yield GetCriteriaReadSuccess(criteriaRead: dataResponse.data);
    } else {
      yield GetCriteriaReadFailed(dataResponse.error.toString(),
      );
    }
  }

  //noti
  Stream<TaskState> NotificationIcon() async* {

    yield NotificationIconLoading();

    final dataResponse = await _taskDataSource.NotificationIcon();

    if (dataResponse=="success") {
      yield NotificationIconSuccess();
    } else {
      yield NotificationIconFailed("");
    }
  }


  //report list admin
  Stream<TaskState> ReportListAdminList({

    String? next,String? prev,
  }) async* {
    yield ReportListAdminListLoading();
    final dataResponse = await _taskRepo.ReportListAdminList(next,prev);
    if (dataResponse.data !=null &&dataResponse.data.isNotEmpty) {
      yield ReportListAdminListSuccess(
          prevPageUrl: dataResponse.previousUrl??"",
          nextPageUrl: dataResponse.nextPageUrl ?? "",
          orders:  dataResponse.data);  }

    else {
      yield ReportListAdminListFailed("failed");
    }
  }

  //report list user
  Stream<TaskState> ReportListUserList({

    String? next,String? prev,

  }) async* {
    yield ReportListUserListLoading();
    final dataResponse = await _taskRepo.ReportListUserList(next,prev);
    if (dataResponse.data !=null &&dataResponse.data.isNotEmpty) {
      yield ReportListUserListSuccess(
          prevPageUrl: dataResponse.previousUrl??"",
          nextPageUrl: dataResponse.nextPageUrl ?? "",
          orders:  dataResponse.data);  }

    else {
      yield ReportListUserListFailed("failed");
    }
  }
  //
  Stream<TaskState> replayReport(
      {
        required int? id,
        required String? reportStatus,
        required String? replay,
        required String? replayType,
        required String? reAssignCode,
      }) async* {
    yield ReplayReportLoading();

    final dataResponse = await _taskRepo.replayReport(
      reAssignCode: reAssignCode,
       replayType: replayType,
       reportStatus: reportStatus,
      replay: replay,
      id: id
    );

    if (dataResponse.data==true) {
      print("sucsess ");
      yield ReplayReportSuccess(dataResponse.error??"");
    } else {
      print("failed ${dataResponse.error}");
      yield ReplayReportFailed(
        dataResponse.error ?? "",);
    }
  }

  Stream<TaskState> searchMapLocation(
      {required String searchQuery}) async* {
    yield SearchMapResultsLoading();
    final dataResponse =
    await _taskDataSource.searchMapLocation(searchQuery);
    if (dataResponse.isNotEmpty) {
      yield SearchMapResultsSuccess(cartData: dataResponse);
    } else {
      yield SearchMapResultsFailed();
    }
  }

}
