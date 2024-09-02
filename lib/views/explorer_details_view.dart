import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/exploration.dart';
import '../models/user.dart';
import 'chat_view.dart';
import 'explorer_profile.dart';

class ExplorerDetailsView extends StatefulWidget {
  final Exploration exploration;

  const ExplorerDetailsView({super.key, required this.exploration});

  @override
  State<ExplorerDetailsView> createState() => _ExplorerDetailsViewState();
}

class _ExplorerDetailsViewState extends State<ExplorerDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel")),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChatView()));
                      },
                      child: const Text('Chat'),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        NetworkImage(widget.exploration.user.picture),
                  ),
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    openExplorerProfile(widget.exploration.user);
                  },
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(61, 78, 78, 78),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                        "${widget.exploration.user.fullname} is exploring about ${widget.exploration.text}",
                        textAlign: TextAlign.justify),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Sources"),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(61, 78, 78, 78),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      for (int i = 0;
                          i < widget.exploration.sources.length;
                          i++) ...[
                        GestureDetector(
                            onTap: () async {
                              HapticFeedback.heavyImpact();
                              await openSource(
                                  widget.exploration.sources[i].text);
                            },
                            child: Text(
                                "${i + 1}) ${widget.exploration.sources[i].text}",
                                style: const TextStyle(color: Colors.blue))),
                        if (i != widget.exploration.sources.length - 1)
                          const SizedBox(height: 12),
                      ],
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openSource(String url) async {
    try {
      var uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print("There was an error when opening a link: $e");
    }
  }

  void openExplorerProfile(UserData user) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            ExplorerProfileView(user: user),
          ]);
        });
  }
}
