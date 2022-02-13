import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeetakeaway/enums/src/order_status.dart';
import 'package:coffeetakeaway/helpers/src/cart_item_total.dart';
import 'package:coffeetakeaway/models/src/cart_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable(explicitToJson: true)
class Order {
  const Order({
    required this.items,
    this.id,
    required this.status,
    required this.userId,
    required this.created,
    required this.updated,
  });

  final List<CartItem> items;
  final OrderStatus status;
  final String? id;
  final String userId;

  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final DateTime created;

  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final DateTime updated;

  bool get isReady => status == OrderStatus.ready;

  num get total => items
      .map(
        (item) => getCartItemTotal(
          count: item.quantity,
          price: item.coffee.price,
          additions: item.additions.length,
          size: item.size.index,
          sugar: item.sugar.index,
        ),
      )
      .reduce((value, element) => value + element);

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  static DateTime _fromJson(Timestamp timestamp) => timestamp.toDate();
  static FieldValue _toJson(DateTime time) => FieldValue.serverTimestamp();
}
