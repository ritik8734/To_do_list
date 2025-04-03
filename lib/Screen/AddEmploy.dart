import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../Bloc/Controller.dart';
import '../Bloc/Event.dart';
import '../Bloc/model.dart';
import '../SqlLite.dart';
import '../Utils/Colors.dart';
import '../Utils/DatePIcker.dart';
import '../Utils/Style.dart';
import '../Utils/TextField.dart';

class AddEmploye extends StatelessWidget {
  final Employee? employee; // Nullable Employee object for editing
  Function() call;
  AddEmploye({super.key, this.employee, required this.call});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeBloc(DatabaseHelper()),
      child: AddEmployeScreen(
        employee: employee,
        callback: () {
          call();
        },
      ),
    );
  }
}

class AddEmployeScreen extends StatefulWidget {
  final Employee? employee;
  Function() callback;

  AddEmployeScreen({super.key, this.employee, required this.callback});

  @override
  _AddEmployeScreenState createState() => _AddEmployeScreenState();
}

class _AddEmployeScreenState extends State<AddEmployeScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? selectedRole;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _nameController.text = widget.employee!.name;
      selectedRole = widget.employee!.role;
      startDate = DateTime.parse(widget.employee!.startDate);
      endDate =
          widget.employee!.endDate.isNotEmpty
              ? DateTime.parse(widget.employee!.endDate)
              : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: appBar(
        widget.employee == null ? "Add Employee" : "Edit Employee",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              _nameController,
              "Name",
              prefix: Image.asset("assets/person.png", color: lightBlueColour),
            ),
            const SizedBox(height: 16),

            // Role Selector using Bottom Sheet
            GestureDetector(
              onTap:
                  () => showRolePicker(context, (role) {
                    setState(() => selectedRole = role);
                  }),
              child: InputDecorator(
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: lightBlueColour,
                  ),
                  prefixIcon: Image.asset(
                    "assets/role.png",
                    color: lightBlueColour,
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE5E5E5)),
                  ),
                ),
                child: Text(
                  selectedRole ?? "Select Role",
                  style: TextStyle(
                    color: selectedRole == null ? Colors.grey : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Date Pickers
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap:
                        () => _selectDate(context, startDate, 0, (date) {
                          startDate = date;
                        }),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        prefixIcon: Image.asset(
                          "assets/date.png",
                          color: lightBlueColour,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFE5E5E5)),
                        ),
                      ),
                      child: Text(
                        startDate != null
                            ? DateFormat.yMMMd().format(startDate!)
                            : "Start Date",
                        style: TextStyle(
                          color: startDate == null ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.arrow_right_alt, color: lightBlueColour),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap:
                        () => _selectDate(
                          context,
                          endDate,
                          currentDate: startDate,
                          1,
                          (date) {
                            endDate = date;
                          },
                        ),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        prefixIcon: Image.asset(
                          "assets/date.png",
                          color: lightBlueColour,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFE5E5E5)),
                        ),
                      ),
                      child: Text(
                        endDate != null
                            ? DateFormat.yMMMd().format(endDate!)
                            : "No Date",
                        style: TextStyle(
                          color: endDate == null ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: const Color(0xFFF2F2F2))),
        ),
        width: width,
        height: 70,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 73,
                  height: 40,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFEDF8FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Center(
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: const Color(0xFF1DA1F2),
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5),
              InkWell(
                onTap: () {
                  if (_nameController.text.isNotEmpty &&
                      selectedRole != null &&
                      startDate != null) {
                    final employee = Employee(
                      id: widget.employee?.id, // Keep ID if editing
                      name: _nameController.text,
                      role: selectedRole!,
                      startDate: startDate.toString(),
                      endDate: endDate?.toString() ?? "",
                    );
                    setState(() {
                      isLoading = true;
                    });
                    final bloc = BlocProvider.of<EmployeeBloc>(context);
                    if (widget.employee == null) {
                      bloc.add(AddEmployee(employee));
                    } else {
                      bloc.add(UpdateEmployee(employee));
                    }
                    widget.callback();
                    widget.callback();
                    Future.delayed(
                      Duration(seconds: 2),
                      () => Navigator.pop(context),
                    );
                  }
                  ;
                },
                child: Container(
                  width: 73,
                  height: 40,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF1DA1F2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      isLoading ? "Saving..." : "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }

  bool isLoading = false;

  void _selectDate(
    BuildContext context,
    DateTime? initialDate,
    start,
    Function(DateTime) onDateSelected, {
    DateTime? currentDate,
  }) {
    print("initialDate$initialDate");
    showCustomDatePicker(
      context,
      start == 0 ? initialDate ?? DateTime.now() : initialDate ?? currentDate!,
      start,
      (date) {
        setState(() {
          onDateSelected(date);
        });
      },
    );
  }
}
