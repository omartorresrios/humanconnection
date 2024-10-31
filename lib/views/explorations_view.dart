import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:humanconnection/helpers/notification_provider.dart';
import 'package:humanconnection/helpers/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../helpers/loader.dart';
import '../helpers/service.dart';
import '../models/exploration.dart';
import 'exploration_details_view.dart';
import 'exploration_item_view.dart';

class ExplorationsView extends StatefulWidget {
  final Function onPermissionCompleted;

  const ExplorationsView({super.key, required this.onPermissionCompleted});

  @override
  State<ExplorationsView> createState() => ExplorationsViewState();
}

class ExplorationsViewState extends State<ExplorationsView> {
  late Future<List<ExplorationWithSimilar>> explorationsWithSimilar;

  @override
  void initState() {
    super.initState();
    reloadExplorations(Service.fetchExplorationsWithSimilar());
    requestNotificationPermission();
  }

  void reloadExplorations(
      Future<List<ExplorationWithSimilar>> newExplorations) {
    setState(() {
      explorationsWithSimilar = newExplorations;
    });
  }

  void fetchNewExplorations(String result) async {
    if (result == 'success') {
      setState(() {
        reloadExplorations(Service.fetchExplorationsWithSimilar());
      });
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

  Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      var status = await Permission.notification.request();
      if (status.isPermanentlyDenied || status.isGranted) {
        widget.onPermissionCompleted();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      body: FutureBuilder<List<ExplorationWithSimilar>>(
        future: explorationsWithSimilar,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Loader());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return createFirstExplorationWidget();
          } else {
            final provider = NotificationProvider(snapshot.data!);
            NotificationService().setProvider(provider);
            return ChangeNotifierProvider.value(
              value: provider,
              child: explorationsWidget(),
            );
          }
        },
      ),
    );
  }

  Widget explorationsWidget() {
    return Consumer<NotificationProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          itemCount: provider.explorationsWithSimilar.length,
          itemBuilder: (context, index) {
            return ExplorationItemView(
              explorationWithSimilar: provider.explorationsWithSimilar[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExplorationDetailsView(
                      explorationWithSimilar:
                          provider.explorationsWithSimilar[index],
                    ),
                  ),
                ).then((explorationUpdated) {
                  if (explorationUpdated == true) {
                    setState(() {
                      reloadExplorations(
                          Service.fetchExplorationsWithSimilar());
                    });
                  }
                });
              },
            );
          },
        );
      },
    );
  }

  Widget createFirstExplorationWidget() {
    return const Center(
      child: Text("Create your first exploration"),
    );
  }
}
