// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:instagram_story/models/study_group.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  List<StoryGroup> stories = [];

  void _getStories() {
    stories = StoryGroup.getStories();
  }

  @override
  Widget build(BuildContext context) {
    _getStories();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Instagram",
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 120,
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  width: 15,
                ),
                itemCount: stories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    child: Column(
                      children: [
                        IconButton(
                            onPressed: () => {}, icon: stories[index].icon)
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
