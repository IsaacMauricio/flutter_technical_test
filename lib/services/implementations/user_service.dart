import '../../helpers/app_http_client.dart';
import '../../models/api_response.dart';
import '../../models/user.dart';
import '../contracts/user_service_contract.dart';

final class UserService implements UserServiceContract {
  @override
  Future<ApiResponse<List<User>>?> fetchUsers([int page = 1]) async {
    return await AppHttpClient.instance.request(
      requestMethod: RequestMethod.get,
      url: '/users?page=$page',
      responseParser:
          (response) => ApiResponse.transform(
            response as Map<String, dynamic>,
            (data) =>
                (data as List?)?.map((e) => User.fromJson(e)).toList() ?? [],
          ),
    );
  }
}
