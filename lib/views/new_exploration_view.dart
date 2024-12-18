import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helpers/loader.dart';
import '../helpers/service.dart';

class NewExplorationView extends StatefulWidget {
  const NewExplorationView({super.key});

  @override
  State<NewExplorationView> createState() => _NewExplorationViewState();
}

class _NewExplorationViewState extends State<NewExplorationView> {
  final explorationTextEditing = TextEditingController();
  final List<TextEditingController> sourceControllers = [];
  final explorationTextFocusNode = FocusNode();
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
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
    return Stack(children: [
      Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            Navigator.pop(context, 'nothing');
                          },
                          child: const Text("Cancel")),
                      const Spacer(),
                      GestureDetector(
                        onTap: isButtonActive
                            ? () async {
                                FocusScope.of(context).unfocus();
                                HapticFeedback.heavyImpact();
                                isLoading.value = true;
                                await Service.createExploration(
                                    explorationTextEditing.text,
                                    sourceControllers
                                        .map((source) => source.text)
                                        .toList(), (bool onCompleted) {
                                  if (context.mounted) {
                                    Navigator.pop(context, 'success');
                                    isLoading.value = false;
                                  }
                                });
                              }
                            : null,
                        child: const Text('Create'),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: TextField(
                    focusNode: explorationTextFocusNode,
                    controller: explorationTextEditing,
                    decoration: const InputDecoration(
                        hintText: "New exploration",
                        border: InputBorder.none,
                        fillColor: Colors.transparent),
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
                const Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text("Sources"),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: sourceTextFields(),
                ),
              ],
            ),
          ),
        ),
      ),
      ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (context, isLoadingValue, child) {
          return isLoadingValue
              ? const Center(child: Loader())
              : const SizedBox.shrink();
        },
      ),
    ]);
  }

  Widget sourceTextFields() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Row(children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                // focusNode: explorationSourceFocusNodes[index],
                controller: sourceControllers[index],
                decoration: InputDecoration(
                    hintText: "Source ${index + 1}",
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    border: const OutlineInputBorder()),
                maxLines: 1,
                onTap: () {},
              ),
            ),
          )
        ]);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}
