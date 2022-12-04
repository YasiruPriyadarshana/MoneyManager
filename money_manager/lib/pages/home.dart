import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  Widget buildCalander = const SizedBox();
  bool showCalander = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Manager'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                showCalander
                    ? buildCalander = const SizedBox()
                    : buildCalander = const Text('this is it');
              });

              showCalander = !showCalander;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Wed, Nov 2022', style: TextStyle(letterSpacing: 5.0)),
                SizedBox(
                  width: 10.0,
                ),
                Icon(Icons.arrow_downward_rounded)
              ],
            ),
          ),
          const Center(
            child: Text('sadasd'),
          ),
          buildCalander
        ],
      ),
    );
  }
}
