import 'package:flutter/material.dart';
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
          bottom: true,
          child: Column(children: [
            Center(
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(user.profilePicture),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(user.fullname, textAlign: TextAlign.justify),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(user.city),
            ),
            const SizedBox(height: 20),
            Align(child: Text(user.bio))
          ]),
        ));
  }
}
