import 'package:flutter/material.dart';

import 'chat_view.dart';

class ExplorerDetailsView extends StatefulWidget {
  const ExplorerDetailsView({super.key});

  @override
  State<ExplorerDetailsView> createState() => _ExplorerDetailsViewState();
}

class _ExplorerDetailsViewState extends State<ExplorerDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sam"),
      ),
      body: const Center(
        child: Text("Im exploring this..."),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ChatView()));
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              splashFactory: NoSplash.splashFactory,
              shadowColor: Colors.transparent,
            ),
            child: const Text("Chat")),
      ),
    );
  }
}
