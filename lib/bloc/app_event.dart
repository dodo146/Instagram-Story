part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class NextStoryGroup extends AppEvent {}

class PreviousStoryGroup extends AppEvent {}

class StoryGroupPressed extends AppEvent {
  final int group_index;
  StoryGroupPressed(this.group_index);

  @override
  List<Object> get props => [group_index];
}

class SetTransitionToFalse extends AppEvent {
  final bool value;
  SetTransitionToFalse({required this.value});

  @override
  List<Object> get props => [value];
}
