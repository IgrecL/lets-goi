import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

Future<Color> textColor(int id) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final completed = prefs.getInt('achievements') ?? 0;
  return (completed & (1 << id) != 0) ? Colors.white : Colors.white24;
}

int bit(int number) {
  return pow(2, number).toInt()-1;
}

void achievementUpdate() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final completed = [prefs.getInt('completed0') ?? 0, prefs.getInt('completed1') ?? 0, prefs.getInt('completed2') ?? 0, prefs.getInt('completed3') ?? 0, prefs.getInt('completed4') ?? 0, prefs.getInt('completed5') ?? 0, prefs.getInt('completed6') ?? 0, prefs.getInt('completed7') ?? 0, prefs.getInt('completed8') ?? 0, prefs.getInt('completed9') ?? 0, prefs.getInt('completed10') ?? 0];
  int newAchievements = 0;

  // JLPT levels
  if ((completed[0] & bit(5)) == bit(5)) newAchievements = 1; // First 5 levels
  if ((completed[0] & bit(10)) == bit(10)) newAchievements = 3; // First 10 levels
  if ((completed[0] & bit(25)) == bit(25)) newAchievements = 7; // First 25 levels
  if (completed[0] == bit(50)) newAchievements = 15; // First 50 levels
  if ((newAchievements == bit(50)) && ((completed[1] & bit(35)) == bit(35))) newAchievements = 31; // First 85 levels

  // Master levels
  if ((completed[0] == bit(50)) && (completed[1] == bit(50))) newAchievements += 32; // All 一 levels
  if ((completed[2] == bit(50)) && (completed[3] == bit(50))) newAchievements += 64; // All 二 levels
  if ((completed[4] == bit(50)) && (completed[5] == bit(50))) newAchievements += 128; // All 三 levels
  if ((completed[6] == bit(50)) && (completed[7] == bit(50))) newAchievements += 256; // All 四 levels
  if ((completed[8] == bit(50)) && (completed[9] == bit(50))) newAchievements += 512; // All 五 levels
  if (completed[10] == bit(50)) newAchievements += 1024; // All specific levels

  // All levels
  if (newAchievements == 2047) newAchievements += 2048;

  await prefs.setInt('achievements', newAchievements);
}

class AchievementsScreen extends StatelessWidget {

  final List<List<String>> achievements = [
    ['JLPT N5-ish vocab','Complete the 5 first levels (~600 most frequent)'],
    ['JLPT N4-ish vocab','Complete the 10 first levels (~1200 most frequent)'],
    ['JLPT N3-ish vocab','Complete the 25 first levels (~3000 most frequent)'],
    ['JLPT N2-ish vocab','Complete the 50 first levels (~6000 most frequent)'],
    ['JLPT N1-ish vocab','Complete the 85 first levels (~10000 most frequent)'],
    ['10K Master','Complete all of the 一 levels'],
    ['20K Master','Complete all of the 二 levels'],
    ['30K Master','Complete all of the 三 levels'],
    ['40K Master','Complete all of the 四 levels'],
    ['50K Master','Complete all of the 五 levels'],
    ['Specialist','Complete all specific words levels'],
    ['100%','Complete all levels (You have way too much time)'],
  ];

  @override
  Widget build(BuildContext context) {
    achievementUpdate();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          color: Colors.black,
          child: GridView.count(
            crossAxisCount: 1,
            childAspectRatio: 4.2,
            children: List.generate(
              achievements.length,
              (index) => FutureBuilder<Color>(
                future: textColor(index),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 20, 20, 20),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _textContainer('${index.toString()}/${achievements.length}', true, false, 50, true, context, snapshot.data),
                          _textContainer(achievements[index][0], false, false, 20, true, context, snapshot.data),
                          _textContainer(achievements[index][1], false, true, 30, false, context, snapshot.data),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _textContainer(String text, bool edgeTop, bool edgeBottom, int size, bool bold, BuildContext context, Color? color) {
    return Container(
      margin: edgeTop ? EdgeInsets.only(left: 10, right: 10, top: 10) : (edgeBottom ? EdgeInsets.only(left: 10, right: 10, bottom: 10) : EdgeInsets.only(left: 10, right: 10)),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: MediaQuery.of(context).size.width / size,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}