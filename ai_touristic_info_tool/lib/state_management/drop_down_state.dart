import 'package:flutter/foundation.dart';


///This is a provider class for the drop down menu state for state managment in order to be able to view the selected data from the drop down list
/// [_selectedIndex] is a private variable of type [int] and its [late]  that holds the selected index in the list and we have public getter that returns it and public setter that sets it
/// It will notify all listerners that data has changed
class DropdownState extends ChangeNotifier {
  late int _selectedIndex;

  DropdownState({int? initialValue}) {
    _selectedIndex = initialValue ?? 0;
  }

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;

    notifyListeners();
  }
}
