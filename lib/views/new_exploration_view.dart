import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewExplorationView extends StatefulWidget {
  const NewExplorationView({super.key});

  @override
  State<NewExplorationView> createState() => _NewExplorationViewState();
}

class _NewExplorationViewState extends State<NewExplorationView> {
  final explorationTextEditing = TextEditingController();
  final List<TextEditingController> sourceControllers = [];
  final explorationTextFocusNode = FocusNode();
  bool isButtonActive = false;

  @override
  void initState() {
    for (var i = 0; i < 3; i++) {
      TextEditingController textEditingController = TextEditingController();
      textEditingController.addListener(() => textOnFocusChange());
      sourceControllers.add(textEditingController);
    }
    explorationTextEditing.addListener(() => textOnFocusChange());
    explorationTextFocusNode.requestFocus();
    super.initState();
  }

  void textOnFocusChange() {
    bool sourcesAreFilled =
        sourceControllers.any((source) => source.text.isNotEmpty);
    setState(() => isButtonActive =
        (explorationTextEditing.text.isNotEmpty && sourcesAreFilled));
  }

  @override
  void dispose() {
    explorationTextEditing.dispose();
    for (final TextEditingController controller in sourceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New exploration"),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: ElevatedButton(
            onPressed: isButtonActive
                ? () async {
                    await createExploration(
                        explorationTextEditing.text,
                        sourceControllers.map((source) => source.text).toList(),
                        context);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              splashFactory: NoSplash.splashFactory,
              shadowColor: Colors.transparent,
            ),
            child: const Text("Create")),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            color: Colors.green,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  focusNode: explorationTextFocusNode,
                  controller: explorationTextEditing,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.red,
                      filled: true),
                  minLines: 1,
                  maxLines: 8,
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                const Text("Sources"),
                const SizedBox(height: 20),
                sourceTextFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sourceTextFields() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      // padding: const EdgeInsets.symmetric(horizontal: 15),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Row(children: [
          Expanded(
            child: TextField(
              // focusNode: explorationSourceFocusNodes[index],
              controller: sourceControllers[index],
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                  filled: true),
              maxLines: 1,
              onTap: () {},
            ),
          )
        ]);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}

Future<void> createExploration(
    String text, List<String> sources, BuildContext context) async {
  const url = 'http://127.0.0.1:3000/api/create_exploration';
  Map data = {
    'exploration': {'text': text, 'sources': sources}
  };
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      if (context.mounted) {
        Navigator.pop(context, 'success');
      }
    } else {
      print("Request failed with status: ${response.statusCode}");
    }
  } catch (e) {
    print("Request error: $e");
  }
}
