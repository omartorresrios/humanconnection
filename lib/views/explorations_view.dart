import 'package:flutter/material.dart';
import '../models/exploration.dart';
import 'exploration_details_view.dart';
import 'exploration_item.dart';

class ExplorationsView extends StatefulWidget {
  ExplorationsView({super.key});
  final explorationList = Exploration.explorationList();

  @override
  State<ExplorationsView> createState() => _ExplorationsViewState();
}

class _ExplorationsViewState extends State<ExplorationsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 206, 13, 13),
      body: ListView.builder(
        itemCount: widget.explorationList.length, // Number of sections
        itemBuilder: (context, index) {
          return ExplorationItem(
            exploration: widget.explorationList[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ExplorationDetailsView(
                          exploration: widget.explorationList[index],
                        )),
              );
            },
          );

          //  ExplorationRow(
          //   body: widget.explorationList[index].body,
          //   explorers: widget
          //       .explorationList[index].explorers.length, // Number of circles
          //   notification: "3",
          // onTap: () {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => ExplorationDetailsView(
          //               exploration: widget.explorationList[index],
          //             )),
          //   );
          // },
          // );
        },
      ),
    );
  }
}

class ExplorationRow extends StatelessWidget {
  final String body;
  final int explorers;
  final String notification;
  final void Function() onTap;

  ExplorationRow(
      {required this.body,
      required this.explorers,
      required this.notification,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          color: Colors.green,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(body,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    ExplorerList(explorers: explorers),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(notification, style: TextStyle(fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExplorerList extends StatelessWidget {
  final int explorers;

  ExplorerList({required this.explorers});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: explorers,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue,
            ),
          );
        },
      ),
    );
  }
}
