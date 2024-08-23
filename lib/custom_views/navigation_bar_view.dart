import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavigationBarView extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      color: Color.fromARGB(255, 247, 247, 247),
      child: AppBar(
        forceMaterialTransparency: true,
        title: Text("Explorations"),
        leading: Image.asset('lib/assets/network.png'),
        actions: [
          GestureDetector(
            onTap: () {
              HapticFeedback.heavyImpact();
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://randomuser.me/api/portraits/thumb/men/75.jpg"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
