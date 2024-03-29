import 'package:flutter/material.dart';
import '../widgets/product_item.dart';
import '../providers/products_provider.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {

  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = (showFavs) ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3/2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0
      ),

      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(
          // products[i].id, 
          // products[i].title, 
          // products[i].imageUrl
        )
      )
    );  
  }
}