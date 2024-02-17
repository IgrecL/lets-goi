import 'package:flutter/material.dart';
import 'package:letsgoi/screens/definitions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.level});
  final int level;

  @override
  State<GameScreen> createState() => _GameScreen();
}

class _GameScreen extends State<GameScreen> {
  Future<String> readFile() async {
    try {
      String levelString = widget.level.toString().padLeft(3, '0');
      File file = File('assets/levels/level$levelString.tsv');
      return await file.readAsString();
    } catch (e) {
      return 'Error: $e';
    }
  }

  bool _finished = false;
  List<bool> _correctList = List.generate(100, (index) => false);
  List<String> _textFieldValues = List.generate(100, (index) => '');

  Future<String> title() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final completed = prefs.getInt('completed${(widget.level - 1) ~/ 50}') ?? 0;
 
    if (!_finished) {
      return 'Level ${widget.level} + ${(widget.level - 1) ~/ 50} + $completed';
    }

    int count = 0;
    for (String field in _textFieldValues) {
      if (field != '') {
        count++;
      }
    }

    return 'Level ${widget.level} – $count/100';
  }

  Future<bool> completedIcon() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final completed = prefs.getInt('completed${(widget.level - 1) ~/ 50}') ?? 0;
    return completed & (1 << (widget.level - 1) % 50) != 0 ? true : false;
  }

  @override
  Widget build(BuildContext contexrt) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: title(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!, style: TextStyle(color: Colors.white));
            } else {
              return Text('Loading...', style: TextStyle(color: Colors.white));
            }
          },
        ),
        backgroundColor: Color.fromARGB(255, 20, 20, 20),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: FutureBuilder<bool>(
              future: completedIcon(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Icon(snapshot.data! ? Icons.indeterminate_check_box : Icons.check_box_outline_blank);
                } else {
                  return Icon(Icons.refresh);
                }
              },
            ),
            onPressed: () async {
              // The completed levels are stored in shared integers (each bit represents a level)
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              final completed = prefs.getInt('completed${(widget.level - 1) ~/ 50}') ?? 0;
              int newCompleted = completed ^ (1 << (widget.level - 1) % 50);
              await prefs.setInt('completed${(widget.level - 1) ~/ 50}', newCompleted);
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: readFile(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String contents = snapshot.data!;
            List<List<String>> lines = contents
                .split('\n')
                .map((line) => line.split('\t'))
                .toList();

            return Scaffold(
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  Visibility(
                    visible: _finished,
                    child: FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          _finished = false;
                          _correctList = List.generate(100, (index) => false);
                          _textFieldValues = List.generate(100, (index) => '');
                        });
                      },
                      backgroundColor: Colors.white,
                      child: Icon(Icons.refresh),
                    ),
                  ),
                  SizedBox(width: 10),
                  Visibility(
                    visible: _finished,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        List<int> wrongIds = [];
                        for (int i = 0; i < 100; i++) {
                          if (!_correctList[i]) wrongIds.add(i);
                        }
                        
                        if (wrongIds.isEmpty) {
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Definitions(level: widget.level, wrongIds: wrongIds),
                          ),
                        );
                      },
                      icon: Icon(Icons.question_mark),
                        label: Text('Words', style: TextStyle(fontWeight: FontWeight.bold)),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Visibility(
                    visible: !_finished,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        setState(() {
                          _finished = true;

                          // Check if the answers are correct
                          for (int i = 0; i < 100; i++) {
                            if (_textFieldValues[i].toLowerCase() == lines[i][2].toLowerCase()) {
                              _correctList[i] = true;
                            }
                          }
                          
                        });
                      },
                      backgroundColor: Colors.white,
                      icon: Icon(Icons.check),
                      label: Text('Finish', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              body: Center(
                child: Container(
                  color: Colors.black,
                  child: Column(
                    children: [
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 4,
                          children: List.generate(
                            100,
                            // cut ici je pense
                            (index) => Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 20, 20, 20),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: !_finished ? Colors.blue : _correctList[index] ? Colors.green : Colors.red,
                                  width: 3,
                                ),
                              ),
                              child: Scaffold(
                                backgroundColor: !_finished ? Colors.blue[700] : _correctList[index] ? Colors.green[700] : Colors.red[700],
                                body: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${lines[index][1]} (${lines[index][0]})",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: MediaQuery.of(context).size.width / 50,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      lines[index][4],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: MediaQuery.of(context).size.width / 30,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          labelStyle: TextStyle(color: Colors.white),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black),
                                          ),
                                          isDense: true,
                                          filled: true,
                                          fillColor: Colors.black,
                                        ),
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                        onChanged: (value) {
                                          _textFieldValues[index] = value;
                                        },
                                        controller: TextEditingController(text: _textFieldValues[index]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}