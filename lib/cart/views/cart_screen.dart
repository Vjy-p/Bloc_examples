import 'package:bloc_examples/cart/bloc/cart_bloc.dart';
import 'package:bloc_examples/cart/bloc/cart_event.dart';
import 'package:bloc_examples/cart/bloc/cart_state.dart';
import 'package:bloc_examples/products/models/product_model.dart';
import 'package:bloc_examples/products/views/product_details_screen.dart';
import 'package:bloc_examples/utils/colors.dart';
import 'package:bloc_examples/utils/cuatom_button.dart';
import 'package:bloc_examples/utils/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(CreateCart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        surfaceTintColor: kBgColor,
        title: customText(
          text: "Cart",
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: kTextSecondaryColor,
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.status == CartStatus.failure) {
            return Center(
              child: customText(
                text: 'Failed to fetch cart products',
                color: kGreyColor,
              ),
            );
          }

          if (state.status == CartStatus.initial) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.separated(
            itemCount: state.cartProducts.length,
            padding: EdgeInsets.all(16),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return cartTile(product: state.cartProducts[index]);
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 12);
            },
          );
        },
      ),
      bottomSheet: BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                customText(text: "Total", color: kTextSecondaryColor),
                customText(
                  text: context.read<CartBloc>().state.totalPrice.toString(),
                  fontWeight: FontWeight.w600,
                  color: kTextColor,
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: customButton(text: "Proceed", onTap: () {}),
      ),
    );
  }

  Widget cartTile({required ProductModel product}) {
    int quantity = product.quantity;
    return MaterialButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.fromLTRB(2.0, 12, 10, 8),
      color: kCardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12),
      ),
      child: IntrinsicHeight(
        child: Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                child: CachedNetworkImage(
                  imageUrl: product.thumbnail ?? "",
                  progressIndicatorBuilder: (context, url, progress) {
                    // debugPrint("image url $url");
                    return SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorWidget: (context, url, error) {
                    // debugPrint("image url error $url\n$error");
                    return Icon(Icons.error);
                  },
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Column(
                spacing: 4,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    text: product.title ?? "",
                    maxLines: 2,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kTextColor,
                  ),
                  customText(
                    text: product.brand ?? "",
                    maxLines: 1,
                    color: kTextColor.withValues(alpha: 0.9),
                  ),
                  Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      customText(
                        text: product.price?.toString() ?? "",
                        maxLines: 1,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: kTextColor.withValues(alpha: 0.9),
                      ),
                      // Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: kBlueAccentColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        child: Row(
                          spacing: 12,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MaterialButton(
                              height: 20,
                              minWidth: 20,
                              shape: CircleBorder(),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                if (product.id != null) {
                                  quantity--;
                                  context.read<CartBloc>().add(
                                    UpdateProduct(
                                      product.id!,
                                      product,
                                      quantity,
                                    ),
                                  );
                                  setState(() {});
                                }
                              },
                              child: Icon(
                                Icons.remove_circle,
                                size: 20,
                                color: kRedAccentColor,
                              ),
                            ),
                            customText(
                              text: product.quantity.toString(),
                              maxLines: 1,
                              fontWeight: FontWeight.w600,
                              color: kTextColor.withValues(alpha: 0.9),
                            ),
                            MaterialButton(
                              height: 20,
                              minWidth: 20,
                              shape: CircleBorder(),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                if (product.id != null) {
                                  quantity++;
                                  context.read<CartBloc>().add(
                                    UpdateProduct(
                                      product.id!,
                                      product,
                                      quantity,
                                    ),
                                  );
                                  setState(() {});
                                }
                              },
                              child: Icon(
                                Icons.add_circle,
                                size: 20,
                                color: kGreenAccentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
