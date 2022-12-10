import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/models/income.dart';

import '../models/expense.dart';
import '../widgets/calendar.dart';
import '../database/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = -1;
  int selectedIcon = 0;
  int currentIndex = 0;
  String unit = '\$';
  final List<bool> _selectedBtn = <bool>[false, true];
  CurrencyDatabase db = CurrencyDatabase();

  final iconList = const <IconData>[
    Icons.add_reaction,
    Icons.car_rental,
    Icons.fastfood,
    Icons.house,
    Icons.health_and_safety,
    Icons.menu_book,
    Icons.beach_access,
    Icons.phone_android,
    // Icons.card_giftcard
  ];

  List<Color> iconColorList = [
    Colors.orange,
    Colors.redAccent,
    Colors.orange,
    Colors.lightGreen,
    Colors.pink,
    Colors.purple,
    Colors.green,
    Colors.blueAccent,
    // Color.fromARGB(255, 156, 156, 20),
  ];

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
      body: Column(
        children: [
          Expanded(
            child: _buildHome(),
          ),
          const SizedBox(height: 5),
          _buildToggleButtons(),
          _buildForm(!_selectedBtn[0])
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
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
    );
  }

  Future<List<Expense>> _getAllExpenses() async {
    List<Expense> listexpense = await db.viewAllExpence();

    return listexpense;
  }

  Widget _buildHome() {
    return Column(
      children: [
        const Calendar(),
        const Text('Budget:500\$'),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const LinearProgressIndicator(
              value: 0.24,
              minHeight: 18,
            ),
          ),
        ),
        Expanded(
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
                        selected: index == selectedIndex,
                        onLongPress: () {
                          setState(() {
                            selectedIndex = index;
                          });
                          _deleteExpenseConfirm();
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
                        leading: Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Icon(iconList[snapshot.data?[index].icon ?? 0],
                              color: iconColorList[
                                  snapshot.data?[index].icon ?? 0],
                              size: 30.0),
                        ),
                      ),
                    );
                  });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButtons() {
    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: (int index) {
        setState(() {
          // The button that is tapped is set to true, and the others to false.
          for (int i = 0; i < _selectedBtn.length; i++) {
            _selectedBtn[i] = i == index;
          }
        });
      },
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedBorderColor: Colors.amber[800],
      selectedColor: Colors.white,
      fillColor: Colors.amber[700],
      color: Colors.amber[600],
      constraints: const BoxConstraints(
        minHeight: 30.0,
        minWidth: 80.0,
      ),
      isSelected: _selectedBtn,
      children: const [
        Text('Income'),
        Text('Expense'),
      ],
    );
  }

  Widget _buildForm(isExpense) {
    final formKey = GlobalKey<FormState>();
    final category = TextEditingController();
    final amount = TextEditingController();

    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12.0, top: 6.0),
                child: SizedBox(width: 58.0, child: Text('Category')),
              ),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 12.0, right: isExpense ? 0 : 12.0),
                  child: TextFormField(
                    controller: category,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: '',
                    ),
                  ),
                ),
              ),
              isExpense
                  ? Padding(
                      padding: const EdgeInsets.only(right: 6.0, top: 6.0),
                      child: IconButton(
                          onPressed: () => _changeCatogoryIcon(),
                          icon: Icon(iconList[selectedIcon],
                              color: iconColorList[selectedIcon], size: 30.0)),
                    )
                  : const SizedBox(),
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12.0, top: 6.0),
                child: SizedBox(width: 58.0, child: Text('Amount')),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 12.0, right: isExpense ? 52.0 : 12.0),
                  child: TextFormField(
                    controller: amount,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter amount';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: '\$500',
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 110.0,
                child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _createExpense(category.text, double.parse(amount.text),
                            !_selectedBtn[0]);
                      }
                    },
                    child: const Text('Save',
                        style: TextStyle(color: Colors.white))),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }

  _changeCatogoryIcon() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.grey[50],
          child: GridView.builder(
            primary: false,
            padding: const EdgeInsets.all(8),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 5, crossAxisSpacing: 5, crossAxisCount: 8),
            itemCount: iconList.length,
            itemBuilder: (BuildContext context, int index) {
              return IconButton(
                  onPressed: () {
                    selectedIcon = index;
                    Navigator.pop(context);
                    setState(() {});
                  },
                  icon: Icon(iconList[index],
                      color: iconColorList[index], size: 24.0));
            },
          ),
        );
      },
    );
  }

  //databse functions
  _createExpense(String category, double amount, bool isExpense) async {
    var currentDate =
        DateFormat('EEE, MMM yyyy').format(DateTime.now()).toString();

    if (isExpense) {
      Expense expense = Expense(
          category: category,
          amount: amount,
          icon: selectedIcon,
          date: currentDate);
      db.insertExpence(expense);
    } else {
      Income income =
          Income(category: category, amount: amount, date: currentDate);
      db.insertIncome(income);
    }

    setState(() {});
  }

  _deleteExpenseConfirm() {
    Future<void> future = showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.grey[200],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.cancel, color: Colors.orange),
              ),
              const SizedBox(
                height: 35.0,
                child: VerticalDivider(
                  color: Colors.black26,
                  thickness: 1,
                ),
              ),
              IconButton(
                onPressed: () => _deleteExpense(1),
                icon: const Icon(Icons.delete, color: Colors.redAccent),
              ),
            ],
          ),
        );
      },
    );

    future.then((value) {
      setState(() {
        selectedIndex = -1;
      });
    });
  }

  _deleteExpense(int id) {
    // Remove expense from the database.
    db.deleteExpence(id);
    setState(() {});
    Navigator.pop(context);
  }
}
