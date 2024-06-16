import 'package:flutter/material.dart';
import '../models/exploration.dart';

class ExplorationItem extends StatelessWidget {
  final Exploration exploration;
  final void Function() onTap;

  const ExplorationItem(
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
                // flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exploration.body,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: exploration.explorers.isEmpty ? 0 : 8),
                    if (exploration.explorers.isNotEmpty)
                      ExplorerList(explorers: exploration.explorers.length),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Container(
                height: 25,
                width: 25,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                child: const Center(
                  child: Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ExplorerList extends StatelessWidget {
  final int explorers;

  const ExplorerList({super.key, required this.explorers});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: explorers,
        itemBuilder: (context, index) {
          return Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 35, 96, 188),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              size: 15,
            ),
          );
        },
      ),
    );
  }
}
