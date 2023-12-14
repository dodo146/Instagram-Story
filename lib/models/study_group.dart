// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class StoryGroup extends Equatable {
  List<String> stories;
  Icon icon;
  String name;

  StoryGroup({
    required this.stories,
    required this.icon,
    required this.name,
  });

  static List<StoryGroup> getStories() {
    List<StoryGroup> stories = [];
    stories.add(StoryGroup(
      stories: [
        "assets/images/grandma.jpg",
        "assets/images/dog_image.jpeg",
        "assets/videos/video.mp4"
      ],
      icon: Icon(
        Icons.boy,
        size: 35,
      ),
      name: "Doğukan",
    ));

    stories.add(StoryGroup(
      stories: [
        "assets/images/dog_image.jpeg",
        "assets/images/grandma.jpg",
        "assets/videos/video.mp4"
      ],
      icon: Icon(
        Icons.boy,
        size: 35,
      ),
      name: "Hasan",
    ));
    stories.add(StoryGroup(
      stories: [
        "assets/images/grandma.jpg",
        "assets/images/dog_image.jpeg",
        "assets/videos/pexels.mp4"
      ],
      icon: Icon(
        Icons.boy,
        size: 35,
      ),
      name: "Ozan",
    ));
    stories.add(StoryGroup(
      stories: [
        "assets/images/dog_image.jpeg",
        "assets/images/grandma.jpg",
        "assets/videos/pexels.mp4"
      ],
      icon: Icon(
        Icons.girl,
        size: 35,
      ),
      name: "İdil",
    ));
    return stories;
  }

  @override
  List<Object> get props => [stories, icon, name];
}
