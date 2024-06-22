import 'source.dart';
import 'user.dart';
import 'dart:convert';

class Exploration {
  String text;
  List<Source> sources;
  User user;
  List<Exploration> explorations;

  Exploration(
      {required this.text,
      required this.sources,
      required this.user,
      required this.explorations});

  factory Exploration.fromJson(Map<String, dynamic> json) {
    final list = List<String>.from(json['sources']);
    final sources = list.map<Source>((text) => Source(text: text)).toList();
    return Exploration(
        text: json['text'],
        sources: sources,
        user: User.fromJson(json['user']),
        explorations: json['explorations']);
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'sources': sources,
      'user': user,
      'explorations': explorations,
    };
  }

  static List<Exploration> explorationList() {
    return [
      Exploration(
          text:
              "I'm interested in exploring the previous events that led Churchill decide to fight and confront Hitler despite all the high probabilities of loosing. Why he was so stubborn, courageous and optimistic. What was happening in the England oh his time that pushed him to have this attitude.",
          sources: [
            Source(text: "http://source-one.com"),
            Source(text: "http://source-two.com"),
            Source(text: "http://source-three.com")
          ],
          user: User(
              id: "3",
              fullname: "Omar Torres",
              profilePicture: "photoUrl",
              bio: "user.bio",
              city: "user.city",
              email: "user.email"),
          explorations: [
            Exploration(
                text:
                    "I want to explore what were the reasons the United States didn't engaged in the war since it was clear that the post war economic benefits outweighted the military costs.",
                sources: [
                  Source(text: "http://source-nine.com"),
                  Source(text: "http://source-tenth.com")
                ],
                user: User(
                    id: "1",
                    fullname: "Martha Poms",
                    profilePicture: "some-url",
                    bio: "user.bio",
                    city: "user.city",
                    email: "user.email"),
                explorations: []),
            Exploration(
                text: "Another exploration",
                sources: [Source(text: "source1"), Source(text: "source2")],
                user: User(
                    id: "3",
                    fullname: "August Vall",
                    profilePicture: "some-url",
                    bio: "user.bio",
                    city: "user.city",
                    email: "user.email"),
                explorations: []),
          ]),
      Exploration(
        text:
            "I'm interested in exploring the events that happened in Europe when Hitler was thinking about invade other countries. I read his biography and it’s fascinated how he changed his mind and posture many times.",
        sources: [
          Source(text: "http://source-one.com"),
          Source(text: "http://source-two.com"),
          Source(text: "http://source-three.com")
        ],
        user: User(
            id: "3",
            fullname: "Omar Torres",
            profilePicture: "photoUrl",
            bio: "user.bio",
            city: "user.city",
            email: "user.email"),
        explorations: [
          Exploration(
              text: "Another exploration",
              sources: [Source(text: "source1"), Source(text: "source2")],
              user: User(
                  id: "1",
                  fullname: "Martha Poms",
                  profilePicture: "some-url",
                  bio: "user.bio",
                  city: "user.city",
                  email: "user.email"),
              explorations: []),
          Exploration(
              text: "Another exploration",
              sources: [Source(text: "source1"), Source(text: "source2")],
              user: User(
                  id: "2",
                  fullname: "Thomas Grews",
                  profilePicture: "some-url",
                  bio: "user.bio",
                  city: "user.city",
                  email: "user.email"),
              explorations: []),
        ],
      ),
      Exploration(
        text:
            "I'm interested in exploring the events that happened in Europe when Hitler was thinking about invade other countries. I read his biography and it’s fascinated how he changed his mind and posture many times.",
        sources: [
          Source(text: "http://source-one.com"),
          Source(text: "http://source-two.com"),
          Source(text: "http://source-three.com")
        ],
        user: User(
            id: "3",
            fullname: "Omar Torres",
            profilePicture: "photoUrl",
            bio: "user.bio",
            city: "user.city",
            email: "user.email"),
        explorations: [
          Exploration(
              text: "Another exploration",
              sources: [Source(text: "source1"), Source(text: "source2")],
              user: User(
                  id: "3",
                  fullname: "August Vall",
                  profilePicture: "some-url",
                  bio: "user.bio",
                  city: "user.city",
                  email: "user.email"),
              explorations: []),
        ],
      )
    ];
  }
}

List<Exploration> parseExplorations(String responsetext) {
  final parsed = json.decode(responsetext).cast<Map<String, dynamic>>();
  return parsed.map<Exploration>((json) => Exploration.fromJson(json)).toList();
}
