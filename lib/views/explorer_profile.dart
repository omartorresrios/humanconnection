import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ExplorerProfileView extends StatelessWidget {
  final User user;

  const ExplorerProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                const Spacer(),
                TextButton(
                  style: TextButton.styleFrom(overlayColor: Colors.transparent),
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.profilePicture),
            ),
            const SizedBox(height: 20),
            TextField(
              readOnly: true,
              controller: TextEditingController(text: user.fullname),
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  border: OutlineInputBorder(),
                  fillColor: Colors.transparent,
                  filled: true),
              minLines: 1,
              maxLines: 1,
            ),
            const SizedBox(height: 20),
            TextField(
              readOnly: true,
              controller: TextEditingController(text: user.city),
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  border: OutlineInputBorder(),
                  fillColor: Colors.transparent,
                  filled: true),
              minLines: 1,
              maxLines: 1,
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              child: TextField(
                readOnly: true,
                controller: TextEditingController(text: user.bio),
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    border: OutlineInputBorder(),
                    fillColor: Colors.transparent,
                    filled: true),
                minLines: 1,
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
