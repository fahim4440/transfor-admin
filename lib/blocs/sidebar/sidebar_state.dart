part of 'sidebar_bloc.dart';

sealed class SidebarState extends Equatable {
  const SidebarState();
}

final class SidebarInitial extends SidebarState {
  @override
  List<Object> get props => [];
}

final class SidebarLoaded extends SidebarState {
  final AdminProfile admin;
  const SidebarLoaded({required this.admin});
  
  @override
  List<Object?> get props => [admin];
}
