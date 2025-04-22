import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medifirst/core/constants/data.dart';
import 'package:medifirst/features/cart_and_checkout/repository/cart_and_checkout_repository.dart';
import 'package:medifirst/models/cart_item.dart';
import 'package:medifirst/models/order_info.dart';
import 'package:medifirst/models/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final cartAndCheckoutControllerProvider =
    Provider<CartAndCheckoutController>((ref) {
  final CartAndCheckoutRepository repo = ref.read(cartAndCheckoutRepoProvider);
  return CartAndCheckoutController(repo: repo);
});

final getUserCartProvider = StreamProvider.family((ref, String userId) {
  final CartAndCheckoutController controller =
      ref.read(cartAndCheckoutControllerProvider);
  return controller.getUserCart(userId);
});

final getCartPriceProvider = StreamProvider.family((ref, String userId) {
  final CartAndCheckoutController controller =
      ref.read(cartAndCheckoutControllerProvider);
  return controller.getCartPrice(userId);
});

final getNumberOfCartItemsProvider =
    StreamProvider.family((ref, String userId) {
  final CartAndCheckoutController controller =
      ref.read(cartAndCheckoutControllerProvider);
  return controller.getNumberOfSelectedCartItems(userId);
});

class CartAndCheckoutController {
  final CartAndCheckoutRepository _repo;
  const CartAndCheckoutController({required CartAndCheckoutRepository repo})
      : _repo = repo;

  Stream<List<CartItem>> getUserCart(String userId) {
    return _repo.getUserCart(userId);
  }

  Stream<int> getCartPrice(String userId) {
    return _repo.getCartPrice(userId);
  }

  Stream<int> getNumberOfSelectedCartItems(String userId) {
    return _repo.getNumberOfSelectedCartItems(userId);
  }

  void incrementItem(String userId, String orderId) async {
    final res = await _repo.incrementItem(orderId, userId);
    res.fold((l) {
      throw (Exception(l.error));
    }, (r) => null);
  }

  void decrementItem(String userId, String orderId) async {
    final res = await _repo.decrementItem(orderId, userId);
    res.fold((l) {
      throw (Exception(l.error));
    }, (r) => null);
  }

  void changePackageUnit(String orderId, String userId, String unit) async {
    final res = await _repo.changePackageUnit(orderId, userId, unit);
    res.fold((l) {
      throw (Exception(l.error));
    }, (r) => null);
  }

  void editInCartStatus(CartItem order, String userId) async {
    final res = await _repo.editInCartStatus(order, userId);
    res.fold((l) {
      throw (Exception(l.error));
    }, (r) => null);
  }

  Future<String> addDeliveryAddress(List<CartItem> cart, String address, bool isPickup, LatLng latlng)async{
    cart.map((e) {
      e = e.copyWith(deliveryAddress: address, isPickup: isPickup);
    });
    if(latlng != LatLng(0, 0)){
      cart.map((e) {
        e = e.copyWith(latitude: latlng.latitude, longitude: latlng.longitude,);
      });
    }
    final res = await _repo.addDeliveryAddress(cart);
    res.fold((l){
      throw Exception('An error occurred');
    }, (r) => null);
    return 'Success';
  }

  Future<void> orderItem(
      CartItem cart, UserInfoModel user, String address, LatLng latLng) async {
    final OrderInfo order = OrderInfo(
      orderId: cart.orderId,
      drugId: cart.drugId,
      customerId: cart.patientId,
      deliveryAddress: address,
      pharmacyId: cart.pharmacyId,
      pharmacyName: cart.pharmacyName,
      brand: cart.brand,
      orderUnit: cart.orderUnit,
      quantity: cart.quantity,
      drugName: cart.drugName,
      customerName: user.name,
      price: cart.price,
      orderStatus: Data.orderStatus[1]!,
      orderDate: Timestamp.fromDate(DateTime.now()),
      dosage: cart.dosage,
      drugImageURL: cart.drugImageURL,
      customerImageURL: user.profilePicture,
      latitude: latLng.latitude,
      longitude: latLng.longitude,
    );
    final res = await _repo.orderItem(order, cart, user.uid);
    res.fold((l){
      throw Exception('An error occurred');
    }, (r) => null);
  }
}
