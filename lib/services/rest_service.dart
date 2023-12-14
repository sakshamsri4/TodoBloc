import 'dart:convert';

import 'package:bloc_api_integration/models/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RestService {
  Future<List<TodoModel>> fetchTodo() async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => TodoModel.fromJson(e)).toList();
      } else {
        debugPrint('Failed to load data');
        return [];
      }
    } catch (e) {
      debugPrint('Error: $e');
      return [];
    }
  }
}
