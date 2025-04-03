import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do/Bloc/model.dart';
import 'package:intl/intl.dart';
import 'package:simple_to_do/Screen/AddEmploy.dart';
import 'package:simple_to_do/Utils/Style.dart';

import '../Bloc/Controller.dart';
import '../Bloc/Event.dart';
import '../Bloc/State.dart';
import '../SqlLite.dart';

class EmployeeListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EmployeeBloc data = EmployeeBloc(DatabaseHelper());
    data.add(LoadEmployees());

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: appBar('Employee List'),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: BlocBuilder<EmployeeBloc, EmployeeState>(
          bloc: data,
          builder: (context, state) {
            if (state is EmployeeLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is EmployeeLoaded) {
              List<Employee> allEmployees = state.employees;

              // Filtering employees
              List<Employee> currentEmployees =
                  allEmployees.where((e) {
                    return e.endDate.isEmpty;
                  }).toList();

              List<Employee> previousEmployees =
                  allEmployees.where((e) {
                    return e.endDate.isNotEmpty;
                  }).toList();

              return allEmployees.isNotEmpty
                  ? SingleChildScrollView(
                    child: Column(
                      children: [
                        if (currentEmployees.isNotEmpty) ...[
                          Row(
                            children: [
                              _buildSectionTitle('   Current Employees'),
                            ],
                          ),
                          _buildEmployeeList(currentEmployees, context, data),
                          SizedBox(height: 10),
                        ],
                        if (previousEmployees.isNotEmpty) ...[
                          Row(
                            children: [
                              _buildSectionTitle('   Previous Employees'),
                            ],
                          ),
                          _buildEmployeeList(previousEmployees, context, data),
                          SizedBox(height: 20),
                        ],
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Row(
                            children: [
                              Text(
                                'Swipe left to delete',
                                style: TextStyle(
                                  color: const Color(0xFF949C9E),
                                  fontSize: 15,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  height: 1.33,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  : Center(child: Image.asset("assets/NoEmploy.png"));
            } else {
              return SizedBox();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AddEmploye(
                    call: () {
                      data.add(LoadEmployees());
                    },
                  ),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      title,
      style: TextStyle(
        color: const Color(0xFF1DA1F2),
        fontSize: 16,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        height: 1.50,
      ),
    ),
  );
}

Widget _buildEmployeeList(
  List<Employee> employees,
  BuildContext context,
  EmployeeBloc data,
) {
  return SingleChildScrollView(
    child: Container(
      color: Colors.white,
      child: Column(
        children:
            employees.map((employee) {
              return Dismissible(
                key: Key(employee.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  data.add(DeleteEmployee(employee.id!));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Employee data has been deleted!"),
                      backgroundColor: Colors.black,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => AddEmploye(
                              employee: employee,
                              call: () {
                                data.add(LoadEmployees());
                              },
                            ),
                      ),
                    );
                  },
                  title: Text(
                    employee.name,
                    style: TextStyle(
                      color: const Color(0xFF323238),
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          employee.role,
                          style: TextStyle(
                            color: const Color(0xFF949C9E),
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            height: 1.43,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            employee.endDate.isNotEmpty
                                ? '${DateFormat.yMMMd().format(DateTime.parse(employee.startDate))} '
                                : 'From ${DateFormat.yMMMd().format(DateTime.parse(employee.startDate))} ',
                            style: TextStyle(
                              color: const Color(0xFF949C9E),
                              fontSize: 12,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              height: 1.67,
                            ),
                          ),
                          if (employee.endDate.isNotEmpty)
                            Text(
                              '- ${DateFormat.yMMMd().format(DateTime.parse(employee.endDate))}',
                              style: TextStyle(
                                color: const Color(0xFF949C9E),
                                fontSize: 12,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                height: 1.67,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    ),
  );
}
