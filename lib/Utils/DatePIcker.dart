import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Colors.dart';

// Reusable Role Picker Widget
void showRolePicker(BuildContext context, Function(String) onRoleSelected) {
  showModalBottomSheet(
    scrollControlDisabledMaxHeightRatio: .28,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ...["Product Designer", "QA Tester", "Flutter Developer"].map(
              (role) => ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text(role)],
                    ),
                    Divider(color: Colors.grey.shade200),
                  ],
                ),
                onTap: () {
                  onRoleSelected(role);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> showCustomDatePicker(
  BuildContext context,
  DateTime selectedDate,
  Start,
  Function(DateTime) onDateSelected,
) async {
  DateTime tempSelectedDate = selectedDate;
  DateTime tempDisplayedMonth = selectedDate;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(9.0),
              child: Column(
                children: [
                  if (Start == 0) ...[
                    // Quick Select Buttons (Added Next Month)
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildQuickSelectButton(
                            context,
                            "Today",
                            DateTime.now(),
                            (date) {
                              tempSelectedDate = date;
                            },
                            setState,
                            tempSelectedDate, // Pass selected date
                            // Pass the setState function here
                          ),
                          SizedBox(width: 15),
                          _buildQuickSelectButton(
                            context,
                            "Next Monday",
                            _nextWeekday(DateTime.monday),
                            (date) {
                              tempSelectedDate = date;
                            },
                            setState,
                            tempSelectedDate, // Pass selected date
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildQuickSelectButton(
                            context,
                            "Next Tuesday",
                            _nextWeekday(DateTime.tuesday),
                            (date) {
                              setState(() => tempSelectedDate = date);
                            },
                            setState,
                            tempSelectedDate, // Pass selected date
                          ),
                          SizedBox(width: 15),

                          _buildQuickSelectButton(
                            context,
                            "After 1 Week",
                            DateTime.now().add(Duration(days: 7)),
                            (date) {
                              setState(() => tempSelectedDate = date);
                            },
                            setState,
                            tempSelectedDate, // Pass selected date
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (Start == 1)
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildQuickSelectButton(
                            context,
                            "No Date",
                            DateTime(
                              0,
                            ), // A special value to indicate "No Date"
                            (date) {
                              setState(() => tempSelectedDate = DateTime(0));
                            },
                            setState,
                            tempSelectedDate, // Pass selected date
                          ),
                          SizedBox(width: 15),

                          _buildQuickSelectButton(
                            context,
                            "Today",
                            DateTime.now(),
                            (date) {
                              tempSelectedDate = date;
                            },
                            setState,
                            tempSelectedDate, // Pass selected date
                            // Pass the setState function here
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 10),

                  // Month Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_left, size: 28),
                        onPressed: () {
                          setState(() {
                            tempDisplayedMonth = DateTime(
                              tempDisplayedMonth.year,
                              tempDisplayedMonth.month - 1,
                              1,
                            );
                          });
                        },
                      ),
                      Text(
                        DateFormat.yMMMM().format(tempDisplayedMonth),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_right, size: 28),
                        onPressed: () {
                          setState(() {
                            tempDisplayedMonth = DateTime(
                              tempDisplayedMonth.year,
                              tempDisplayedMonth.month + 1,
                              1,
                            );
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  // Calendar Grid
                  _buildCalendar(
                    tempDisplayedMonth,
                    tempSelectedDate,
                    (date) {
                      setState(() => tempSelectedDate = date);
                    },
                    setState,
                    Start,
                    tempSelectedDate,
                  ),

                  const SizedBox(height: 10),

                  // Selected Date Display & Buttons
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/date.png",
                              color: lightBlueColour,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              tempSelectedDate == DateTime(0)
                                  ? "No Date"
                                  : DateFormat.yMMMMd().format(
                                    tempSelectedDate,
                                  ),
                              style: TextStyle(
                                color: const Color(0xFF323238),
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),

                        FittedBox(
                          child: Row(
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
                                  onDateSelected(tempSelectedDate);
                                  Navigator.pop(context);
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
                                    child: const Text(
                                      "Save",
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

Widget _buildCalendar(
  DateTime month,
  DateTime selectedDate,
  Function(DateTime) onDateSelected,
  Function setState,
  int Start,
  DateTime startDate,
) {
  int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
  int firstWeekday =
      DateTime(month.year, month.month, 1).weekday; // 1 = Monday, 7 = Sunday

  List<String> weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

  return Column(
    children: [
      // Weekday Headers
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            weekdays
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          color: Color(0xFF323238),
                          fontSize: 12,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
                .toList(),
      ),

      const SizedBox(height: 8),

      // Calendar Grid
      GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, // 7 days a week
          childAspectRatio: 1.2,
        ),
        itemCount: (firstWeekday % 7) + daysInMonth, // Adjust for empty spaces
        itemBuilder: (context, index) {
          if (index < (firstWeekday % 7)) {
            return const SizedBox(); // Empty slots before the first day
          }

          int day = index - (firstWeekday % 7) + 1; // Correctly align days
          DateTime currentDate = DateTime(month.year, month.month, day);
          bool isSelected =
              selectedDate.year == currentDate.year &&
              selectedDate.month == currentDate.month &&
              selectedDate.day == currentDate.day;

          bool isDisabled = Start == 1 && currentDate.isBefore(selectedDate);

          return GestureDetector(
            onTap:
                isDisabled
                    ? null
                    : () {
                      setState(() {
                        onDateSelected(currentDate);
                      });
                    },
            child: Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF1DA1F2) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "$day",
                  style: TextStyle(
                    color:
                        isDisabled
                            ? Colors.grey
                            : isSelected
                            ? Colors.white
                            : Color(0xFF323238),
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ],
  );
}

Widget _buildQuickSelectButton(
  BuildContext context,
  String label,
  DateTime date,
  Function(DateTime) onDateSelected,
  Function setState,
  DateTime selectedDate,
) {
  var width = MediaQuery.of(context).size.width;
  bool isSelected =
      selectedDate.year == date.year &&
      selectedDate.month == date.month &&
      selectedDate.day == date.day;

  return InkWell(
    onTap: () {
      setState(() {
        onDateSelected(date);
      });
    },
    child: Container(
      width: width / 2.8,
      padding: EdgeInsets.symmetric(vertical: 13),
      decoration: ShapeDecoration(
        color:
            isSelected
                ? Color(0xFF1DA1F2)
                : Color(0xFFEDF8FF), // Blue if selected
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color:
                isSelected
                    ? Colors.white
                    : Color(0xFF1DA1F2), // White if selected
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            height: 1.43,
          ),
        ),
      ),
    ),
  );
}

DateTime _nextWeekday(int weekday) {
  DateTime now = DateTime.now();
  int daysToAdd = (weekday - now.weekday) % 7;
  return now.add(Duration(days: daysToAdd == 0 ? 7 : daysToAdd));
}
