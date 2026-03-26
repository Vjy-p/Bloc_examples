import 'dart:convert';
import 'dart:developer';

import 'package:bloc_examples/products/models/product_model.dart';
import 'package:http/http.dart' as http;

class CartServices {
  final int cartId = 123456;
  final int userId = 123456;

  Future<List<ProductModel>?> getCart() async {
    final url = "https://fakestoreapi.com/carts/$cartId";

    final response = await http.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json', 'User-Agent': 'Mozilla/5.0'},
    );
    log("API ${response.request}\n${response.statusCode}\n${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      final List? products = data['products'];

      return products?.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch Cart");
    }
  }

  Future<bool?> createCart() async {
    final url = "https://fakestoreapi.com/carts";

    final response = await http.post(
      Uri.parse(url),
      headers: {'Accept': 'application/json', 'User-Agent': 'Mozilla/5.0'},
      body: jsonEncode({"id": cartId, "userId": userId, "products": []}),
    );
    log("API ${response.request}\n${response.statusCode}\n${response.body}");

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception("Failed to create cart");
    }
  }

  Future updateCart({required List<ProductModel> products}) async {
    final url = "https://fakestoreapi.com/carts/$cartId";

    final response = await http.patch(
      Uri.parse(url),
      headers: {'Accept': 'application/json', 'User-Agent': 'Mozilla/5.0'},
      body: jsonEncode({"id": cartId, "userId": userId, "products": products}),
    );
    log("API ${response.request}\n${response.statusCode}\n${response.body}");

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to update cart");
    }
  }
}
