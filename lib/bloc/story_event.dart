part of 'story_bloc.dart';

sealed class StoryEvent extends Equatable {
  const StoryEvent();

  @override
  List<Object> get props => [];
}

class NextStoryEvent extends StoryEvent {}

class PreviousStoryEvent extends StoryEvent {}

class NextStoryGroupEvent extends StoryEvent {}

class PreviousStoryGroupEvent extends StoryEvent {}

class StoryPressed extends StoryEvent {
  final int groupIndex;
  StoryPressed(this.groupIndex);
}
