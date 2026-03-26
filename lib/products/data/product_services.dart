import 'dart:convert';
import 'dart:developer';

import 'package:bloc_examples/products/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductServices {
  Future<List<ProductModel>> fetchProducts(int start, int limit) async {
    final url = 'https://dummyjson.com/products?skip=$start&limit=$limit';

    final response = await http.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json', 'User-Agent': 'Mozilla/5.0'},
    );

    log("API ${response.request}\n${response.statusCode}\n${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      final List products = data['products'] ?? [];

      return products.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch photos');
    }
  }
}
