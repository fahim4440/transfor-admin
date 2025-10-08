part of 'sidebar_bloc.dart';

sealed class SidebarEvent extends Equatable {
  const SidebarEvent();
}

class SidebarInitiate extends SidebarEvent {
  @override
  List<Object?> get props => [];
}
