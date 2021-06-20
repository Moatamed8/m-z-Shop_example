import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';

import 'package:shop/widgets/user_product_item.dart';

import 'edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product-screen';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName))
        ],
      ),
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProduct(ctx),
                    child: Consumer<ProductsProvider>(
                      builder: (ctx, prodData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (_, index) => Column(
                            children: [
                              UserProductItem(
                                prodData.items[index].id,
                                prodData.items[index].title,
                                prodData.items[index].imageUrl,
                              ),
                              Divider(),

                            ],

                          ),
                          itemCount: prodData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
