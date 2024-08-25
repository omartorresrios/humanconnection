import 'package:flutter/material.dart';
import 'package:humanconnection/views/chats_view.dart';
import 'package:humanconnection/views/explorer_details_view.dart';
import '../models/exploration.dart';
import '../models/source.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

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
  bool explorationUpdated = false;

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
        body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: appBar(context),
          ),
          const SizedBox(height: 20),
          exploration(context),
        ],
      ),
    ));
  }

  Expanded exploration(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isBodyFocused)
              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        overlayColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () async {
                        setState(() =>
                            isBodyFocused = explorationTextFocusNode.hasFocus);
                        FocusScope.of(context).unfocus();
                        updateExploration(
                            widget.exploration.id,
                            explorationTextEditing.text,
                            sourceControllers
                                .map((source) => source.text)
                                .toList());
                      },
                      child: const Text('Done'),
                    ),
                  )),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: TextField(
                focusNode: explorationTextFocusNode,
                controller: explorationTextEditing,
                decoration: const InputDecoration(
                    border: InputBorder.none, fillColor: Colors.transparent),
                minLines: 1,
                maxLines: 8,
                onTap: () {},
              ),
            ),
            const SizedBox(height: 20),
            const Divider(
              height: 1,
              color: Color.fromARGB(61, 78, 78, 78),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Sources"),
                  if (isSourceFocused)
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () async {
                        setState(() {
                          for (FocusNode focus in explorationSourceFocusNodes) {
                            isSourceFocused = focus.hasFocus;
                          }
                          FocusScope.of(context).unfocus();
                        });
                        updateExploration(
                            widget.exploration.id,
                            explorationTextEditing.text,
                            sourceControllers
                                .map((source) => source.text)
                                .toList());
                      },
                      child: const Text('Done'),
                    )
                ],
              ),
            ),
            const SizedBox(height: 20),
            sourceTextFields(),
            if (widget.exploration.sharedExplorations.isNotEmpty)
              connectionsSection()
          ],
        ),
      ),
    );
  }

  Row appBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context, explorationUpdated);
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatsView()),
            );
          },
          child: const Icon(Icons.chat),
        ),
      ],
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
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
                  focusNode: explorationSourceFocusNodes[index],
                  controller: sourceControllers[index],
                  decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      border: OutlineInputBorder()),
                  maxLines: 1,
                ),
              ),
            )
          ]),
        );
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
              width: 20.0,
              height: 20.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      explorations[index].user.profilePicture),
                  fit: BoxFit.cover,
                ),
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

  Future<void> updateExploration(
      String id, String text, List<String> sources) async {
    String url = 'http://127.0.0.1:3000/api/update_exploration?id=$id';
    Map data = {
      'exploration': {'text': text, 'sources': sources}
    };
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        setState(() {
          explorationUpdated = true;
        });
      } else {
        throw Exception('Failed to update exploration');
      }
    } catch (e) {
      print('some error: $e');
    }
  }
}
