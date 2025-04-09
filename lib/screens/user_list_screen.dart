import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/api_response.dart';
import '../models/user.dart';
import '../services/contracts/user_service_contract.dart';
import '../widgets/connectivity_indicator.dart';
import '../widgets/image_picker_button.dart';
import '../widgets/loading_error_widget.dart';
import '../widgets/no_items_widget.dart';
import '../widgets/user_card.dart';
import 'user_detail_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final UserServiceContract userService =
      GetIt.instance.get<UserServiceContract>();

  late final PagingController<int, User> pagingController;

  @override
  void initState() {
    super.initState();

    pagingController = PagingController<int, User>(firstPageKey: 1);
    pagingController.addPageRequestListener(_fetchItems);
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchItems([int? pageKey]) async {
    try {
      ApiResponse<List<User>>? response = await userService.fetchUsers(
        pageKey ?? 1,
      );
      if (response == null) throw Exception();

      final isLastPage = response.page == response.totalPages;
      if (isLastPage) {
        pagingController.appendLastPage(response.data ?? []);
      } else {
        final nextPageKey = (pageKey ?? 1) + 1;
        pagingController.appendPage(response.data ?? [], nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ImagePickerButton.fab(),
      appBar: AppBar(title: Text('Usuarios')),
      body: Column(
        children: [
          Expanded(
            child: Scrollbar(
              child: RefreshIndicator(
                onRefresh: () async => pagingController.refresh(),
                child: PagedListView<int, User>.separated(
                  padding: EdgeInsets.only(
                    left: 12,
                    right: 12,
                    top: 16,
                    bottom: MediaQuery.paddingOf(context).bottom + 12,
                  ),
                  pagingController: pagingController,
                  separatorBuilder: (context, index) => SizedBox(height: 4),
                  builderDelegate: PagedChildBuilderDelegate(
                    noItemsFoundIndicatorBuilder: (context) => NoItemsWidget(),
                    firstPageErrorIndicatorBuilder:
                        (context) => LoadingErrorWidget(
                          onRetry: () => pagingController.refresh(),
                        ),
                    itemBuilder:
                        (context, item, index) => UserCard(
                          item,
                          onTap:
                              (user) => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => UserDetailScreen(user),
                                ),
                              ),
                        ),
                  ),
                ),
              ),
            ),
          ),
          ConnectivityIndicator(),
        ],
      ),
    );
  }

}
