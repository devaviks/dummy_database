

import '../features/home/models/home_product_data_model.dart';
import '../features/home/models/wishlist_data_model.dart';

List<ProductDataModel> wishlistItems = [];

class WishlistItems {
  static List<WishlistDataModel> wishlistItems = [];

  static void addToWishlist(WishlistDataModel wishlistData) {
    wishlistItems.add(wishlistData);
  }
}