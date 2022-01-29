import 'package:flutter/material.dart';

mixin ErrorHandling {
  showError(BuildContext context, String error) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    });
  }
}
