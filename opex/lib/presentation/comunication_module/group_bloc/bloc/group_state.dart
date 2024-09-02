part of 'group_bloc.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object> get props => [];
}

class GroupInitial extends GroupState {}

class GetAllRegisteredUsersLoading extends GroupState {}

class GetAllRegisteredUsersSuccess extends GroupState {
  final List<GetEmployeeList> registeresUsers;
  const GetAllRegisteredUsersSuccess({required this.registeresUsers});
}

class GetAllRegisteredUsersFailed extends GroupState {}



class CreateGroupLoading extends GroupState {}

class CreateGroupSuccess extends GroupState {
  GroupList list =GroupList();
  CreateGroupSuccess({required this.list});
}

class CreateGroupFailed extends GroupState {
  final String error;
  const CreateGroupFailed({required this.error});
}

class GetGroupProfileDetailsLoading extends GroupState {}

class GetGroupProfileDetailsSuccess extends GroupState {
  final ProfileGetModel profileGetModel;
  const GetGroupProfileDetailsSuccess({required this.profileGetModel});
}
class GetGroupProfileDetailsFailed extends GroupState {}

class GetGroupProfiledataDetailsLoading extends GroupState {}

class GetGroupProfiledataDetailsSuccess extends GroupState {
  final GroupProfileDataModel? profileGetModel;
  const GetGroupProfiledataDetailsSuccess({this.profileGetModel});
}

class GetGroupProfiledataDetailsFailed extends GroupState {}



class GroupLeaveLoading extends GroupState {}

class GroupLeaveSuccess extends GroupState {
  final String successMessage;
  const GroupLeaveSuccess({required this.successMessage});
}

class GroupLeaveFailed extends GroupState {
  final String error;
  const GroupLeaveFailed({required this.error});
}

class GroupMemberAddLoading extends GroupState{}
class GroupMemberAddSuccess extends GroupState{
  final String successmsg;
  const GroupMemberAddSuccess({ required this.successmsg});
}
class GroupMemberAddFailed extends GroupState{
  final String error;
  const GroupMemberAddFailed({required this.error});
}

class GroupMemberDeleteLoading extends GroupState{}
class GroupMemberDeleteSuccess extends GroupState{
  final String successmsg;
  const GroupMemberDeleteSuccess({ required this.successmsg});
}
class GroupMemberDeleteFailed extends GroupState{
  final String error;
  const GroupMemberDeleteFailed({required this.error});
}

class GroupProfileEditLoading extends GroupState{}
class GroupProfileEditSuccess extends GroupState{
  final String successmsg;
  const GroupProfileEditSuccess({ required this.successmsg});
}
class GroupProfileEditFailed extends GroupState{
  final String error;
  const GroupProfileEditFailed({required this.error});
}

class GroupUploadPictureInitial extends GroupState {}

class GroupUploadPictureLoading extends GroupState {}

class GroupUploadPictureSuccess extends GroupState {
  final String upload;
  const GroupUploadPictureSuccess({required this.upload});
}
class GroupUploadPictureFailed extends GroupState {
  final String error;
  const GroupUploadPictureFailed({required this.error});

}