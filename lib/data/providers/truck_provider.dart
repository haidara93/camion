import 'package:camion/data/models/truck_model.dart';
import 'package:flutter/material.dart';

class TruckProvider extends ChangeNotifier {
  Truck? _selectedTruck;
  Truck? get selectedTruck => _selectedTruck;

  List<Truck>? _trucks;
  List<Truck>? get trucks => _trucks;

  setTrucks(List<Truck>? value) {
    _trucks = value;
    notifyListeners();
  }

  init() {
    _selectedTruck = null;

    _trucks = [];
  }

  setSelectedTruck(Truck? value) {
    _selectedTruck = value;
    notifyListeners();
  }
}
