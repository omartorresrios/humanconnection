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
        itemCount: widget.explorationList.length,
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
        },
      ),
    );
  }
}
