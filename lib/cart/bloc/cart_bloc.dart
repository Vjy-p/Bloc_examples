import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_examples/cart/bloc/cart_event.dart';
import 'package:bloc_examples/cart/bloc/cart_state.dart';
import 'package:bloc_examples/cart/data/cart_services.dart';
import 'package:bloc_examples/products/models/product_model.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartServices api = CartServices();

  CartBloc() : super(CartState()) {
    on<CreateCart>(_createCart);
    on<UpdateProduct>(_updateProduct);
    on<ClearCart>(_clearCart);
  }

  Future<void> _createCart(CreateCart event, Emitter<CartState> emit) async {
    try {
      List<ProductModel>? resp = await api.getCart();
      log("get cart $resp");
      if (resp == null) {
        bool? createResp = await api.createCart();
        List<ProductModel>? prods = await api.getCart();
        if (prods != null && prods.isNotEmpty == true && createResp == true) {
          emit(
            state.copyWith(
              status: CartStatus.success,
              cartProducts: List.from(prods),
            ),
          );
        } else {
          // emit(state.copyWith(status: CartStatus.failure));
        }
      }
      emit(state.copyWith(status: CartStatus.success));
    } catch (e) {
      // emit(state.copyWith(status: CartStatus.failure));
      emit(state.copyWith(status: CartStatus.success));
    }
  }

  Future<void> _updateProduct(
    UpdateProduct event,
    Emitter<CartState> emit,
  ) async {
    // if (state.status == CartStatus.loading) return;

    try {
      log("update cart starts ${event.quantity} ${event.id} ${event.product}");
      emit(state.copyWith(status: CartStatus.loading));

      List<ProductModel> products = List.from(state.cartProducts);
      int index = products.indexWhere((e) => e.id == event.id);
      double totalPrice = 0;

      log("update cart index $index");
      if (index != -1) {
        if (event.quantity <= 0) {
          products.removeAt(index);
        } else {
          products[index].quantity = event.quantity;
        }
      } else {
        ProductModel prod = event.product;
        products.add(prod);
      }

      // await api.updateCart(products: products);

      for (ProductModel p in products) {
        totalPrice += p.quantity * (p.price ?? 0);
      }
      totalPrice = double.parse(totalPrice.toStringAsFixed(2));

      emit(
        state.copyWith(
          status: CartStatus.success,
          cartProducts: List.from(products),
          totalPrice: totalPrice,
        ),
      );
      log("cart updated ${state.cartProducts.length} ${products.length}");
    } catch (e) {
      log("Error update cart $e");
      emit(state.copyWith(status: CartStatus.failure));
    }
  }

  Future<void> _clearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      emit(state.copyWith(status: CartStatus.success, cartProducts: []));
    } catch (e) {
      emit(state.copyWith(status: CartStatus.failure));
    }
  }
}
