import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
@RoutePage()
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, this.title = 'Placeholder'});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title));
  }
}
