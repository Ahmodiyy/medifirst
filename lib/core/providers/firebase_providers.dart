import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../utils/failure.dart';
import '../utils/type_defs.dart';

final firebaseAuthProvider = Provider((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});

final firebaseStorageProvider = Provider((ref) {
  return FirebaseStorage.instance;
});

final storageRepositoryProvider = Provider((ref) {
  final FirebaseStorage storage = ref.read(firebaseStorageProvider);
  return FirebaseStorageRepository(storage: storage);
});

final googleProvider = Provider((ref) {
  return GoogleSignIn();
});

class FirebaseStorageRepository{
  final FirebaseStorage _storage;
  FirebaseStorageRepository({required FirebaseStorage storage}):_storage = storage;

  FutureEither<String> storeImage({required String path, required String id, required Uint8List file})async{
    try{
      final Reference ref = _storage.ref().child(path).child(id);
      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snap = await uploadTask;
      return right(await snap.ref.getDownloadURL());
    }on FirebaseException catch(e){
      return left(Failure(e.message ?? 'An error occurred'));
    } catch(e){
      return left(Failure('Unexpected error: ${e.toString()}'));
    }
  }
}
