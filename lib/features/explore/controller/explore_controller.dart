import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter__clone/apis/user_api.dart';
import 'package:twitter__clone/models/user_model.dart';

final exploreControllerProvider = StateNotifierProvider((ref) {
  return ExploreController(userApi: ref.watch(userApiProvider));
});

final searchUserProvider = FutureProvider.family((ref, String name) async {
  final exploreController = ref.watch(exploreControllerProvider.notifier);
  return exploreController.searchUser(name);
});

class ExploreController extends StateNotifier<bool> {
  final UserApi _userApi;
  ExploreController({
    required UserApi userApi,
  })  : _userApi = userApi,
        super(false);

  Future<List<UserModel>> searchUser(String name) async {
    final users = await _userApi.searchUserByName(name);
    return users.map((user) => UserModel.fromMap(user.data)).toList();
  }
}
