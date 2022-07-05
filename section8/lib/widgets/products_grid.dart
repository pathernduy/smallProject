import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:section8/providers/products_provider.dart';

import '../providers/product.dart';
import 'product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavs;
  ProductGrid(this.showFavs);


  
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavs ? productsData.favoritesItems : productsData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            child: ProductItem(
                // products[i].id, products[i].title, products[i].imageUrl
                ),
            value: products[i]));
  }
}
