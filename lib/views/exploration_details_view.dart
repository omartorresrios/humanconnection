import 'package:flutter/material.dart';
import '../models/exploration.dart';
import '../models/source.dart';

class ExplorationDetailsView extends StatefulWidget {
  final Exploration exploration;

  const ExplorationDetailsView({super.key, required this.exploration});

  @override
  State<ExplorationDetailsView> createState() => _ExplorationDetailsViewState();
}

class _ExplorationDetailsViewState extends State<ExplorationDetailsView> {
  final explorationTextEditing = TextEditingController();
  final List<TextEditingController> sourceControllers = [];
  final explorationTextFocusNode = FocusNode();
  final List<FocusNode> explorationSourceFocusNodes = [];
  String explorationBody = "";
  bool isBodyFocused = false;
  bool isSourceFocused = false;

  @override
  void initState() {
    super.initState();
    explorationTextEditing.text = widget.exploration.body;
    explorationTextFocusNode.addListener(explorationTextOnFocusChange);
    for (var i = 0; i < widget.exploration.sources.length; i++) {
      explorationSourceFocusNodes.add(FocusNode());
    }
    for (var i = 0; i < explorationSourceFocusNodes.length; i++) {
      explorationSourceFocusNodes[i].addListener(
          () => explorationSourceOnFocusChange(explorationSourceFocusNodes[i]));
    }
    setSources();
    setFocusNodes();
  }

  @override
  void dispose() {
    explorationTextEditing.dispose();
    for (final TextEditingController controller in sourceControllers) {
      controller.dispose();
    }
    explorationTextFocusNode.dispose();
    for (FocusNode focus in explorationSourceFocusNodes) {
      focus.dispose();
    }
    super.dispose();
  }

  void explorationTextOnFocusChange() {
    setState(() => isBodyFocused = explorationTextFocusNode.hasFocus);
  }

  void explorationSourceOnFocusChange(FocusNode focusNode) {
    setState(() => isSourceFocused = focusNode.hasFocus);
  }

  void setSources() {
    for (Source source in widget.exploration.sources) {
      sourceControllers.add(TextEditingController(text: source.text));
    }
  }

  void setFocusNodes() {
    for (var i = 0; i < widget.exploration.sources.length; i++) {
      explorationSourceFocusNodes.add(FocusNode());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail view!"),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () {
              print("hahaha");
            },
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isBodyFocused)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      setState(() =>
                          isBodyFocused = explorationTextFocusNode.hasFocus);
                      FocusScope.of(context).unfocus();
                    },
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red),
                    ),
                    child: const Text('Done'),
                  ),
                ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Sources"),
                  if (isSourceFocused)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          for (FocusNode focus in explorationSourceFocusNodes) {
                            isSourceFocused = focus.hasFocus;
                          }
                          FocusScope.of(context).unfocus();
                        });
                      },
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.red),
                      ),
                      child: const Text('Done'),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              sourceTextField()
            ],
          ),
        ),
      ),
    );
  }

  Widget sourceTextField() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      // padding: const EdgeInsets.symmetric(horizontal: 15),
      shrinkWrap: true,
      itemCount: widget.exploration.sources.length,
      itemBuilder: (context, index) {
        return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(children: [
              Expanded(
                child: TextField(
                  focusNode: explorationSourceFocusNodes[index],
                  controller: sourceControllers[index],
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      filled: true),
                  maxLines: 1,
                  onTap: () {},
                ),
              )
            ]));
      },
    );
  }
}
