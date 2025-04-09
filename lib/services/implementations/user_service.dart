import 'package:connectivity_plus/connectivity_plus.dart';

import '../../helpers/app_http_client.dart';
import '../../main.dart';
import '../../models/api_response.dart';
import '../../models/cache_record.dart';
import '../../models/user.dart';
import '../../objectbox.g.dart';
import '../contracts/user_service_contract.dart';

final class UserService implements UserServiceContract {
  @override
  Future<ApiResponse<List<User>>?> fetchUsers([int page = 1]) async {
    List<ConnectivityResult> currentConnectivity =
        await Connectivity().checkConnectivity();

    bool isConnected = [
      ConnectivityResult.wifi,
      ConnectivityResult.mobile,
    ].any((element) => currentConnectivity.contains(element));

    ApiResponse<List<User>>? response;

    if (isConnected) {
      response = await AppHttpClient.instance.request(
        requestMethod: RequestMethod.get,
        url: '/users?page=$page',
        responseParser:
            (response) => ApiResponse.transform(
              response as Map<String, dynamic>,
              (data) =>
                  (data as List?)?.map((e) => User.fromJson(e)).toList() ?? [],
            ),
      );
    } else {
      List<User> items = await retrieveUsers();
      CacheRecord? cacheRecord =
          objectbox.store
              .box<CacheRecord>()
              .query(CacheRecord_.url.equals('/users'))
              .build()
              .findFirst();
      response = ApiResponse(
        page: 1,
        totalPages: 1,
        perPage: items.length,
        total: items.length,
        data: items,
        cached: true,
        cacheDate: cacheRecord?.date,
      );
    }

    if (isConnected && response?.data != null) {
      persistUsers(response!.data!);
      objectbox.store.box<CacheRecord>().put(
        CacheRecord(url: '/users', date: DateTime.now()),
      );
    }

    return response;
  }

  @override
  Future<bool> persistUsers(Iterable<User> users) async {
    var ids = await objectbox.store.box<User>().putManyAsync(
      users.toList(),
      mode: PutMode.put,
    );

    return ids.isNotEmpty;
  }

  @override
  Future<List<User>> retrieveUsers() async {
    return await objectbox.store.box<User>().getAllAsync();
  }
}
