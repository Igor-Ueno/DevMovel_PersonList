import 'package:devmovel_personlist/person.dart';
import 'package:devmovel_personlist/person_repository.dart';
import 'package:flutter/material.dart';

// class PersonViewModel extends ChangeNotifier {
//
//   // private attr that keeps the list of tasks
//   final List<Person> _persons = [
//     Person(name: "Fulano", age: 25),
//     Person(name: "Ciclano", age: 23),
//     Person(name: "Beltrano", age: 31),
//   ];
//
//   // get method
//   List<Person> get persons => _persons;
//
//   void addPerson(String name, int age) {
//     _persons.add(Person(name: name, age: age));
//     notifyListeners();
//   }
//
//   void remove(int index) {
//     _persons.removeAt(index);
//     notifyListeners();
//   }
// }

import 'dart:async';

class PersonViewModel extends ChangeNotifier {
  final PersonRepository personRepository = PersonRepository();

  int _numberOfPersons = 0;
  List<Person> _persons = [];
  Person? _selectedPerson;
  StreamSubscription<Person>? _personStreamSubscription;

  get numberOfPersons => _numberOfPersons;
  get persons => _persons;
  get selectedPerson => _selectedPerson;

  Future<void> getPersons() async {
    print("MainViewModel - getPersons()");
    _numberOfPersons = 0;
    _persons = [];
    notifyListeners();
    // simulate a slower request
    await Future.delayed(const Duration(seconds: 2));
    final persons = await personRepository.getPersons();
    print("MainViewModel - getPersons() $persons");
    print("MainViewModel - numberOfPersons ${persons.length}");
    _numberOfPersons = persons.length;
    _persons = persons;
    notifyListeners();

    startContinousCollection();
  }

  Future<void> startContinousCollection() async {
    var streamsOfPersons =
    personRepository.getPersonsContinously(Duration(seconds: 4));
    await for (var newPersons in streamsOfPersons) {
      print(newPersons);
      _numberOfPersons = newPersons.length;
      _persons = newPersons;
      notifyListeners();
    }
  }

  // void selectBoardForMessages(Person person) {
  //   print("Selected board: $person");
  //   _selectedPerson = person;
  //   startMonitoringForPerson();
  // }
  //
  // void startMonitoringForPerson() {
  //   // send requests for board.id every 500ms
  //   var stream = personRepository.getPersonContinously(
  //       _selectedPerson!.id!, Duration(milliseconds: 500));
  //
  //   _personStreamSubscription = stream.listen((person) {
  //     _selectedPerson = person;
  //   });
  // }

  void stopMonitoringForPerson() {
    print('stopMonitoringForPerson');
    _personStreamSubscription?.cancel();
    personRepository.stopStreamingPerson();
  }

  Future<void> addPerson(String name, String age) async {
    print("MainViewModel - addPerson()");
    notifyListeners();
    Person person = Person(name: name, age: int.parse(age));

    // simulate a slower request
    await Future.delayed(const Duration(seconds: 2));
    final persons = await personRepository.addPerson(person);
    print("MainViewModel - addPerson() $persons");
    notifyListeners();

    startContinousCollection();
  }

  Future<void> deletePerson(int iid) async {
    print("MainViewModel - deletePerson()");
    notifyListeners();

    // simulate a slower request
    await Future.delayed(const Duration(seconds: 2));
    final persons = await personRepository.deletePerson(iid);
    print("MainViewModel - deletePerson() $persons");
    notifyListeners();
  }

  // Future<void> postMessage(
  //     int boardId, String from, String to, String textMessage) async {
  //   var message = Message(
  //       from: from.trim().isEmpty ? "anonymous" : from.trim(),
  //       to: to.trim().isEmpty ? "anonymous" : to.trim(),
  //       text: textMessage,
  //       timestamp: "");
  //   boardRepository.postMessage(boardId, message);
  // }
}
