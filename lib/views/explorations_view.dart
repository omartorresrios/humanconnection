import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../helpers/service.dart';
import '../models/exploration.dart';
import 'exploration_details_view.dart';
import 'exploration_item_view.dart';

class ExplorationsView extends StatefulWidget {
  const ExplorationsView({super.key});

  @override
  State<ExplorationsView> createState() => ExplorationsViewState();
}

class ExplorationsViewState extends State<ExplorationsView> {
  late Future<List<Exploration>> explorations;

  @override
  void initState() {
    super.initState();
    reloadExplorations(Service.fetchExplorations());
  }

  void reloadExplorations(Future<List<Exploration>> newExplorations) {
    setState(() {
      explorations = newExplorations;
    });
  }

  void fetchNewExplorations(String result) async {
    if (result == 'success') {
      setState(() {
        reloadExplorations(Service.fetchExplorations());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 247, 247, 247),
        body: FutureBuilder<List<Exploration>>(
            future: explorations,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return createFirstExplorationWidget();
                } else {
                  return explorationsWidget(snapshot);
                }
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return const CircularProgressIndicator();
              }
            }));
  }

  Widget explorationsWidget(AsyncSnapshot snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        return ExplorationItemView(
          exploration: snapshot.data![index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExplorationDetailsView(
                        exploration: snapshot.data![index],
                      )),
            ).then((explorationUpdated) {
              if (explorationUpdated == true) {
                setState(() {
                  reloadExplorations(Service.fetchExplorations());
                });
              }
            });
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
