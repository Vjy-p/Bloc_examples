import 'package:bloc_examples/cart/bloc/cart_bloc.dart';
import 'package:bloc_examples/cart/bloc/cart_event.dart';
import 'package:bloc_examples/cart/bloc/cart_state.dart';
import 'package:bloc_examples/products/models/product_model.dart';
import 'package:bloc_examples/utils/colors.dart';
import 'package:bloc_examples/utils/cuatom_button.dart';
import 'package:bloc_examples/utils/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});
  final ProductModel product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  List<ProductModel> cartProducts = [];
  int quantity = 0;

  @override
  void initState() {
    super.initState();
    // cartProducts = List.from(context.read<CartBloc>().state.cartProducts);
    // int index = cartProducts.indexWhere(
    //   (element) => element.id == widget.product.id,
    // );

    // if (index != -1) {
    //   quantity = cartProducts[index].quantity;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kBgColor,
        appBar: AppBar(
          backgroundColor: kBgColor,
          surfaceTintColor: kBgColor,
          title: customText(
            text: "Product Details",
            fontSize: 20,
            color: kTextSecondaryColor,
            fontWeight: FontWeight.w700,
          ),
          bottom: TabBar(
            unselectedLabelColor: kGreyColor,
            labelColor: kTextSecondaryColor,
            labelStyle: customTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: customTextStyle(fontSize: 16),
            indicatorColor: kTextSecondaryColor,
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: "Info"),
              Tab(text: "Reviews"),
            ],
          ),
        ),
        body: TabBarView(children: [infoWidget(), reviewsWidget()]),
        bottomNavigationBar: BottomAppBar(
          color: kGreyColor,
          height: 50,
          padding: EdgeInsets.fromLTRB(16, 2, 16, 2),
          child: cartButton(),
        ),
      ),
    );
  }

  Widget infoWidget() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      physics: BouncingScrollPhysics(),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: EdgeInsets.zero,
            color: kGreyColor.withValues(alpha: 0.6),
            child: Container(
              height: 200,
              alignment: Alignment.center,
              child: CarouselView.weightedBuilder(
                itemCount: widget.product.images.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: widget.product.images[index],
                  );
                },
                flexWeights: [3, 2, 1],
              ),
            ),
          ),
          customText(
            text: widget.product.title ?? "",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kTextWhiteColor,
          ),
          customText(
            text: widget.product.brand ?? "",
            color: kTextWhiteColor.withValues(alpha: 0.9),
          ),
          Row(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              customText(
                text: "${widget.product.discountPercentage?.toString() ?? ""}%",
                maxLines: 1,
                fontWeight: FontWeight.w600,
                color: kTextWhiteColor,
              ),
              customText(
                text: widget.product.price?.toString() ?? "",
                maxLines: 1,
                fontWeight: FontWeight.w600,
                color: kTextWhiteColor,
              ),
            ],
          ),
          RatingBarIndicator(
            rating: widget.product.rating ?? 0,
            itemSize: 16,
            itemBuilder: (context, _) => Icon(
              Icons.star_rounded,
              color: kAmberColor.withValues(alpha: 0.7),
            ),
          ),
          customText(
            text: widget.product.category ?? "",
            fontWeight: FontWeight.w400,
            color: kTextWhiteColor,
          ),
          customText(
            text: widget.product.availabilityStatus ?? "",
            fontWeight: FontWeight.w400,
            color: kTextWhiteColor,
          ),
          customText(
            text: widget.product.shippingInformation ?? "",
            fontWeight: FontWeight.w400,
            color: kTextWhiteColor,
          ),
          customText(
            text: widget.product.description ?? "",
            fontWeight: FontWeight.w400,
            color: kTextWhiteColor,
          ),
          customText(
            text: widget.product.returnPolicy ?? "",
            fontWeight: FontWeight.w400,
            color: kTextWhiteColor,
          ),
          customText(
            text: widget.product.warrantyInformation ?? "",
            fontWeight: FontWeight.w400,
            color: kTextWhiteColor,
          ),
        ],
      ),
    );
  }

  Widget reviewsWidget() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: widget.product.reviews.length,
      padding: EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.zero,
          color: kCardColor,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              spacing: 6,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: customText(
                        text: widget.product.reviews[index].reviewerName ?? "",
                        maxLines: 2,
                        fontSize: 12,
                        color: kTextColor,
                      ),
                    ),
                    if (widget.product.reviews[index].date != null)
                      customText(
                        text: DateFormat(
                          "M/d/y",
                        ).format(widget.product.reviews[index].date!),
                        fontSize: 12,
                        color: kTextSecondaryColor,
                      ),
                  ],
                ),
                customText(
                  text: widget.product.reviews[index].comment ?? "",
                  fontWeight: FontWeight.w400,
                  color: kTextColor,
                ),
                Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: RatingBarIndicator(
                    rating: widget.product.rating ?? 0,
                    itemSize: 16,
                    itemBuilder: (context, _) =>
                        Icon(Icons.star_rounded, color: kAmberColor),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 12);
      },
    );
  }

  Widget cartButton() {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        cartProducts = List.from(state.cartProducts);
        int index = cartProducts.indexWhere(
          (element) => element.id == widget.product.id,
        );

        if (index != -1) {
          quantity = cartProducts[index].quantity;
        } else {
          quantity = 0;
        }
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (mounted) setState(() {});
        });

        return state.status == CartStatus.loading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(),
                  ),
                ],
              )
            : quantity <= 0
            ? customButton(
                onTap: state.status == CartStatus.loading
                    ? null
                    : () {
                        if (widget.product.id != null) {
                          context.read<CartBloc>().add(
                            UpdateProduct(
                              widget.product.id!,
                              widget.product,
                              1,
                            ),
                          );
                        }
                      },

                text: "Add To Cart",
                fontStyle: FontStyle.italic,
                icon: Icon(
                  Icons.shopping_cart_checkout_rounded,
                  color: kTextColor,
                  size: 18,
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  color: kBlueAccentColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: Row(
                  spacing: 12,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MaterialButton(
                      // height: 24,
                      minWidth: 24,
                      shape: CircleBorder(),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      onPressed: state.status == CartStatus.loading
                          ? null
                          : () {
                              if (widget.product.id != null) {
                                quantity--;
                                context.read<CartBloc>().add(
                                  UpdateProduct(
                                    widget.product.id!,
                                    widget.product,
                                    quantity,
                                  ),
                                );
                                setState(() {});
                              }
                            },
                      child: Icon(
                        Icons.remove_circle,
                        size: 24,
                        color: kRedAccentColor,
                      ),
                    ),
                    customText(
                      text: quantity.toString(),
                      maxLines: 1,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kTextWhiteColor.withValues(alpha: 0.9),
                    ),
                    MaterialButton(
                      // height: 24,
                      minWidth: 24,
                      shape: CircleBorder(),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      onPressed: state.status == CartStatus.loading
                          ? null
                          : () {
                              if (widget.product.id != null) {
                                quantity++;
                                context.read<CartBloc>().add(
                                  UpdateProduct(
                                    widget.product.id!,
                                    widget.product,
                                    quantity,
                                  ),
                                );
                                setState(() {});
                              }
                            },
                      child: Icon(
                        Icons.add_circle,
                        size: 24,
                        color: kGreenAccentColor,
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
