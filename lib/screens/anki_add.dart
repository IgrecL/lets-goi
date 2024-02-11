import 'package:flutter/material.dart';
import 'dart:io';

class AnkiAdd extends StatelessWidget {
  final int level;
  final List<int> wrongIds;
  AnkiAdd({required this.level, required this.wrongIds});

  Future<String> readFile() async {
    try {
      String levelString = level.toString().padLeft(3, '0');
      File file = File('assets/levels/level$levelString.tsv');
      return await file.readAsString();
    } catch (e) {
      return 'Error: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('レベル$level', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 20, 20, 20),
        iconTheme: IconThemeData(color: Colors.white),
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

            List<List<String>> wrong = [];
            for (int index in wrongIds) {
              wrong.add(lines[index]);
            }

            return Scaffold(
              backgroundColor: Colors.black,
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  // Handle onPressed for the button
                },
                backgroundColor: Colors.white,
                label: Text('全部', style: TextStyle(fontWeight: FontWeight.bold)),
                icon: Icon(Icons.multiple_stop),
              ),
              body: ListView.builder(
                itemCount: wrong.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${wrong[index][4]} (${wrong[index][3]})', style: TextStyle(fontSize: 24, color: Colors.white)),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              // Handle onPressed
                            },
                            color: Colors.white, // Change the color to red
                          ),
                        ],
                    ),
                    subtitle: Text('- ${wrong[index][5].replaceAll(' | ', '\n- ')}', style: TextStyle(color: Colors.grey)),
                  );
                },
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