import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humanconnection/auth_manager.dart';
import 'package:humanconnection/custom_views/my_profile_view.dart';
import '../models/user.dart';

class NavigationBarView extends StatelessWidget implements PreferredSizeWidget {
  final UserData user;
  const NavigationBarView({super.key, required this.user});

  Future signOut() async {
    AuthManager().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      color: const Color.fromARGB(255, 247, 247, 247),
      child: AppBar(
        forceMaterialTransparency: true,
        title: const Text("Explorations"),
        leading: Image.asset('lib/assets/network.png'),
        actions: [
          IconButton(onPressed: signOut, icon: const Icon(Icons.logout)),
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
                              fullname: user.fullname,
                              picture: user.picture,
                              bio: user.bio,
                              city: user.city)),
                    ),
                  );
                },
              );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.picture),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
