class ShoppingDataModel {
  List<Shopping>? shopping;

  ShoppingDataModel({this.shopping});

  ShoppingDataModel.fromJson(Map<String, dynamic> json) {
    if (json['shopping'] != null) {
      shopping = <Shopping>[];
      json['shopping'].forEach((v) {
        shopping!.add(Shopping.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (shopping != null) {
      data['shopping'] = shopping!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Shopping {
  String? id;
  String? name;
  String? description;
  double? price;
  String? imageUrl;

  Shopping({this.id, this.name, this.description, this.price, this.imageUrl});

  Shopping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price']?.toDouble();
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['imageUrl'] = imageUrl;
    return data;
  }
}
