import 'package:flutter/material.dart';

class MetricsPage extends StatefulWidget {
  const MetricsPage({
    super.key,
  });

  static const route = '/metrics_page';

  @override
  State<MetricsPage> createState() => _MetricsPageState();
}

class _MetricsPageState extends State<MetricsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBody: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              MetricsPage.route,
            ),
          ],
        ),
      ),
    );
  }
}
