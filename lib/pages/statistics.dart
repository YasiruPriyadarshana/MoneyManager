import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

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
        backgroundColor: Colors.grey[200],
        onTap: _onItemTapped,
      ),
    );
  }
}

Widget _buildHome() {
  final dataMap = <String, double>{
    "Food": 5,
    "Transport": 3,
    "Education": 2,
    "Health": 2,
  };

  final colorList = <Color>[
    const Color(0xfffdcb6e),
    const Color.fromARGB(255, 39, 143, 223),
    const Color.fromARGB(255, 149, 16, 63),
    const Color(0xffe17055),
    const Color(0xff6c5ce7),
  ];

  return Column(
    children: [
      Container(
        alignment: Alignment.topRight,
        padding: const EdgeInsets.all(5.0),
        child: ElevatedButton(
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Monthly'),
                Icon(Icons.arrow_downward_rounded)
              ],
            )),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 55),
        child: PieChart(
          dataMap: dataMap,
          chartType: ChartType.ring,
          baseChartColor: Colors.grey[50]!.withOpacity(0.15),
          colorList: colorList,
          chartValuesOptions: const ChartValuesOptions(
            showChartValuesInPercentage: true,
            showChartValueBackground: false,
          ),
          ringStrokeWidth: 22,
          totalValue: 12,
        ),
      ),
    ],
  );
}
