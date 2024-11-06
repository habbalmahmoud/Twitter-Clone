import 'package:appwrite/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter__clone/apis/auth_api.dart';
import 'package:twitter__clone/apis/user_api.dart';
import 'package:twitter__clone/core/utils.dart';
import 'package:twitter__clone/features/auth/view/login_view.dart';
import 'package:twitter__clone/features/home/view/home_view.dart';
import 'package:twitter__clone/models/user_model.dart';

final authContollerProvider = StateNotifierProvider<AuthContoller, bool>((ref) {
  return AuthContoller(
    authApi: ref.watch(authApiProvider),
    userApi: ref.watch(userApiProvider),
  );
});

final currentUserAccountProvider = FutureProvider((ref) async {
  final authContoller = ref.watch(authContollerProvider.notifier);
  return authContoller.currentUserAccount();
});

class AuthContoller extends StateNotifier<bool> {
  final AuthApi _authApi;
  final UserApi _userApi;
  AuthContoller({
    required AuthApi authApi,
    required UserApi userApi,
  })  : _authApi = authApi,
        _userApi = userApi,
        super(false);

  Future<model.User?> currentUserAccount() => _authApi.currentUserAccount();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authApi.signUp(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        UserModel userModel = UserModel(
          email: email,
          name: getNameFromEmail(email),
          followers: const [],
          following: const [],
          profilePic: '',
          bannerPic: '',
          uid: '',
          bio: '',
          isTwitterBlue: false,
        );
        final res2 = await _userApi.saveUserData(userModel);
        res2.fold((l) => showSnackBar(context, l.message), (_) {
          showSnackBar(context, "Account has been created! Please login.");
          Navigator.push(context, LoginView.route());
        });
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authApi.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        Navigator.push(context, HomeView.route());
      },
    );
  }
}
