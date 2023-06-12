class Item {
  String? itemId;
  String? userId;
  String? itemName;
  String? itemType;
  String? itemDesc;
  String? itemPrice;
  String? itemQty;
  String? itemLat;
  String? itemLong;
  String? itemState;
  String? itemLocality;
  String? itemDate;

  Item(
      {this.itemId,
      this.userId,
      this.itemName,
      this.itemType,
      this.itemDesc,
      this.itemPrice,
      this.itemQty,
      this.itemLat,
      this.itemLong,
      this.itemState,
      this.itemLocality,
      this.itemDate});

  Item.fromJson(Map<String, dynamic> json) {
    itemId = json['catch_id'];
    userId = json['user_id'];
    itemName = json['catch_name'];
    itemType = json['catch_type'];
    itemDesc = json['catch_desc'];
    itemPrice = json['catch_price'];
    itemQty = json['catch_qty'];
    itemLat = json['catch_lat'];
    itemLong = json['catch_long'];
    itemState = json['catch_state'];
    itemLocality = json['catch_locality'];
    itemDate = json['catch_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['catch_id'] = itemId;
    data['user_id'] = userId;
    data['catch_name'] = itemName;
    data['catch_type'] = itemType;
    data['catch_desc'] = itemDesc;
    data['catch_price'] = itemPrice;
    data['catch_qty'] = itemQty;
    data['catch_lat'] = itemLat;
    data['catch_long'] = itemLong;
    data['catch_state'] = itemState;
    data['catch_locality'] = itemLocality;
    data['catch_date'] = itemDate;
    return data;
  }
}