part of 'story_bloc.dart';

sealed class StoryState extends Equatable {
  const StoryState();

  @override
  List<Object> get props => [];
}

final class StoryInitial extends StoryState {}

final class StoryShown extends StoryState {
  final int storyIndex;
  final double progress;

  StoryShown(this.storyIndex, this.progress);

  @override
  List<Object> get props => [storyIndex, progress];
}
