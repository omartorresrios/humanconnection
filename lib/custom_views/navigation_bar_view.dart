import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humanconnection/custom_views/my_profile_view.dart';
import '../models/user.dart';

class NavigationBarView extends StatelessWidget implements PreferredSizeWidget {
  final UserData user;
  const NavigationBarView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      color: const Color.fromARGB(255, 247, 247, 247),
      child: AppBar(
        forceMaterialTransparency: true,
        title: const Text("Explorations"),
        // leading: Image.asset('lib/assets/network.png'),
        actions: [
          GestureDetector(
            onTap: () {
              HapticFeedback.heavyImpact();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: IntrinsicHeight(
                      child: MyProfileView(
                          user: UserData.profileInfo(
                              id: user.id,
                              fullname: user.fullname,
                              picture: user.picture,
                              bio: user.bio,
                              city: user.city)),
                    ),
                  );
                },
              );
            },
            child: CachedNetworkImage(
              imageUrl: user.picture,
              imageBuilder: (context, imageProvider) => Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => Text("error: $error"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
