import 'package:bloc_examples/products/models/product_model.dart';

enum ProductStatus { initial, success, failure }

class ProductState {
  final ProductStatus status;
  final List<ProductModel> products;
  final bool hasReachedMax;

  ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.hasReachedMax = false,
  });

  ProductState copyWith({
    ProductStatus? status,
    List<ProductModel>? products,
    bool? hasReachedMax,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
