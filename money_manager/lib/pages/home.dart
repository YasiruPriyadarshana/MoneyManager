import 'package:flutter/material.dart';
import 'package:money_manager/widgets/calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  void _onItemTapped(index) {
    setState(() {
      currentIndex = index;
      if (index == 1) {
        Navigator.pushNamed(context, '/stats');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Manager'),
        automaticallyImplyLeading: false,
      ),
      body: _buildHome(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

Widget _buildHome() {
  final titles = ["List 1", "List 2", "List 3"];
  final subtitles = [
    "Here is list 1 subtitle",
    "Here is list 2 subtitle",
    "Here is list 3 subtitle"
  ];
  return Column(
    children: [
      const Calendar(),
      const Text('Budget:4000\$'),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: const LinearProgressIndicator(
            value: 0.45,
            minHeight: 18,
          ),
        ),
      ),
      Expanded(
        child: ListView.builder(
            itemCount: titles.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [Text(titles[index]), const Text('\$500')],
                  ),
                  leading: const Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Icon(Icons.food_bank,
                        color: Colors.deepOrange, size: 36.0),
                  ),
                ),
              );
            }),
      ),
      Row(
        children: [
          ElevatedButton(onPressed: () {}, child: const Text('Income')),
          ElevatedButton(onPressed: () {}, child: const Text('Expence'))
        ],
      ),
      Row(
        children: const [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Category',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child:
                Icon(Icons.add_reaction, color: Colors.deepOrange, size: 36.0),
          ),
          // Icon(
          //   Icons.directions_bus,
          //   color: Colors.pink,
          //   size: 36.0
          // ),
        ],
      ),
      const SizedBox(height: 10.0),
      Row(
        children: [
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '\$500',
                ),
              ),
            ),
          ),
          ElevatedButton(onPressed: () {}, child: const Text('Save')),
        ],
      ),
    ],
  );
}
