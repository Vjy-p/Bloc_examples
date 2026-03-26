import 'package:bloc_examples/products/models/product_model.dart';

enum CartStatus { initial, loading, success, failure }

class CartState {
  CartStatus status;
  List<ProductModel> cartProducts;
  double totalPrice;

  CartState({
    this.status = CartStatus.initial,
    this.cartProducts = const [],
    this.totalPrice = 0,
  });

  CartState copyWith({
    CartStatus? status,
    List<ProductModel>? cartProducts,
    double? totalPrice,
  }) {
    return CartState(
      status: status ?? this.status,
      cartProducts: cartProducts ?? this.cartProducts,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
