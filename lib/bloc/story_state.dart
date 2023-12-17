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
  final bool isStopped;

  StoryShown(
      {required this.storyIndex,
      required this.progress,
      required this.isStopped});

  @override
  List<Object> get props => [storyIndex, progress, isStopped];
}
