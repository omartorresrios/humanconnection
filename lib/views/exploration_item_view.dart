import 'package:flutter/material.dart';
import '../models/exploration.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ExplorationItemView extends StatelessWidget {
  final Exploration exploration;
  final void Function() onTap;

  const ExplorationItemView(
      {super.key, required this.exploration, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 13, 206, 64),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exploration.text,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(
                        height: exploration.sharedExplorations.isEmpty ? 0 : 8),
                    if (exploration.sharedExplorations.isNotEmpty)
                      ExplorerList(
                          explorerProfilePictureUrls: exploration
                              .sharedExplorations
                              .map((e) => e.user.picture)
                              .toList()),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              if (exploration.notificationCount != null &&
                  exploration.notificationCount! > 0)
                CircleAvatar(child: Text('${exploration.notificationCount}'))
            ],
          ),
        ),
      ),
    );
  }
}

class ExplorerList extends StatelessWidget {
  final List<String> explorerProfilePictureUrls;

  const ExplorerList({super.key, required this.explorerProfilePictureUrls});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: explorerProfilePictureUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CachedNetworkImage(
              imageUrl: explorerProfilePictureUrls[index],
              imageBuilder: (context, imageProvider) => Container(
                width: 20.0,
                height: 20.0,
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
          );
        },
      ),
    );
  }
}
