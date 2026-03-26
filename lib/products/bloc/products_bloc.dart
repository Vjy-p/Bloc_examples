import 'dart:developer';

import 'package:bloc_examples/products/bloc/product_event.dart';
import 'package:bloc_examples/products/bloc/product_state.dart';
import 'package:bloc_examples/products/data/product_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsBloc extends Bloc<ProductEvent, ProductState> {
  final ProductServices api = ProductServices();
  static const int _limit = 10;

  ProductsBloc() : super(ProductState()) {
    on<FetchProduct>(_onFetchProduct);
  }

  Future<void> _onFetchProduct(
    FetchProduct event,
    Emitter<ProductState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == ProductStatus.initial) {
        final products = await api.fetchProducts(0, _limit);

        return emit(
          state.copyWith(
            status: ProductStatus.success,
            products: products,
            hasReachedMax: products.length < _limit,
          ),
        );
      } else {
        final start = (state.products.length / _limit).ceil();

        final products = await api.fetchProducts(start, _limit);
        emit(
          products.isEmpty
              ? state.copyWith(hasReachedMax: true)
              : state.copyWith(
                  status: ProductStatus.success,
                  products: List.of(state.products)..addAll(products),
                  hasReachedMax: products.length < _limit,
                ),
        );
      }
    } catch (e) {
      log("product error $e");
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }
}
