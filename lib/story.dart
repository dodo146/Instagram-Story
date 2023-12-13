// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
//Şimdilik ValueListenableBuilder var story state'i kontrol etmek için
//Ekrana basınca index arttırılır ve index değişince builder tekrar build eder çünkü dinlediği değer değişir.
//En son ama bloc kullan bütün stateler için.

class StoryPage extends StatelessWidget {
  StoryPage({super.key, required this.stories});
  final List<String> stories;
  final ValueNotifier<int> index = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Story",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ValueListenableBuilder(
                valueListenable: index,
                builder: (context, value, child) {
                  return GestureDetector(
                    child: Image.asset(
                      stories[index.value],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    onTap: () {
                      if (value < stories.length - 1) {
                        index.value++;
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  );
                },
                // child: GestureDetector(
                //   child: Image.asset(
                //     stories[index.value],
                //     fit: BoxFit.cover,
                //     width: double.infinity,
                //     height: double.infinity,
                //   ),
                //   onTap: () {
                //     //block state lazım hangi storyde olduğunu bilmek için
                //     if (index.value < stories.length - 1) {
                //       index.value++;
                //     } else {
                //       //storyler bitti
                //       Navigator.pop(context);
                //     }
                //   },
                // ),
              ),
            ],
          ),
        ));
  }
}
