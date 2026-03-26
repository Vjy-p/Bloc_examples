import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class ChatServices {
  final int userId = 123456;

  Future<Map<String, dynamic>?> getChatHistory() async {
    final url = "https://";

    final response = await http.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json', 'User-Agent': 'Mozilla/5.0'},
    );
    log("API ${response.request}\n${response.statusCode}\n${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      return data;
    } else {
      throw Exception("Failed to fetch chat history");
    }
  }
}
