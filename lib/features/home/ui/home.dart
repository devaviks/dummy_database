import 'dart:convert';

import 'package:dummy_database/features/home/ui/product_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../database/db_provider.dart';
import '../../cart/ui/cart.dart';
import '../../wishlist/ui/wishlist.dart';
import '../bloc/home_bloc.dart';
import '../models/sample_json.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeBloc homeBloc = HomeBloc();

  @override
  void initState() {
    homeBloc.add(HomeInitialEvent());
    initDatabase();
    super.initState();
  }

  Future<void> initDatabase() async {
    List<Shopping> shoppingList = await readJson();
    homeBloc.add(HomeInitialEvent());
    await DBProvider.db.createProduct(shoppingList);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeNavigateToCartPageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Cart()),
          );
        } else if (state is HomeNavigateToWishlistPageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Wishlist()),
          );
        } else if (state is HomeProductItemCartedActionState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Item is Carted')),
          );
        } else if (state is HomeProductItemWishlistedActionState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Item is Wishlisted')),
          );
        }
      },
      builder: (context, state) {
        if (state is HomeLoadingState) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is HomeLoadedSuccessState) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 65,
              backgroundColor: Colors.white,
              foregroundColor: Colors.indigo,
              elevation: 0,
              leading: Icon(
                Icons.menu,
                color: Colors.indigo,
                size: 24,
              ),
              title: Text(
                'Shopping Cart',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    homeBloc.add(HomeWishlistButtonNavigateEvent());
                  },
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.indigo,
                    size: 24,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    homeBloc.add(HomeCartButtonNavigateEvent());
                  },
                  icon: Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.indigo,
                    size: 24,
                  ),
                ),
              ],
            ),
            body: FutureBuilder<List<Shopping>>(
              future: readJson(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("${snapshot.error}"));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      return ProductTileWidget(
                        product: state.products[index],
                        homeBloc: homeBloc,
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          );
        } else if (state is HomeErrorState) {
          return Scaffold(
            body: Center(child: Text('Error')),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  Future<List<Shopping>> readJson() async {
    try {
      final jsonData = await rootBundle.loadString('assets/test.json');
      if (jsonData != null) {
        Map<String, dynamic> valueMap = json.decode(jsonData);
        List<Shopping> shoppingList = (valueMap['shopping'] as List)
            .map((item) => Shopping.fromJson(item))
            .toList();
        return shoppingList;
      } else {
        throw Exception('Failed to load JSON data');
      }
    } catch (e) {
      throw Exception('Error reading JSON data: $e');
    }
  }
}