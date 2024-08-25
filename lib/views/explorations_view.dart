import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../models/exploration.dart';
import 'exploration_details_view.dart';
import 'exploration_item_view.dart';
import 'new_exploration_view.dart';

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
    reloadExplorations(fetchExplorations());
  }

  Future<List<Exploration>> fetchExplorations() async {
    const url = 'http://127.0.0.1:3000/api/all_explorations';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return parseExplorations(response.body);
    } else {
      throw Exception('Failed to load explorations');
    }
  }

  void reloadExplorations(Future<List<Exploration>> newExplorations) {
    setState(() {
      explorations = newExplorations;
    });
  }

  void fetchNewExplorations(String result) async {
    if (result == 'success') {
      setState(() {
        reloadExplorations(fetchExplorations());
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
                  reloadExplorations(fetchExplorations());
                });
              }
            });
          },
        );
      },
    );
  }

  Widget createFirstExplorationWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("Create your first exploration"),
          const SizedBox(height: 0),
          Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NewExplorationView()),
                );
                fetchNewExplorations(result);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 53, 53, 53),
                foregroundColor: Color.fromARGB(255, 255, 255, 255),
                shape: const CircleBorder(),
                fixedSize: Size(20, 20),
                padding: EdgeInsets.zero,
              ),
              child: const Icon(
                Icons.add,
                size: 15,
              ),
            ),
          )
        ],
      ),
    );
  }
}
