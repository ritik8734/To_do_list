class Employee {
  int? id;
  String name;
  String role;
  String startDate;
  String endDate;

  Employee({
    this.id,
    required this.name,
    required this.role,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      role: map['role'],
      startDate: map['startDate'],
      endDate: map['endDate'],
    );
  }
}
