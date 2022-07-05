import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:section8/providers/cart.dart';
import 'package:section8/providers/product.dart';
import 'package:section8/screens/cart_screen.dart';
import 'package:section8/widgets/app_drawer.dart';
import 'package:section8/widgets/badge.dart';

import '../providers/products_provider.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = true;
  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  //const ProductOverviewScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //final productContainer = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('MyShop'),
          actions: <Widget>[
            PopupMenuButton(
                onSelected: (FilterOptions selectedValue) {
                  setState(() {
                    if (selectedValue == FilterOptions.Favorites) {
                      _showOnlyFavorites = true;
                    } else {
                      _showOnlyFavorites = false;
                    }
                  });
                },
                icon: Icon(Icons.more_vert),
                itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text('Only Favorites'),
                        value: FilterOptions.Favorites,
                      ),
                      PopupMenuItem(
                        child: Text('Show All'),
                        value: FilterOptions.All,
                      ),
                    ]),
            Consumer<Cart>(
                builder: (_, cart, ch) => Badge(
                      child: ch as Widget,
                      value: cart.itemCount.toString(),
                    ),
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                ))
          ],
        ),
        drawer: AppDrawer(),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductGrid(_showOnlyFavorites));
  }
}
