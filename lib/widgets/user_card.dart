import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class UserCard extends StatelessWidget {
  const UserCard(this.user, {super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 4),
        onTap: () {},
        leading: CircleAvatar(
          radius: 32,

          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: user.avatar ?? '',
              errorWidget: (context, url, error) => Icon(Icons.person_outline),
            ),
          ),
        ),
        title: Text(
          '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim(),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(user.email ?? '', style: theme.textTheme.bodyMedium),
      ),
    );
  }
}
