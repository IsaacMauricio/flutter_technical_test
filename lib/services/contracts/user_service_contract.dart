import '../../models/api_response.dart';
import '../../models/user.dart';

abstract class UserServiceContract {
  Future<ApiResponse<List<User>>?> fetchUsers([int page = 1]);
}
