import 'package:devmovel_personlist/general_response.dart';
import 'package:devmovel_personlist/person.dart';
import 'package:dio/dio.dart';

class PersonRepository {
  static const BASE_URL = "http://10.0.2.2:3000";
  static const TO_TEST_URL = "http://localhost:3000";

  // object used to make http requests
  late final Dio _dio;
  bool _isStreamingPerson = false;

  PersonRepository([bool test = false]) {
    if (test) {
      _dio = Dio(BaseOptions(baseUrl: TO_TEST_URL));
    } else {
      _dio = Dio(BaseOptions(baseUrl: BASE_URL));
    }
  }

  Future<List<Person>> getPersons() async {
    final response = await _dio.get('/person');
    if (response.statusCode == 200) {
      var personsFromJson = response.data as List;
      return personsFromJson
          .map((boardJson) => Person.fromJson(boardJson))
          .toList();
    } else {
      throw Exception('Exception');
    }
  }

  Future<Person> addPerson(Person person) async {
    try {
      final response = await _dio.post(
        '/person',
        data: person.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Person.fromJson(response.data);
      } else {
        throw Exception('Failed to add this person');
      }
    } catch (e) {
      throw Exception('Error adding person: $e');
    }
  }

  Future<Person> getPerson(int iid) async {
    try {
      final response = await _dio.get('/person/$iid');
      if (response.statusCode == 200) {
        return Person.fromJson(response.data);
      } else {
        throw Exception('Failed to load person');
      }
    } catch (e) {
      throw Exception('Error getting person: $e');
    }
  }

  Future<GeneralResponse> deletePerson(int iid) async {
    try {
      final response = await _dio.delete('/person/$iid');
      if (response.statusCode == 200) {
        return GeneralResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to delete person');
      }
    } catch (e) {
      throw Exception('Error deleting person: $e');
    }
  }

  // Future<GeneralResponse> postMessage(int iid, Message message) async {
  //   try {
  //     final response = await _dio.post(
  //       '/board/$iid/messages',
  //       data: message.toJson(),
  //     );
  //     if (response.statusCode == 200) {
  //       return GeneralResponse.fromJson(response.data);
  //     } else {
  //       throw Exception('Failed to post message');
  //     }
  //   } catch (e) {
  //     throw Exception('Error posting message: $e');
  //   }
  // }
  //
  // Future<List<Message>> getMessages(int iid) async {
  //   try {
  //     final response = await _dio.get('/board/$iid/messages');
  //     if (response.statusCode == 200) {
  //       List<Message> messages = (response.data as List)
  //           .map((item) => Message.fromJson(item))
  //           .toList();
  //       return messages;
  //     } else {
  //       throw Exception('Failed to get messages');
  //     }
  //   } catch (e) {
  //     throw Exception('Error getting messages: $e');
  //   }
  // }

  Future<GeneralResponse> reset() async {
    final response = await _dio.get('/reset');
    if (response.statusCode == 200) {
      return GeneralResponse.fromJson(response.data);
    } else {
      throw Exception('Exception');
    }
  }

  Stream<List<Person>> getPersonsContinously(Duration afterTime) async* {
    while (true) {
      try {
        print('getPersonsContinously - waiting for new request');
        await Future.delayed(afterTime);
        var persons = await getPersons();
        yield persons;
      } catch (e) {
        print('getPersonsContinously - Some error retrieving boards');
      } finally {}
    }
  }

  Stream<Person> getPersonContinously(int iid, Duration afterTime) async* {
    _isStreamingPerson = true;
    while (_isStreamingPerson) {
      try {
        var person = await getPerson(iid);
        yield person;
      } catch (e) {
        print('getPerson $iid Continously - Some error retrieving boards');
      } finally {
        print('getPerson $iid Continously - waiting for new request');
        await Future.delayed(afterTime);
      }
    }
  }

  // Stop active stream of a board
  void stopStreamingPerson() {
    _isStreamingPerson = false;
  }
}
