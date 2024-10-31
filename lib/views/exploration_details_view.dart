import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humanconnection/helpers/notification_service.dart';
import 'package:humanconnection/views/explorer_details_view.dart';
import '../helpers/loader.dart';
import '../helpers/service.dart';
import '../models/exploration.dart';
import '../models/source.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ExplorationDetailsView extends StatefulWidget {
  final ExplorationWithSimilar explorationWithSimilar;

  const ExplorationDetailsView(
      {super.key, required this.explorationWithSimilar});

  @override
  State<ExplorationDetailsView> createState() => _ExplorationDetailsViewState();
}

class _ExplorationDetailsViewState extends State<ExplorationDetailsView> {
  final explorationTextController = TextEditingController();
  final List<TextEditingController> sourceControllers = [];
  final ValueNotifier<bool> hasExplorationChanged = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final List<String> sourceTexts = [];
  String explorationText = "";
  bool explorationUpdated = false;

  @override
  void initState() {
    super.initState();
    setExploration();
    markAllNotificationsAsRead();
    setSources();
    setupListeners();
  }

  void setExploration() {
    explorationTextController.text =
        widget.explorationWithSimilar.exploration.text;
    explorationText = widget.explorationWithSimilar.exploration.text;
  }

  void setSources() {
    for (Source source in widget.explorationWithSimilar.exploration.sources) {
      sourceControllers.add(TextEditingController(text: source.text));
      sourceTexts.add(source.text);
    }
  }

  void setupListeners() {
    explorationTextController.addListener(checkForChanges);
    for (final TextEditingController sourceController in sourceControllers) {
      sourceController.addListener(checkForChanges);
    }
  }

  void markAllNotificationsAsRead() async {
    if (widget.explorationWithSimilar.exploration.notificationCount != null &&
        widget.explorationWithSimilar.exploration.notificationCount! > 0) {
      await Service.markAllNotificationsAsRead((bool markingCompleted) {
        if (markingCompleted == true) {
          NotificationService().addNotificationToExploration(
              widget.explorationWithSimilar.exploration.id, 0);
        }
      });
    }
  }

  void checkForChanges() {
    if (explorationTextController.text != explorationText ||
        someSourceChanged()) {
      hasExplorationChanged.value = true;
    } else {
      hasExplorationChanged.value = false;
    }
  }

  bool someSourceChanged() {
    for (int i = 0; i < sourceControllers.length; i++) {
      if (sourceControllers[i].text != sourceTexts[i]) {
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    explorationTextController.dispose();
    for (final TextEditingController sourceController in sourceControllers) {
      sourceController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
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
      )),
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

  Expanded exploration(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: TextField(
                controller: explorationTextController,
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
            const Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sources"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            sourceTextFields(),
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
        ValueListenableBuilder<bool>(
          valueListenable: hasExplorationChanged,
          builder: (context, isVisible, child) {
            return isVisible
                ? TextButton(
                    style: TextButton.styleFrom(
                      overlayColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () async {
                      HapticFeedback.heavyImpact();
                      isLoading.value = true;
                      await Service.updateExploration(
                          widget.explorationWithSimilar.exploration.id,
                          explorationTextController.text,
                          sourceControllers
                              .map((source) => source.text)
                              .toList(), (bool explorationWasUpdated) {
                        setState(() {
                          explorationUpdated = explorationWasUpdated;
                        });
                        isLoading.value = false;
                      });
                    },
                    child: const Text('Save'),
                  )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget connectionsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text("Connections"),
          const SizedBox(height: 20),
          explorerList(widget.explorationWithSimilar.similarExplorations)
        ],
      ),
    );
  }

  Widget sourceTextFields() {
    return ListView.separated(
      padding: const EdgeInsets.all(0.0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.explorationWithSimilar.exploration.sources.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
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
            CachedNetworkImage(
              imageUrl: explorations[index].user.picture,
              imageBuilder: (context, imageProvider) => Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Text("error: $error"),
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
