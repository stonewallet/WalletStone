class TripEditResponse {
  String? message;
  Data? data;

  TripEditResponse({this.message, this.data});

  TripEditResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? tripName;
  List<Product>? product;
  List<Expenses>? expenses;
  String? createdAt;

  Data({this.id, this.tripName, this.product, this.expenses, this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tripName = json['trip_name'];
    if (json['product'] != null) {
      product = <Product>[];
      json['product'].forEach((v) {
        product!.add(Product.fromJson(v));
      });
    }
    if (json['expenses'] != null) {
      expenses = <Expenses>[];
      json['expenses'].forEach((v) {
        expenses!.add(Expenses.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['trip_name'] = tripName;
    if (product != null) {
      data['product'] = product!.map((v) => v.toJson()).toList();
    }
    if (expenses != null) {
      data['expenses'] = expenses!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    return data;
  }
}

class Product {
  String? productName;
  int? quantity;
  int? pricePaid;
  int? priceSold;
  int? totalPricePaid;
  int? totalPriceSold;

  Product(
      {this.productName,
        this.quantity,
        this.pricePaid,
        this.priceSold,
        this.totalPricePaid,
        this.totalPriceSold});

  Product.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    quantity = json['quantity'];
    pricePaid = json['price_paid'];
    priceSold = json['price_sold'];
    totalPricePaid = json['total_price_paid'];
    totalPriceSold = json['total_price_sold'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_name'] = productName;
    data['quantity'] = quantity;
    data['price_paid'] = pricePaid;
    data['price_sold'] = priceSold;
    data['total_price_paid'] = totalPricePaid;
    data['total_price_sold'] = totalPriceSold;
    return data;
  }
}

class Expenses {
  String? expenseName;
  int? expenseAmount;

  Expenses({this.expenseName, this.expenseAmount});

  Expenses.fromJson(Map<String, dynamic> json) {
    expenseName = json['expense_name'];
    expenseAmount = json['expense_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expense_name'] = expenseName;
    data['expense_amount'] = expenseAmount;
    return data;
  }
}
