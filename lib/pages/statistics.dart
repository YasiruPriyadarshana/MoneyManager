import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../database/database.dart';
import '../models/expense.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StatsPageState();
  }
}

class _StatsPageState extends State<StatsPage> {
  CurrencyDatabase db = CurrencyDatabase();
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
      body: Column(children: [_buildHome(), _buildListView()]),
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
                  Text('Monthly', style: TextStyle(color: Colors.white)),
                  Icon(Icons.arrow_downward_rounded, color: Colors.white)
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

  _buildListView() {
    return Expanded(
      child: FutureBuilder<List<Expense>>(
        future: _getAllExpenses(),
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: snapshot.data?.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 2,
                  shadowColor: Colors.grey,
                  child: ListTile(
                    // selected: index == selectedIndex,
                    onLongPress: () {
                      setState(() {
                        // selectedIndex = index;
                      });
                      // _deleteExpenseConfirm();
                    },
                    title: Row(
                      children: [
                        const SizedBox(
                          width: 30.0,
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                              snapshot.data?[index].category.toString() ??
                                  'Category'),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                              "\$${snapshot.data?[index].amount.toString()}"),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  Future<List<Expense>> _getAllExpenses() async {
    List<Expense> listexpense = await db.viewAllExpence();

    return listexpense;
  }
}
