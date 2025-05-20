import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medifirst/core/constants/firebase_constants.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';
import 'package:medifirst/models/cart_item.dart';
import 'package:medifirst/models/order_info.dart';
import 'package:medifirst/models/wallet_info.dart';

import '../../../core/utils/failure.dart';
import '../../../core/utils/type_defs.dart';

final cartAndCheckoutRepoProvider = Provider<CartAndCheckoutRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return CartAndCheckoutRepository(firestore: firestore);
});

class CartAndCheckoutRepository {
  final FirebaseFirestore _firestore;
  CartAndCheckoutRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  CollectionReference get _practices =>
      _firestore.collection(FirebaseConstants.healthcarePracticesCollection);

  CollectionReference get _wallets =>
      _firestore.collection(FirebaseConstants.walletsCollection);

  Stream<List<CartItem>> getUserCart(String userId) {
    return _users
        .doc(userId)
        .collection(FirebaseConstants.cartCollection)
        .snapshots()
        .map((event) {
      return event.docs
          .map(
            (e) => CartItem.fromMap(
              e.data(),
            ),
          )
          .toList();
    });
  }

  Stream<int> getCartPrice(String userId) {
    return _users
        .doc(userId)
        .collection(FirebaseConstants.cartCollection)
        .snapshots()
        .map((event) {
      int price = 0;
      event.docs.map((e) {
        final item = CartItem.fromMap(e.data());
        if (item.inCart) {
          price += item.price;
        }
      });
      return price;
    });
  }

  Stream<int> getNumberOfSelectedCartItems(String userId) {
    return _users
        .doc(userId)
        .collection(FirebaseConstants.cartCollection)
        .snapshots()
        .map((event) {
      int number = 0;
      event.docs.map((e) {
        final item = CartItem.fromMap(e.data());
        if (item.inCart) {
          number++;
        }
      });
      return number;
    });
  }

  FutureVoid incrementItem(String orderId, String userId) async {
    try {
      await _users
          .doc(userId)
          .collection(FirebaseConstants.cartCollection)
          .doc(orderId)
          .update({
        'quantity': FieldValue.increment(1),
      });
      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid decrementItem(String orderId, String userId) async {
    try {
      await _users
          .doc(userId)
          .collection(FirebaseConstants.cartCollection)
          .doc(orderId)
          .update({
        'quantity': FieldValue.increment(-1),
      });
      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid changePackageUnit(
      String orderId, String userId, String unit) async {
    try {
      await _users
          .doc(userId)
          .collection(FirebaseConstants.cartCollection)
          .doc(orderId)
          .update({
        'orderUnit': unit,
      });
      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid editInCartStatus(CartItem order, String userId) async {
    try {
      if (order.inCart) {
        return right(await _users
            .doc(userId)
            .collection(FirebaseConstants.cartCollection)
            .doc(order.orderId)
            .update({
          'inCart': false,
        }));
      } else {
        return right(await _users
            .doc(userId)
            .collection(FirebaseConstants.cartCollection)
            .doc(order.orderId)
            .update({
          'inCart': true,
        }));
      }
      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addDeliveryAddress(List<CartItem> cart)async{
    try{
      for(CartItem item in cart){
        await _users
            .doc(item.patientId)
            .collection(FirebaseConstants.ordersCollection)
            .doc(item.orderId)
            .set(item.toMap());
      }
      return right(null);
    }on FirebaseException catch(e){
      throw e.message!;
    }catch(e){
      return left(Failure('An error occurred'));
    }
  }

  FutureVoid orderItem(OrderInfo order, CartItem cartItem, String userId)async{
    try {
      final snapshot = await _wallets.doc(userId).get();
      WalletInfo wallet = WalletInfo.fromMap(snapshot as Map<String, dynamic>);
      if(wallet.balance > cartItem.price){
        await _wallets.doc(userId).update({
          'balance': FieldValue.increment(cartItem.price * -1),
        });
        await _wallets.doc(order.pharmacyId).update({
          'balance': FieldValue.increment(cartItem.price),
        });
        await _practices
            .doc(order.pharmacyId)
            .collection(FirebaseConstants.ordersCollection)
            .doc(order.orderId)
            .set(order.toMap());
        await _users
            .doc(userId)
            .collection(FirebaseConstants.cartCollection)
            .doc(cartItem.orderId)
            .delete();
        await _users
            .doc(userId)
            .collection(FirebaseConstants.ordersCollection)
            .doc(order.orderId)
            .set(order.toMap());
      }
      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
