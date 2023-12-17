part of 'story_bloc.dart';

sealed class StoryEvent extends Equatable {
  const StoryEvent();

  @override
  List<Object> get props => [];
}

class NextStory extends StoryEvent {}

class PreviousStory extends StoryEvent {}

class LoadStory extends StoryEvent {}

class SetStoryIndex extends StoryEvent {
  final int story_index;
  SetStoryIndex({required this.story_index});

  @override
  List<Object> get props => [story_index];
}

class Progress extends StoryEvent {
  final double newProgress;
  Progress({required this.newProgress});

  @override
  List<Object> get props => [newProgress];
}

class SetStopped extends StoryEvent {
  final bool stopped;
  SetStopped({required this.stopped});

  @override
  List<Object> get props => [stopped];
}
