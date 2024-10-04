import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humanconnection/views/new_exploration_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../custom_views/navigation_bar_view.dart';
import '../helpers/service.dart';
import '../models/exploration.dart';
import '../models/user.dart';
import 'connect_view.dart';
import 'explorations_view.dart';
import 'settings_view.dart';

class MainView extends StatefulWidget {
  final explorationList = Exploration.explorationList();
  final UserData user;

  MainView({super.key, required this.user});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with WidgetsBindingObserver {
  final GlobalKey<ExplorationsViewState> explorationsKey =
      GlobalKey<ExplorationsViewState>();
  final GlobalKey<SettingsViewState> settingsKey =
      GlobalKey<SettingsViewState>();
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void updateSettingsNotificationStatus() {
    settingsKey.currentState?.updateNotificationStatus();
  }

  void updateSettingsLocationStatus() {
    settingsKey.currentState?.updateLocationStatus();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('App is in the foreground');
      updateSettingsNotificationStatus();
      updateSettingsLocationStatus();
    } else if (state == AppLifecycleState.paused) {
      print('App is in the background');
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
              ExplorationsView(
                  key: explorationsKey,
                  onPermissionCompleted: () {
                    updateSettingsNotificationStatus();
                  }),
              const ConnectView(),
              SettingsView(key: settingsKey)
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
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
          ),
        ));
  }

  void fetchAndReloadExplorations() {
    explorationsKey.currentState
        ?.reloadExplorations(Service.fetchExplorations());
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
