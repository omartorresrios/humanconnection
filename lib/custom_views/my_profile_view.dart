import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> updateProfile(String id, String city, String bio) async {
    print("user id: $id");
    String url = 'http://192.168.1.86:3000/api/update_profile?id=$id';
    Map data = {
      'user': {'city': city, 'bio': bio}
    };
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );
      print(response.body);
      if (response.statusCode == 200) {
        print('maybe a loader to be hide here');
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      print('There was an error when updating the profile: $e');
    }
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
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      overlayColor: Colors.transparent),
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
                            onPressed: () async {
                              HapticFeedback.heavyImpact();
                              await updateProfile(
                                  widget.user.id,
                                  cityTextController.text,
                                  bioTextController.text);
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
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.user.picture),
                  fit: BoxFit.cover,
                ),
              ),
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
