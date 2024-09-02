import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user.dart';

class MyProfileView extends StatefulWidget {
  final UserData user;

  const MyProfileView({super.key, required this.user});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  final fullnameTextController = TextEditingController();
  final cityTextController = TextEditingController();
  final bioTextController = TextEditingController();
  final ValueNotifier<bool> hasProfileChanged = ValueNotifier<bool>(false);
  String fullnameText = "";
  String cityText = "";
  String bioText = "";

  @override
  void initState() {
    super.initState();
    setTexts();
    setupListeners();
  }

  void setTexts() {
    fullnameTextController.text = widget.user.fullname;
    cityTextController.text = widget.user.city;
    bioTextController.text = widget.user.bio;
    fullnameText = widget.user.fullname;
    cityText = widget.user.city;
    bioText = widget.user.bio;
  }

  void setupListeners() {
    fullnameTextController.addListener(checkForChanges);
    cityTextController.addListener(checkForChanges);
    bioTextController.addListener(checkForChanges);
  }

  void checkForChanges() {
    if (fullnameTextController.text != fullnameText ||
        cityTextController.text != cityText ||
        bioTextController.text != bioText) {
      hasProfileChanged.value = true;
    } else {
      hasProfileChanged.value = false;
    }
  }

  @override
  void dispose() {
    fullnameTextController.dispose();
    cityTextController.dispose();
    bioTextController.dispose();
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
                ValueListenableBuilder<bool>(
                  valueListenable: hasProfileChanged,
                  builder: (context, isVisible, child) {
                    return isVisible
                        ? TextButton(
                            style: TextButton.styleFrom(
                              overlayColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              HapticFeedback.heavyImpact();
                            },
                            child: const Text('Save'),
                          )
                        : const SizedBox
                            .shrink(); // Hide the button if not visible
                  },
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
              controller: fullnameTextController,
              decoration: const InputDecoration(
                  hintText: "Full Name",
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
              controller: cityTextController,
              decoration: const InputDecoration(
                  hintText: "City",
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
              controller: bioTextController,
              decoration: const InputDecoration(
                  hintText: "Bio. Put something about you.",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  border: OutlineInputBorder(),
                  fillColor: Colors.transparent,
                  filled: true),
              minLines: 1,
              maxLines: 5,
            )
          ],
        ),
      ),
    );
  }
}
