import 'dart:async';
import 'dart:math';

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
  String? query;

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

      var items =
          (response.data ?? [])
              .where(
                (element) =>
                    query == null ||
                    (element.firstName?.toLowerCase().contains(
                          query?.toLowerCase() ?? '',
                        ) ??
                        false) ||
                    (element.lastName?.toLowerCase().contains(
                          query?.toLowerCase() ?? '',
                        ) ??
                        false),
              )
              .toList();

      final isLastPage = response.page == response.totalPages;
      if (isLastPage) {
        pagingController.appendLastPage(items);
      } else {
        final nextPageKey = (pageKey ?? 1) + 1;
        pagingController.appendPage(items, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = MediaQuery.paddingOf(context);

    return Scaffold(
      floatingActionButton: ImagePickerButton.fab(),
      appBar: UserListScreenAppBar(onSearch: _onSearch),
      body: Column(
        children: [
          Expanded(
            child: Scrollbar(
              child: RefreshIndicator(
                onRefresh: () async => pagingController.refresh(),
                child: PagedListView<int, User>.separated(
                  padding: EdgeInsets.only(
                    left: max(padding.left, padding.right) + 12,
                    right: max(padding.left, padding.right) + 12,
                    top: 16,
                    bottom: padding.bottom + 12,
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

  void _onSearch(String query) {
    this.query = query;

    pagingController.refresh();
  }
}

class UserListScreenAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  const UserListScreenAppBar({required this.onSearch, super.key});

  final void Function(String query) onSearch;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  State<UserListScreenAppBar> createState() => _UserListScreenAppBarState();
}

class _UserListScreenAppBarState extends State<UserListScreenAppBar> {
  bool _showSearchBar = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppBar(title: Text('Usuarios')),
        Positioned(
          bottom: 0,
          right: 8,
          child: IconButton(
            tooltip: 'Buscar',
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _showSearchBar = !_showSearchBar;
              });
            },
          ),
        ),
        Positioned(
          top: MediaQuery.paddingOf(context).top,
          left: 0,
          right: 0,
          bottom: 0,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 100),

            child:
                _showSearchBar
                    ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      width: double.infinity,
                      height: kToolbarHeight,
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.white
                                : Colors.black,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 6),
                          Expanded(
                            child: TextField(
                              onChanged: widget.onSearch,
                              autofocus: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed:
                                () => setState(() {
                                  _showSearchBar = !_showSearchBar;
                                  widget.onSearch('');
                                }),
                            icon: Icon(Icons.cancel_outlined),
                          ),
                        ],
                      ),
                    )
                    : null,
          ),
        ),
      ],
    );
  }
}
