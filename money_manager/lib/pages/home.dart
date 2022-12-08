import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  int currentIndex = 0;
  final List<bool> _selectedBtn = <bool>[false, true];
  CurrencyDatabase db = CurrencyDatabase();

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
          child: FutureBuilder<List<Expense>>(
            future: _getAllExpenses(),
            builder: (context, snapshot) {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        selected: index == selectedIndex,
                        onLongPress: () {
                          setState(() {
                            selectedIndex = index;
                          });
                          _deleteExpenseConfirm();
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(snapshot.data?[index].category.toString() ??
                                'Category'),
                            Text(snapshot.data?[index].amount.toString() ??
                                '\$0'),
                          ],
                        ),
                        leading: const Padding(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Icon(Icons.food_bank,
                              color: Colors.deepOrange, size: 36.0),
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

  Widget _buildForm(isIncome) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
              isIncome
                  ? const Padding(
                      padding: EdgeInsets.only(right: 12.0, top: 6.0),
                      child: Icon(Icons.add_reaction,
                          color: Colors.deepOrange, size: 30.0),
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
                      left: 12.0, right: isIncome ? 52.0 : 12.0),
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
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 110.0,
                child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _createExpense(category.text, double.parse(amount.text),
                            'add_reaction');
                        print(amount.text);
                      }
                    },
                    child: const Text('Save')),
              ),
            ],
          )
        ],
      ),
    );
  }

  _createExpense(String category, double amount, String icon) async {
    var currentDate =
        DateFormat('EEE, MMM yyyy').format(DateTime.now()).toString();

    Expense expense = Expense(
        category: category,
        amount: amount,
        unit: 'doller',
        icon: icon,
        date: currentDate);
    db.insertExpence(expense);
    setState(() {});
  }

  _deleteExpenseConfirm() {
    Future<void> future = showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.orange,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.cancel, color: Colors.white),
              ),
              const SizedBox(
                height: 35.0,
                child: VerticalDivider(
                  color: Colors.white,
                  thickness: 1,
                ),
              ),
              IconButton(
                onPressed: () => _deleteExpense(1),
                icon: const Icon(Icons.delete, color: Colors.white),
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
