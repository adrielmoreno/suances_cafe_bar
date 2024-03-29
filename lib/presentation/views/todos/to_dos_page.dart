import 'package:flutter/material.dart';

class ToDosPage extends StatefulWidget {
  const ToDosPage({
    super.key,
  });

  static const route = '/todos_page';

  @override
  State<ToDosPage> createState() => _ToDosPageState();
}

class _ToDosPageState extends State<ToDosPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBody: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ToDosPage.route,
            ),
          ],
        ),
      ),
    );
  }
}
