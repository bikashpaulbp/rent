import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rent_management/models/IncomeExpense.dart';
import 'package:rent_management/models/IncomeExpenseTransaction.dart';
import 'package:rent_management/models/incomeExpenseTypeModel.dart';
import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/login_screen.dart';
import 'package:rent_management/services/incomeExpenseTran_service.dart';
import 'package:rent_management/services/incomeExpense_service.dart';
import 'package:rent_management/shared_data/incomeExpense_provider.dart';
import 'package:velocity_x/velocity_x.dart';

class Expense extends StatefulWidget {
  final Function() refresh;
  Expense({required this.refresh, super.key});

  @override
  State<Expense> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  TextEditingController expenseNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  IncomeExpenseApiService incomeExpenseApiService = IncomeExpenseApiService();
  IncomeExpenseTransactionApiService incomeExpenseTransactionApiService =
      IncomeExpenseTransactionApiService();

  DateTime? tranDate;
  final format = DateFormat("dd MMM y");
  int typeId = 2;
  int? selectedId;

  AuthStateManager authStateManager = AuthStateManager();
  UserModel? loggedInUser = UserModel();
  int? buildingId;
  int? userId;
  bool isLoading = false;
  bool isLoading2 = false;

  Future<void> getUser() async {
    loggedInUser = (await authStateManager.getLoggedInUser())!;
  }

  Future<void> getBuildingId() async {
    buildingId = await authStateManager.getBuildingId();
  }

  @override
  void initState() {
    setState(() {
      getUser();
      getBuildingId();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Expense".text.make(),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                    child: "Add Expense Type".text.bold.blue300.size(24).make())
                .centered()
                .p16(),
            SizedBox().h(20),
            TextFormField(
              keyboardType: TextInputType.name,
              controller: expenseNameController,
              decoration: InputDecoration(
                suffix: const Text(
                  '*',
                  style: TextStyle(color: Colors.red),
                ),
                labelText: 'Expense Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox().h(10),
            ButtonBar(children: [
              isLoading == false
                  ? ElevatedButton(
                      onPressed: () async {
                        getBuildingId();
                        getUser();
                        setState(() {
                          isLoading = true;
                        });
                        userId = loggedInUser!.id;

                        if (expenseNameController.text.isNotEmpty) {
                          IncomeExpenseModel expenseModel = IncomeExpenseModel(
                              userId: userId,
                              buildingId: buildingId,
                              incomeExpenseType: typeId,
                              name: expenseNameController.text);
                          await incomeExpenseApiService
                              .createIncomeExpense(expenseModel);
                          widget.refresh;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  "expense added successfully".text.make()));
                          setState(() {
                            isLoading = false;
                            expenseNameController.clear();
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  "please enter expense name".text.make()));
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: "Add".text.make())
                  : Center(child: CircularProgressIndicator()),
            ]),
            SizedBox().h(40),
            SizedBox(child: "Add Transaction".text.bold.blue300.size(24).make())
                .centered()
                .p16(),
            SizedBox().h(20),
            Consumer<IncomeExpenseProvider>(
              builder: (context, expenseData, child) {
                expenseData.getIncomeExpenseList();
                getBuildingId();
                getUser();
                List<IncomeExpenseModel> allExpenseList =
                    expenseData.incomeExpenseList;
                List<IncomeExpenseModel> expenseList = allExpenseList
                    .where((element) =>
                        element.buildingId == buildingId &&
                        element.userId == loggedInUser!.id)
                    .toList();

                return DropdownButtonFormField<int>(
                  disabledHint: "add expense first".text.make(),
                  isExpanded: true,
                  decoration: InputDecoration(
                    suffix: const Text(
                      '*',
                      style: TextStyle(color: Colors.red),
                    ),
                    labelText: 'Select Expense Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: selectedId,
                  onChanged: (int? value) {
                    setState(() {
                      selectedId = value!;
                    });
                  },
                  items: expenseList
                      .map<DropdownMenuItem<int>>((IncomeExpenseModel expense) {
                    return DropdownMenuItem<int>(
                      value: expense.id,
                      child: Text(expense.name!),
                    );
                  }).toList(),
                );
              },
            ),
            SizedBox().h(10),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: amountController,
              decoration: InputDecoration(
                suffix: const Text(
                  '*',
                  style: TextStyle(color: Colors.red),
                ),
                labelText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox().h(10),
            TextFormField(
              keyboardType: TextInputType.name,
              controller: descriptionController,
              decoration: InputDecoration(
                suffix: const Text(
                  '*',
                  style: TextStyle(color: Colors.red),
                ),
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox().h(10),
            DateTimeField(
              decoration: InputDecoration(
                  suffix: const Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                  labelText: 'select transaction date',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  icon: const Icon(Icons.calendar_month)),
              onChanged: (newValue) {
                setState(() {
                  tranDate = newValue!;
                });
              },
              format: format,
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100),
                );
              },
            ),
            SizedBox().h(10),
            ButtonBar(children: [
              isLoading == false
                  ? ElevatedButton(
                      onPressed: () async {
                        getBuildingId();
                        getUser();
                        setState(() {
                          isLoading2 = true;
                        });
                        userId = loggedInUser!.id;

                        if (descriptionController.text.isNotEmpty &&
                            amountController.text.isNotEmpty &&
                            selectedId != null &&
                            tranDate != null) {
                          IncomeExpenseTransactionModel tranModel =
                              IncomeExpenseTransactionModel(
                                  userId: userId,
                                  buildingId: buildingId,
                                  amount: int.parse(amountController.text),
                                  incomeExpenseId: selectedId,
                                  rentId: 00,
                                  tranDate: tranDate,
                                  name: descriptionController.text ?? "");
                          await incomeExpenseTransactionApiService
                              .createIncomeExpenseTransaction(tranModel);
                          widget.refresh;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: "transaction added successfully"
                                  .text
                                  .make()));
                          setState(() {
                            isLoading2 = false;
                            selectedId = null;
                            tranDate = null;
                            descriptionController.clear();
                            amountController.clear();
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  "please enter all information".text.make()));
                          setState(() {
                            isLoading2 = false;
                          });
                        }
                      },
                      child: "Add".text.make())
                  : Center(child: CircularProgressIndicator()),
            ]),
            SizedBox().h(40),
          ],
        ).p16(),
      ),
    );
  }
}
