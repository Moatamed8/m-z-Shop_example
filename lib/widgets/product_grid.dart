import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/config/size_config.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/widgets/product_item.dart';
import 'package:shop/widgets/section_title.dart';

import '../screens/all_products.dart';

class ProductGrid extends StatelessWidget {
  final bool showsfavs;

  const ProductGrid(this.showsfavs);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final productDate = Provider.of<ProductsProvider>(context);
    final products = showsfavs ? productDate.favoritesItems : productDate.items;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenHeight(20)),
            child: SectionTitle(
                title: showsfavs ? "Favorites Products" : "All Products",
                press: () =>
                    Navigator.pushNamed(context, AllProducts.routeName)),
          ),
          products.isEmpty ? Text("There is no product!"):GridView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: products.length<=4?products.length:4,
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                    value: products[i],
                    child: ProductItem(),
                  ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 2.5,
                  crossAxisSpacing: 10)),
        ],
      ),
    );
  }
}
