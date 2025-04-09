import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class UserCard extends StatelessWidget {
  const UserCard(this.user, {this.onTap, super.key});

  final User user;
  final void Function(User user)? onTap;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 4),
        onTap: onTap == null ? null : () => onTap!(user),
        leading: Hero(
          tag: 'avatar_image_${user.id}',
          child: Container(
            width: 64,
            height: 64,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: CachedNetworkImage(
              imageUrl: user.avatar ?? '',
              fit: BoxFit.cover,
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
