import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:letsgoi/screens/game.dart';

String getLevelText(int index, int level) {
  return 'Level ${index + level + 1}\n${(index + level) * 100 + 1}-${(index + level + 1) * 100}';
}

Color getColorByIndex(int index) {
  switch (index ~/ 12) {
    case 0:
      return Colors.green;
    case 1:
      return Colors.teal;
    case 2:
      return Colors.blue;
    case 3:
      return const Color.fromARGB(255, 33, 54, 243);
    case 4:
      return Colors.purple;
    case 5:
      return const Color.fromARGB(255, 176, 39, 121);
    case 6:
      return Colors.red;
    case 7:
      return Color.fromARGB(255, 255, 114, 7);
    case 8:
      return Colors.amber;
    default:
      return Color.fromARGB(255, 233, 185, 11);
  }
}

Future<Color> completionColor(int level) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final completed = prefs.getInt('completed${(level - 1) ~/ 50}') ?? 0;
  return (completed & (1 << (level - 1) % 50) != 0) ? Colors.white24 : Colors.white;
}

class LevelsScreen extends StatefulWidget {
  final int level;
  LevelsScreen({required this.level});

  @override
  State<LevelsScreen> createState() => _LevelsScreen();
}

class _LevelsScreen extends State<LevelsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Level ${widget.level+1}-${widget.level+100}', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 20, 20, 20),
        iconTheme: IconThemeData(color: Colors.white), 
      ),
      body: Center(
        child: Container(
          color: Colors.black,
          child: GridView.count(
            crossAxisCount: 4,
            children: List.generate(
              100,
              (index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameScreen(level: index + widget.level + 1),
                    ),
                  ).then((_) {
                    setState(() {});
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 20, 20, 20),
                      borderRadius: BorderRadius.circular(15), 
                      border: Border.all(
                        color: getColorByIndex(index),
                        width: 3,
                      ),
                  ),
                  child: Center(
                    child: FutureBuilder<Color>(
                      future: completionColor(index + widget.level + 1),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            getLevelText(index, widget.level),
                            style: TextStyle(
                              color: snapshot.data!,
                              fontSize: MediaQuery.of(context).size.width / 35,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return Text(
                            getLevelText(index, widget.level),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}