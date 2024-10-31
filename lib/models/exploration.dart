import 'source.dart';
import 'user.dart';
import 'dart:convert';

class ExplorationWithSimilar {
  Exploration exploration;
  List<Exploration> similarExplorations;

  ExplorationWithSimilar(
      {required this.exploration, required this.similarExplorations});

  factory ExplorationWithSimilar.fromJson(Map<String, dynamic> json) {
    return ExplorationWithSimilar(
      exploration: Exploration.fromJson(json),
      similarExplorations: (json['similar_explorations'] as List<dynamic>)
          .map((e) => Exploration.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Exploration {
  String id;
  String text;
  List<Source> sources;
  UserData user;
  int? notificationCount;

  Exploration(
      {required this.id,
      required this.text,
      required this.sources,
      required this.user,
      this.notificationCount = 0});

  factory Exploration.fromJson(Map<String, dynamic> json) {
    final parsedSources = List<String>.from(json['sources']);
    final sources =
        parsedSources.map<Source>((text) => Source(text: text)).toList();

    return Exploration(
      id: json['id'],
      text: json['text'],
      sources: sources,
      user: UserData.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'sources': sources,
      'user': user,
    };
  }

  Exploration copyWith({
    String? id,
    String? text,
    List<Source>? sources,
    UserData? user,
    int? notificationCount,
  }) {
    return Exploration(
      id: id ?? this.id,
      text: text ?? this.text,
      sources: sources ?? this.sources,
      user: user ?? this.user,
      notificationCount: notificationCount ?? this.notificationCount,
    );
  }
}

List<Exploration> parseExplorations(String responsetext) {
  final parsed = json.decode(responsetext).cast<Map<String, dynamic>>();
  return parsed.map<Exploration>((json) => Exploration.fromJson(json)).toList();
}

extension ExplorationExtension on Exploration {
  static Exploration dummyExploration1() {
    return Exploration(
        id: "1",
        text: "Another exploration",
        sources: [Source(text: "source1"), Source(text: "source2")],
        user: UserData(
            id: "3",
            fullname: "August Vall",
            picture: "some-url",
            bio: "user.bio",
            city: "user.city",
            email: "user.email"));
  }

  static Exploration dummyExploration2() {
    return Exploration(
        id: "2",
        text: "Another exploration",
        sources: [Source(text: "source1"), Source(text: "source2")],
        user: UserData(
            id: "3",
            fullname: "August Vall",
            picture: "some-url",
            bio: "user.bio",
            city: "user.city",
            email: "user.email"));
  }

  static Exploration dummyExploration3() {
    return Exploration(
        id: "3",
        text: "Another exploration",
        sources: [Source(text: "source1"), Source(text: "source2")],
        user: UserData(
            id: "3",
            fullname: "August Vall",
            picture: "some-url",
            bio: "user.bio",
            city: "user.city",
            email: "user.email"));
  }
}
