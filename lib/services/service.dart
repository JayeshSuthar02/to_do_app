import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/task_list.dart';

class Service {
  static const String baseUrl = 'https://dummyjson.com/todos';

  Future<List<TaskList>> fetchTasks() async {
    final url = Uri.parse(baseUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['todos'] as List)
          .map((item) => TaskList.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  Future<TaskList> addTask(String task) async {
    final url = Uri.parse('$baseUrl/add');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'todo': task,
        'completed': false,
        'userId': 1,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return TaskList.fromJson(data);
    } else {
      throw Exception('Failed to add task');
    }
  }
}
