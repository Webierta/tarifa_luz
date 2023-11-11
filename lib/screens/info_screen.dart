import 'package:flutter/material.dart';

import 'package:tarifa_luz/utils/read_file.dart';
import 'package:tarifa_luz/widgets/head_screen.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Info')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Image.asset('assets/images/ic_launcher.png'),
                const HeadScreen(),
                //const Icon(Icons.info_outline, size: 60),
                const Divider(),
                const SizedBox(height: 10.0),
                const ReadFile(archivo: 'assets/files/info.txt'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}