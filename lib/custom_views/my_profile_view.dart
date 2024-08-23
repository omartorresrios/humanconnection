import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({super.key});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  final fullnameTextEditing = TextEditingController();
  final cityTextEditing = TextEditingController();
  final bioTextEditing = TextEditingController();

  @override
  void dispose() {
    fullnameTextEditing.dispose();
    cityTextEditing.dispose();
    bioTextEditing.dispose();
    super.dispose();
  }

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
                TextButton(
                  style: TextButton.styleFrom(overlayColor: Colors.transparent),
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                const Spacer(),
                TextButton(
                  style: TextButton.styleFrom(overlayColor: Colors.transparent),
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  "https://randomuser.me/api/portraits/thumb/men/75.jpg"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: fullnameTextEditing,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.transparent,
                  filled: true),
              minLines: 1,
              maxLines: 1,
              onTap: () {},
            ),
            const SizedBox(height: 20),
            TextField(
              controller: cityTextEditing,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.transparent,
                  filled: true),
              minLines: 1,
              maxLines: 1,
              onTap: () {},
            ),
            const SizedBox(height: 20),
            TextField(
              controller: bioTextEditing,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.transparent,
                  filled: true),
              minLines: 1,
              maxLines: 1,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
