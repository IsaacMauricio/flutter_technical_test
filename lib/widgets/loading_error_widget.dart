import 'package:flutter/material.dart';

class LoadingErrorWidget extends StatelessWidget {
  const LoadingErrorWidget({this.onRetry, super.key});

  final void Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 256),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            Text(
              'Ocurrió un error cargando la información. Por favor intente de nuevo',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            if (onRetry != null) ...[
              SizedBox(height: 8),
              ElevatedButton(onPressed: onRetry, child: Text('Reintentar')),
            ],
          ],
        ),
      ),
    );
  }
}
