import 'package:bloc_examples/cart/bloc/cart_bloc.dart';
import 'package:bloc_examples/cart/bloc/cart_event.dart';
import 'package:bloc_examples/cart/bloc/cart_state.dart';
import 'package:bloc_examples/cart/views/cart_screen.dart';
import 'package:bloc_examples/products/bloc/product_event.dart';
import 'package:bloc_examples/products/bloc/product_state.dart';
import 'package:bloc_examples/products/bloc/products_bloc.dart';
import 'package:bloc_examples/products/models/product_model.dart';
import 'package:bloc_examples/products/views/product_details_screen.dart';
import 'package:bloc_examples/utils/colors.dart';
import 'package:bloc_examples/utils/cuatom_button.dart';
import 'package:bloc_examples/utils/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:paginated_list/paginated_list.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsBloc>().add(FetchProduct());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        surfaceTintColor: kBgColor,
        title: customText(
          text: "Products",
          color: kTextSecondaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        actionsPadding: EdgeInsets.only(right: 10),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => CartScreen()));
            },
            icon: Icon(Icons.shopping_basket_outlined, color: kGreyColor),
          ),
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductState>(
        builder: (context, state) {
          if (state.status == ProductStatus.failure) {
            return Center(
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customText(
                    text: "Something went wrong!",
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: kGreyColor,
                  ),
                  customButton(
                    text: "Retry",
                    onTap: () {
                      context.read<ProductsBloc>().add(FetchProduct());
                    },
                  ),
                ],
              ),
            );
          }

          if (state.status == ProductStatus.initial) {
            return Center(child: CircularProgressIndicator());
          }

          return PaginatedList(
            items: state.products,
            physics: AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            clipBehavior: Clip.none,
            isLastPage: state.hasReachedMax,
            isRecentSearch: false,
            loadingIndicator: Padding(
              padding: EdgeInsetsGeometry.all(20),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            onLoadMore: (index) {
              context.read<ProductsBloc>().add(FetchProduct());
            },
            builder: (conxt, index) {
              if (index >= state.products.length) {
                return Center(child: CircularProgressIndicator());
                // return Center(child: SizedBox());
              }
              final product = state.products[index];

              return productTile(product: product);
            },
          );
        },
      ),
    );
  }

  Widget productTile({required ProductModel product}) {
    CartState state = context.watch<CartBloc>().state;

    List<ProductModel> cartProducts = List.from(state.cartProducts);
    int index = cartProducts.indexWhere((element) => element.id == product.id);
    int quantity = 0;
    if (index != -1) {
      quantity = cartProducts[index].quantity;
    } else {
      quantity = 0;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MaterialButton(
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
        child: Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              // child: CarouselView.builder(
              //   itemExtent: 200,
              //   itemBuilder: (context, index) {
              //     return CachedNetworkImage(
              //       imageUrl: product.images[index],
              //     );
              //   },
              // ),
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
                  ),
                  customText(
                    text: product.brand ?? "",
                    maxLines: 1,
                    color: kTextColor.withValues(alpha: 0.9),
                  ),
                  Row(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      customText(
                        text:
                            "${product.discountPercentage?.toString() ?? ""}%",
                        maxLines: 1,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: kTextColor,
                      ),
                      customText(
                        text: product.price?.toString() ?? "",
                        maxLines: 1,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: kTextColor,
                      ),
                    ],
                  ),
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RatingBarIndicator(
                        rating: product.rating ?? 0,
                        itemSize: 16,
                        itemBuilder: (context, _) => Icon(
                          Icons.star_rounded,
                          color: kAmberColor.withValues(alpha: 0.7),
                        ),
                      ),
                      Spacer(),
                      if (quantity <= 0)
                        MaterialButton(
                          height: 24,
                          minWidth: 40,
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          onPressed: state.status == CartStatus.loading
                              ? null
                              : () {
                                  if (product.id != null) {
                                    context.read<CartBloc>().add(
                                      UpdateProduct(product.id!, product, 1),
                                    );
                                  }
                                },
                          shape: CircleBorder(),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          child: Icon(
                            Icons.shopping_cart_checkout_rounded,
                            color: kBlackColor,
                            size: 18,
                          ),
                        )
                      else
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
                                onPressed: state.status == CartStatus.loading
                                    ? null
                                    : () {
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
                                onPressed: state.status == CartStatus.loading
                                    ? null
                                    : () {
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
