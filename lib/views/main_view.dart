import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humanconnection/views/new_exploration_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../custom_views/navigation_bar_view.dart';
import '../models/exploration.dart';
import '../models/user.dart';
import 'connect_view.dart';
import 'explorations_view.dart';

class MainView extends StatefulWidget {
  final explorationList = Exploration.explorationList();
  final UserData user;

  MainView({super.key, required this.user});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final GlobalKey<ExplorationsViewState> explorationsKey =
      GlobalKey<ExplorationsViewState>();
  int selectedIndex = 0;

  Future<List<Exploration>> fetchExplorations() async {
    const url = 'http://192.168.1.86:3000/api/all_explorations';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return parseExplorations(response.body);
    } else {
      throw Exception('Failed to load explorations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 247, 247, 247),
        appBar: NavigationBarView(user: widget.user),
        body: Padding(
          padding: const EdgeInsets.only(
              left: 8.0, top: 0.0, right: 8.0, bottom: 0.0),
          child: IndexedStack(
            index: selectedIndex,
            children: [
              ExplorationsView(key: explorationsKey),
              const ConnectView(),
            ],
          ),
        ),
        floatingActionButton: Visibility(
          visible: selectedIndex == 0,
          child: FloatingActionButton(
            onPressed: () async {
              HapticFeedback.heavyImpact();
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NewExplorationView(),
                    fullscreenDialog: true),
              );
              if (result == 'success') {
                showToast();
                fetchAndReloadExplorations();
              }
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

  void fetchAndReloadExplorations() {
    explorationsKey.currentState?.reloadExplorations(fetchExplorations());
  }

  void showToast() {
    Fluttertoast.showToast(
      msg: "Your exploration has been created!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
