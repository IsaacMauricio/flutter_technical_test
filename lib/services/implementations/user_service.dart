import '../../helpers/app_http_client.dart';
import '../../models/user.dart';
import '../contracts/user_service_contract.dart';

final class UserService implements UserServiceContract {
  @override
  Future<List<User>?> fetchUsers([int page = 1]) {
    return AppHttpClient.instance.request(
      requestMethod: RequestMethod.get,
      url: '/users',
      responseParser: (response) {
        return ((response as Map)['data'] as List)
            .map((e) => User.fromJson(e))
            .toList();
      },
    );
  }
}
