import 'source.dart';
import 'user.dart';

class Exploration {
  String body;
  List<Source> sources;
  User user;
  List<Exploration> explorations;

  Exploration(
      {required this.body,
      required this.sources,
      required this.user,
      required this.explorations});

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
          user: User(id: "3", fullname: "Omar Torres", photoUrl: "photoUrl"),
          explorations: [
            Exploration(
                body:
                    "I want to explore what were the reasons the United States didn't engaged in the war since it was clear that the post war economic benefits outweighted the military costs.",
                sources: [
                  Source(text: "http://source-nine.com"),
                  Source(text: "http://source-tenth.com")
                ],
                user: User(
                    id: "1", fullname: "Martha Poms", photoUrl: "some-url"),
                explorations: []),
            Exploration(
                body: "Another exploration",
                sources: [Source(text: "source1"), Source(text: "source2")],
                user: User(
                  id: "3",
                  fullname: "August Vall",
                  photoUrl: "some-url",
                ),
                explorations: []),
          ]),
      Exploration(
        body:
            "I'm interested in exploring the events that happened in Europe when Hitler was thinking about invade other countries. I read his biography and it’s fascinated how he changed his mind and posture many times.",
        sources: [
          Source(text: "http://source-one.com"),
          Source(text: "http://source-two.com"),
          Source(text: "http://source-three.com")
        ],
        user: User(id: "3", fullname: "Omar Torres", photoUrl: "photoUrl"),
        explorations: [
          Exploration(
              body: "Another exploration",
              sources: [Source(text: "source1"), Source(text: "source2")],
              user:
                  User(id: "1", fullname: "Martha Poms", photoUrl: "some-url"),
              explorations: []),
          Exploration(
              body: "Another exploration",
              sources: [Source(text: "source1"), Source(text: "source2")],
              user: User(
                id: "2",
                fullname: "Thomas Grews",
                photoUrl: "some-url",
              ),
              explorations: []),
        ],
      ),
      Exploration(
        body:
            "I'm interested in exploring the events that happened in Europe when Hitler was thinking about invade other countries. I read his biography and it’s fascinated how he changed his mind and posture many times.",
        sources: [
          Source(text: "http://source-one.com"),
          Source(text: "http://source-two.com"),
          Source(text: "http://source-three.com")
        ],
        user: User(id: "3", fullname: "Omar Torres", photoUrl: "photoUrl"),
        explorations: [
          Exploration(
              body: "Another exploration",
              sources: [Source(text: "source1"), Source(text: "source2")],
              user: User(
                id: "3",
                fullname: "August Vall",
                photoUrl: "some-url",
              ),
              explorations: []),
        ],
      )
    ];
  }
}
