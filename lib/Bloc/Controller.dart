import 'package:flutter_bloc/flutter_bloc.dart';

import '../SqlLite.dart';
import 'Event.dart';
import 'State.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final DatabaseHelper databaseHelper;

  EmployeeBloc(this.databaseHelper) : super(EmployeeInitial()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<AddEmployee>(_onAddEmployee);
    on<UpdateEmployee>(_onUpdateEmployee);
    on<DeleteEmployee>(_onDeleteEmployee);
  }

  Future<void> _onLoadEmployees(
    LoadEmployees event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());
    try {
      final employees = await databaseHelper.getEmployees();
      emit(EmployeeLoaded(employees));
    } catch (e) {
      emit(EmployeeError("Failed to load employees"));
    }
  }

  Future<void> _onAddEmployee(
    AddEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      await databaseHelper.insertEmployee(event.employee);
      add(LoadEmployees());
    } catch (e) {
      emit(EmployeeError("Failed to add employee"));
    }
  }

  Future<void> _onUpdateEmployee(
    UpdateEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      await databaseHelper.updateEmployee(event.employee);
      add(LoadEmployees());
    } catch (e) {
      emit(EmployeeError("Failed to update employee"));
    }
  }

  Future<void> _onDeleteEmployee(
    DeleteEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      await databaseHelper.deleteEmployee(event.id);
      add(LoadEmployees());
    } catch (e) {
      emit(EmployeeError("Failed to delete employee"));
    }
  }
}
