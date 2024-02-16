import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void _launchURL(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

class CreditsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          _buildListTile('Made by', '@IgrecL', 'https://github.com/IgrecL/'),
          _buildListTile('Powered by', 'Flutter', 'https://flutter.dev/'),
          _buildListTile('App Version', '1.0.0', 'https://github.com/IgrecL/lets-goi'),
          _buildListTile('Frequency List', 'BCCWJ LUW', 'https://clrd.ninjal.ac.jp/bccwj/en/freq-list.html'),
          _buildListTile('English Definitions', 'JMdict', 'https://www.edrdg.org/wiki/index.php/JMdict-EDICT_Dictionary_Project'),
          _buildListTile('JMdict in Flutter', 'nsNeruno/jm_dict', 'https://github.com/nsNeruno/jm_dict'),
        ],
      ),
    );
  }

  ListTile _buildListTile(String title, String subtitle, String url) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 24), // Adjust the font size here
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.white60, fontSize: 20), // Adjust the font size here
      ),
      onTap: url != '' ? () => _launchURL(url) : null,
    );
  }
}