import 'package:code/models/user_model.dart';

abstract class BaseUserReposiotry {
  Future<User> getUserWithId({required String userId});
  Future<void> updateUser({required User user});
  Future<bool> usernameExists({required String query});
}
