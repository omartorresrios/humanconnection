import 'package:flutter/material.dart';
import '../models/user.dart';

class ExplorerProfileView extends StatelessWidget {
  final User user;

  const ExplorerProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          bottom: true,
          child: Column(children: [
            Center(
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
            const SizedBox(height: 8),
            Center(
              child: Text(user.fullname, textAlign: TextAlign.justify),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text("Massachusets, MC"),
            ),
            const SizedBox(height: 20),
            Align(
                child: Text(
                    "I'm working in the intersection of convolutional networks and philosphy of mind. Currently at the department of Engineering at MIT."))
          ]),
        ));
  }
}
