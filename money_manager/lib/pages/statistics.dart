import 'package:flutter/material.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StatsPageState();
  }
}

class _StatsPageState extends State<StatsPage> {
  int currentIndex = 1;
  void _onItemTapped(index) {
    currentIndex = index;
    setState(() {
      if (index == 0) {
        Navigator.pushNamed(context, '/');
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
  return Column(
    children: [
      Row(
        children: [
          ElevatedButton(onPressed: () {}, child: const Text('Income')),
          ElevatedButton(onPressed: () {}, child: const Text('Expence'))
        ],
      )
    ],
  );
}
