import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/features/auth/repository/auth_repository.dart';
import 'package:medifirst/models/doctor_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/constants.dart';
import '../../../models/user_info.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final repo = ref.read(authRepoProvider);
  return AuthController(repo: repo, ref: ref);
});

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final uidProvider = StateProvider<String?>((ref) => null);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _repo;
  final Ref _ref;

  AuthController({required AuthRepository repo, required Ref ref})
      : _repo = repo,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _repo.authStateChange;

  Stream<UserInfoModel> getUserData(String uid) {
    return _repo.getUserData(uid);
  }

  Future<void> updateUserState() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String category = prefs.getString(Constants.appTypeKey)!;
      switch (category) {
        case Constants.patientCategory:
          final user = await _repo.getUserDetails();
          _ref.read(userProvider.notifier).update(user);
          break;
        case Constants.doctorCategory:
          final doctor = await _repo.getDoctorDetails();
          _ref.read(doctorProvider.notifier).update(doctor);
          break;
      }
    } catch (e, st) {
      throw e.toString();
    }
  }

  Future<void> updateUserInfo(String uid) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String category = prefs.getString(Constants.appTypeKey)!;
      switch (category) {
        case Constants.patientCategory:
          final user = await _repo.getUserInfo(uid);
          _ref.read(userProvider.notifier).update(user);
          break;
        case Constants.doctorCategory:
          final doctor = await _repo.getDoctorInfo(uid);
          _ref.read(doctorProvider.notifier).update(doctor);
          break;
      }
    } catch (e, st) {
      // print('${e.toString()} ${st.toString()}');
      throw e.toString();
    }
  }

  Future<void> signOut() async {
    try {
      await _repo.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> registerWithEmail(
      String name, String surname, String email, String password,
      {String? license,
      int? experience,
      String? expertise,
      DateTime? licenseExpiration}) async {
    try {
      final res = await _repo.registerUserWithEmail(
          email: email,
          password: password,
          name: name,
          surname: surname,
          license: license,
          expertise: expertise,
          experience: experience,
          licenseExpiration: licenseExpiration);
      res.fold((l) {
        throw Exception(l.error);
      }, (r) async {
        await updateUserState();
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loginUserWithEmail(
      {required String email, required String password}) async {
    try {
      final res =
          await _repo.loginUserWithEmail(email: email, password: password);
      await updateUserState();
      res.fold((l) {
        throw Exception(l.error);
      }, (r) async {});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> registerWithGoogle(
      {String? license,
      int? experience,
      String? expertise,
      DateTime? licenseExpiration}) async {
    try {
      final res = await _repo.signInWithGoogle(
          license: license,
          experience: experience,
          expertise: expertise,
          licenseExpiration: licenseExpiration);
      res.fold((l) => throw (Exception(l.error)), (r) async {
        await updateUserState();
      });
    } catch (e) {
      print('exception in registerWithGoogle $e');
      rethrow;
    }
  }
}

class UserNotifier extends StateNotifier<UserInfoModel?> {
  UserNotifier() : super(null);

  void update(UserInfoModel user) {
    state = user;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserInfoModel?>(
    (ref) => UserNotifier());

class DoctorNotifier extends StateNotifier<DoctorInfo?> {
  DoctorNotifier() : super(null);

  void update(DoctorInfo doctor) {
    state = doctor;
  }
}

final doctorProvider = StateNotifierProvider<DoctorNotifier, DoctorInfo?>(
    (ref) => DoctorNotifier());
