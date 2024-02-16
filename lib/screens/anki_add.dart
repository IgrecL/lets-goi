import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

void _launchURL(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}


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
        title: Text('Level $level', style: TextStyle(color: Colors.white)),
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
              body: ListView.builder(
                itemCount: wrong.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${wrong[index][4]} (${wrong[index][3]})',
                          style: TextStyle(fontSize: MediaQuery.of(context).size.width / 20, color: Colors.white)),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            _launchURL('https://jisho.org/search/${wrong[index][4]}');
                          },
                          color: Colors.white,
                        ),
                      ],
                    ),
                    subtitle: Text(
                      '- ${wrong[index][5].replaceAll(' | ', '\n- ')}',
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width / 35, color: Colors.grey)
                    ),
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