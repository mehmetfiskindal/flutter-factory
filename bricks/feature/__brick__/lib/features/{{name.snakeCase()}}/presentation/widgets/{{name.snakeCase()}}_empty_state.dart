import 'package:flutter/material.dart';

final class {{name.pascalCase()}}EmptyState extends StatelessWidget {
  const {{name.pascalCase()}}EmptyState({
    super.key,
    this.message = 'No {{name.titleCase()}} data found.',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
      ),
    );
  }
}
