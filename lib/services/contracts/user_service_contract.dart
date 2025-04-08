import '../../models/user.dart';

abstract class UserServiceContract {
  Future<List<User>?> fetchUsers([int page = 1]);
}
