import 'source.dart';

class Exploration {
  String body;
  List<Source> sources;
  List<User> explorers;

  Exploration(
      {required this.body, required this.sources, required this.explorers});

  static List<Exploration> explorationList() {
    return [
      Exploration(
          body:
              "I'm interested in exploring the previous events that led Churchill decide to fight and confront Hitler despite all the high probabilities of loosing. Why he was so stubborn, courageous and optimistic. What was happening in the England oh his time that pushed him to have this attitude.",
          sources: [
            Source(text: "http://source-one.com"),
            Source(text: "http://source-two.com"),
            Source(text: "http://source-three.com")
          ],
          explorers: [
            User(id: "1", fullname: "Martha Poms", photoUrl: "some-url"),
            User(id: "2", fullname: "Thomas Grews", photoUrl: "some-url"),
            User(id: "3", fullname: "August Vall", photoUrl: "some-url")
          ]),
      Exploration(
          body:
              "I'm interested in exploring the events that happened in Europe when Hitler was thinking about invade other countries. I read his biography and it’s fascinated how he changed his mind and posture many times.",
          sources: [
            Source(text: "http://source-one.com"),
            Source(text: "http://source-two.com"),
            Source(text: "http://source-three.com")
          ],
          explorers: [
            User(id: "1", fullname: "Martha Poms", photoUrl: "some-url"),
            User(id: "2", fullname: "Thomas Grews", photoUrl: "some-url"),
            User(id: "3", fullname: "August Vall", photoUrl: "some-url")
          ]),
      Exploration(
          body:
              "I'm interested in exploring the events that happened in Europe when Hitler was thinking about invade other countries. I read his biography and it’s fascinated how he changed his mind and posture many times.",
          sources: [
            Source(text: "http://source-one.com"),
            Source(text: "http://source-two.com"),
            Source(text: "http://source-three.com")
          ],
          explorers: []),
      Exploration(
          body:
              "I'm interested in exploring the events that happened in Europe when Hitler was thinking about invade other countries. I read his biography and it’s fascinated how he changed his mind and posture many times.",
          sources: [
            Source(text: "http://source-one.com"),
            Source(text: "http://source-two.com"),
            Source(text: "http://source-three.com")
          ],
          explorers: [
            User(id: "1", fullname: "Martha Poms", photoUrl: "some-url"),
            User(id: "2", fullname: "Thomas Grews", photoUrl: "some-url"),
            User(id: "3", fullname: "August Vall", photoUrl: "some-url")
          ]),
      Exploration(
          body:
              "I'm interested in exploring the events that happened in Europe when Hitler was thinking about invade other countries. I read his biography and it’s fascinated how he changed his mind and posture many times.",
          sources: [
            Source(text: "http://source-one.com"),
            Source(text: "http://source-two.com"),
            Source(text: "http://source-three.com")
          ],
          explorers: []),
    ];
  }
}
