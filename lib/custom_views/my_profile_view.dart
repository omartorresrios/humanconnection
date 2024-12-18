import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humanconnection/helpers/loader.dart';
import '../helpers/service.dart';
import '../models/user.dart';

class MyProfileView extends StatefulWidget {
  final UserData user;
  final Function(UserData) onProfileUpdated;

  const MyProfileView(
      {super.key, required this.user, required this.onProfileUpdated});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  final fullnameTextController = TextEditingController();
  final cityTextController = TextEditingController();
  final bioTextController = TextEditingController();
  final ValueNotifier<bool> hasProfileChanged = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
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
    return Stack(children: [
      Padding(
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
                      overlayColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
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
                                FocusScope.of(context).unfocus();
                                HapticFeedback.heavyImpact();
                                isLoading.value = true;
                                try {
                                  await Service.updateProfile(
                                      widget.user.id,
                                      cityTextController.text,
                                      bioTextController.text);
                                  isLoading.value = false;
                                  hasProfileChanged.value = false;
                                  UserData updatedUser = UserData(
                                    id: widget.user.id,
                                    fullname: fullnameTextController.text,
                                    email: widget.user.email,
                                    picture: widget.user.picture,
                                    city: cityTextController.text,
                                    bio: bioTextController.text,
                                  );
                                  widget.onProfileUpdated(updatedUser);
                                } catch (e) {
                                  print('Error updating profile: $e');
                                } finally {
                                  isLoading.value = false;
                                }
                              },
                              child: const Text('Save'),
                            )
                          : const SizedBox.shrink();
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
      ),
      ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (context, isLoadingValue, child) {
          return isLoadingValue
              ? const Center(child: Loader())
              : const SizedBox.shrink();
        },
      ),
    ]);
  }
}
