import 'package:flutter/material.dart';
import '../models/exploration.dart';
import '../models/user.dart';
import 'chat_view.dart';
import 'explorer_profile.dart';

class ExplorerDetailsView extends StatefulWidget {
  final Exploration exploration;

  const ExplorerDetailsView({super.key, required this.exploration});

  @override
  State<ExplorerDetailsView> createState() => _ExplorerDetailsViewState();
}

class _ExplorerDetailsViewState extends State<ExplorerDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            width: double.infinity,
            color: Color.fromARGB(255, 104, 68, 100),
            child: Column(children: [
              GestureDetector(
                child: Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 35, 96, 188),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 35,
                    ),
                  ),
                ),
                onTap: () {
                  openExploreProfile(widget.exploration.user);
                },
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    "${widget.exploration.user.fullname} is exploring about ${widget.exploration.text}",
                    textAlign: TextAlign.justify),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Sources"),
              ),
              const SizedBox(height: 8),
              for (var source in widget.exploration.sources) ...[
                Align(
                    alignment: Alignment.centerLeft, child: Text(source.text)),
                const SizedBox(height: 8),
              ],
            ]),
          ),
        ),
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

  void openExploreProfile(User user) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            ExplorerProfileView(user: user),
          ]);
        });
  }
}
