import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/widgets/home/special_offers.dart';
import 'package:shop/widgets/icon_btn_with_counter.dart';
import 'package:shop/widgets/product_grid.dart';

import 'package:shop/widgets/search_field.dart';
import '../config/size_config.dart';
import '../config/enums.dart';
import '../widgets/home/discount_banner.dart';
import '../widgets/home/categories.dart';

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/productoverview-screen';

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isLoading = false;
  var _showOnlyFavorites = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;
    Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) => setState(() => _isLoading = false))
        .catchError((error) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(20.0)),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SearchField(),
                    Consumer<CartProvider>(
                      builder: (_, cart, ch) => IconBtnWithCounter(
                        svgSrc: "assets/icons/Cart Icon.svg",
                        numOfitem: cart.itemCount,
                        press: () =>
                            Navigator.pushNamed(context, CartScreen.routeName),
                      ),
                    ),
                    PopupMenuButton(
                      onSelected: (FilterOption selectedVal) {
                        setState(() {
                          if (selectedVal == FilterOption.Favourite) {
                            _showOnlyFavorites = true;
                          } else {
                            _showOnlyFavorites = false;
                          }
                        });
                      },
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          child: Text('Only Favourite'),
                          value: FilterOption.Favourite,
                        ),
                        PopupMenuItem(
                            child: Text('All'), value: FilterOption.All)
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: getProportionateScreenWidth(10)),
              DiscountBanner(),
              Categories(),
              SpecialOffers(),
              _isLoading
                  ? CircularProgressIndicator()
                  : ProductGrid(_showOnlyFavorites)
            ],
          ),
        ),
      ),
/*
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
*/
    );
  }
}
