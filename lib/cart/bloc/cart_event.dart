import 'package:bloc_examples/products/models/product_model.dart';

abstract class CartEvent {}

class CreateCart extends CartEvent {}

class UpdateProduct extends CartEvent {
  final int id;
  final ProductModel product;
  final int quantity;

  UpdateProduct(this.id, this.product, this.quantity);
}

class ClearCart extends CartEvent {}
