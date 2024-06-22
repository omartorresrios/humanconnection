import 'package:flutter/material.dart';
import 'package:humanconnection/views/chats_view.dart';
import 'package:humanconnection/views/explorer_details_view.dart';
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
    explorationTextEditing.text = widget.exploration.text;
    explorationTextFocusNode.addListener(explorationTextOnFocusChange);
    for (var i = 0; i < widget.exploration.sources.length; i++) {
      FocusNode focusNode = FocusNode();
      focusNode.addListener(() => explorationSourceOnFocusChange(focusNode));
      explorationSourceFocusNodes.add(focusNode);
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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatsView()),
                );
              },
              icon: const Icon(Icons.chat)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            color: Colors.green,
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
                            for (FocusNode focus
                                in explorationSourceFocusNodes) {
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
                sourceTextFields(),
                if (widget.exploration.sharedExplorations.isNotEmpty)
                  connectionsSection()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget connectionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text("Connections"),
        const SizedBox(height: 20),
        explorerList(widget.exploration.sharedExplorations),
      ],
    );
  }

  Widget sourceTextFields() {
    return ListView.separated(
      padding: const EdgeInsets.all(0.0),
      physics: const NeverScrollableScrollPhysics(),
      // padding: const EdgeInsets.symmetric(horizontal: 15),
      shrinkWrap: true,
      itemCount: widget.exploration.sources.length,
      itemBuilder: (context, index) {
        return Row(children: [
          Expanded(
            child: TextField(
              focusNode: explorationSourceFocusNodes[index],
              controller: sourceControllers[index],
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Color.fromARGB(255, 172, 194, 91),
                  filled: true),
              maxLines: 1,
            ),
          )
        ]);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }

  Widget explorerList(List<Exploration> explorations) {
    return ListView.separated(
      padding: const EdgeInsets.all(0.0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: explorations.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ExplorerDetailsView(exploration: explorations[index]),
                    fullscreenDialog: true));
          },
          child: Row(children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 35, 96, 188),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 15,
              ),
            ),
            const SizedBox(width: 8),
            Text(explorations[index].user.fullname)
          ]),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}
