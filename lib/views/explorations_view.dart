import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    explorations = fetchExplorations();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 247, 247, 247),
        body: FutureBuilder<List<Exploration>>(
            future: explorations,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
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
                        );
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return const CircularProgressIndicator();
              }
            }));
  }
}
