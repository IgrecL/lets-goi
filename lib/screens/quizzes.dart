import 'package:flutter/material.dart';
import 'package:letsgoi/screens/levels.dart';

class LevelObject {
  String kanji;
  String words;
  Color color;
  LevelObject({required this.kanji, required this.words, required this.color});
}

LevelObject getLevel(int index) {
  switch (index) {
    case 0:
      return LevelObject(kanji: '一', words: '一万語', color: Colors.green);
    case 1:
      return LevelObject(kanji: '二', words: '二万語', color: Colors.blue);
    case 2:
      return LevelObject(kanji: '三', words: '三万語', color: Colors.purple);
    case 3:
      return LevelObject(kanji: '四', words: '四万語', color: Colors.red);
    case 4:
      return LevelObject(kanji: '五', words: '五万語', color: Colors.amber);
    case 5:
      return LevelObject(kanji: '特', words: '特殊な語彙', color: Colors.grey);
        
    default:
      return LevelObject(kanji: 'X', words: 'error', color: Colors.green);

  }
}

class QuizzesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              ' LETS語彙 ',
              style: TextStyle(fontSize: 60, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'YourFontFamily'),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                for (int i = 0; i < 3; i++)
                  Row(
                    children: [
                      for (int j = 0; j < 2; j++)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LevelsScreen(level: (i*2+j)*100),
                                ),
                                // faut faire des trucs spéciaux pour toku
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: getLevel(i*2+j).color,
                                  width: 2,
                                ),
                                color: Color.fromARGB(255, 20, 20, 20),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      getLevel(i*2+j).kanji,
                                      style: TextStyle(
                                        fontSize: 110,
                                        color: Colors.white,
                                        fontFamily: 'YourFontFamily',
                                      ),
                                    ),
                                    Text(
                                      getLevel(i*2+j).words,
                                      style: TextStyle(
                                        fontSize: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}
