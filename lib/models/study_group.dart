import 'package:flutter/material.dart';

class StoryGroup {
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
    stories.add(StoryGroup(stories: [
      "/assets/images/grandma.jpg",
      "/assets/images/dog_image.jpeg"
    ], icon: Icon(Icons.boy), name: "Doğukan"));

    stories.add(StoryGroup(stories: [
      "/assets/images/grandma.jpg",
      "/assets/images/dog_image.jpeg"
    ], icon: Icon(Icons.girl), name: "Ozan"));
    return stories;
  }
}
