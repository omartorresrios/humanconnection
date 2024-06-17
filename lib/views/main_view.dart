import 'package:flutter/material.dart';
import 'package:humanconnection/views/new_exploration.dart';
import '../models/exploration.dart';
import 'connect_view.dart';
import 'explorations_view.dart';

class MainView extends StatefulWidget {
  MainView({super.key});
  final explorationList = Exploration.explorationList();

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int selectedIndex = 0;
  final views = [
    ExplorationsView(),
    const ConnectView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 206, 13, 13),
        body: IndexedStack(
          index: selectedIndex,
          children: views,
        ),
        floatingActionButton: Visibility(
          visible: selectedIndex == 0,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NewExplorationView()),
              );
            },
            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
            backgroundColor: const Color.fromARGB(255, 53, 53, 53),
            shape: const CircleBorder(),
            child: const Icon(Icons.add),
          ),
        ),
        bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex,
            onTap: (int newIndex) {
              setState(() {
                selectedIndex = newIndex;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: "Connect",
              ),
            ],
          ),
        ));
  }
}
