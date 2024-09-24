import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NoDuesInitiated extends StatefulWidget {
  const NoDuesInitiated({super.key});

  @override
  _NoDuesInitiatedState createState() => _NoDuesInitiatedState();
}

class _NoDuesInitiatedState extends State<NoDuesInitiated> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  const Text("Department Name"),
                  const SizedBox(
                    width: 20,
                  ),
                  const Text("Status")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
