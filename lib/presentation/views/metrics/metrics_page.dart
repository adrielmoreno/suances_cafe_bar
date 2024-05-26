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
    return Scaffold(
      extendBody: true,
      body: Center(
        child: SizedBox.expand(
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 1,
            maxScale: 3,
            child: InteractiveViewer(
              child: Image.asset("assets/images/suances.png"),
            ),
          ),
        ),
      ),
    );
  }
}
