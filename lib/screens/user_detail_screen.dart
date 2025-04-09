import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';

import '../models/user.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen(this.user, {super.key});

  final User user;

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late ScrollController scrollController;
  String filler = lorem(paragraphs: 5, words: 300);

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    scrollController.addListener(() => setState(() {}));
  }

  double get expandedHeight => MediaQuery.sizeOf(context).height / 4;

  double get flexibleSpaceExpandedHeightOffset =>
      expandedHeight - kToolbarHeight;

  double get expectedOpacity => max(
    flexibleSpaceExpandedHeightOffset -
        (scrollController.hasClients ? scrollController.offset : 0),
    0,
  );

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: false,
            stretch: true,
            floating: false,
            expandedHeight: expandedHeight,
            title: Opacity(
              opacity: clampDouble(
                1 - (expectedOpacity / flexibleSpaceExpandedHeightOffset),
                0,
                1,
              ),
              child: Text(
                '${widget.user.firstName ?? ''} ${widget.user.lastName ?? ''}'
                    .trim(),
              ),
            ),

            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
                    child: SizedBox.expand(
                      child: CachedNetworkImage(
                        imageUrl: widget.user.avatar ?? '',
                        fit: BoxFit.cover,
                        color:
                            theme.brightness == Brightness.light
                                ? Colors.white.withAlpha(100)
                                : Colors.black.withAlpha(120),
                        colorBlendMode:
                            theme.brightness == Brightness.light
                                ? BlendMode.colorDodge
                                : BlendMode.multiply,
                        errorWidget:
                            (context, url, error) => Icon(Icons.person_outline),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 16,
                    child: Row(
                      children: [
                        Hero(
                          tag: 'avatar_image_${widget.user.id}',
                          child: Container(
                            width: 96,
                            height: 96,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(
                                BorderSide(color: Colors.white, width: 2),
                              ),
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: widget.user.avatar ?? '',
                                fit: BoxFit.cover,
                                errorWidget:
                                    (context, url, error) =>
                                        Icon(Icons.person_outline),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 12),
                        Column(
                          children: [
                            Text(
                              '${widget.user.firstName ?? ''} ${widget.user.lastName ?? ''}'
                                  .trim(),
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(color: Colors.black26, blurRadius: 4),
                                  Shadow(color: Colors.black38, blurRadius: 48),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  widget.user.firstName ?? '',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Nombre',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  widget.user.lastName ?? '',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Apellido',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  widget.user.email ?? '',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Email',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 32),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color:
                        theme.brightness == Brightness.light
                            ? Colors.grey.shade100
                            : Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(filler),
                ),
                SizedBox(height: MediaQuery.paddingOf(context).bottom),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
