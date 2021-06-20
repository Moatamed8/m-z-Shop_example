
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/widgets/product_item.dart';

class FavoriteScreen extends StatelessWidget {
  static const routeName='/favorite-screen';

  @override
  Widget build(BuildContext context) {
    final productDate = Provider.of<ProductsProvider>(context);
    final products = productDate.favoritesItems;
    return  Scaffold(
      appBar: AppBar(
        title: Text("All Favorite"),
      ),
      body: products.isEmpty ? Center(child: Text("There is no Favorite product!")):GridView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: products.length,
          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            value: products[i],
            child: ProductItem(),
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 2.5,
              crossAxisSpacing: 10)),
    );
  }
}
