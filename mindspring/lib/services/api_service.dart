import '../models/course_content.dart';

class ApiService {
  Future<List<CourseContent>> fetchCourseContent() async {
    await Future.delayed(const Duration(seconds: 1));

    final dummyJson = [
      {
        "contentType": "fill",
        "question": "The sun rises in the _____",
        "answer": "east"
      },
      {
        "contentType": "fill",
        "question": "Water freezes at _____ degrees Celsius.",
        "answer": "0"
      },
      {
        "contentType": "fill",
        "question": "The capital of France is _____",
        "answer": "paris"
      },
      {
        "contentType": "mcq",
        "question": "Which planet is known as the Red Planet?",
        "options": ["Earth", "Mars", "Venus", "Jupiter"],
        "answer": "Mars"
      },
      {
        "contentType": "mcq",
        "question": "Who wrote 'Hamlet'?",
        "options": ["Shakespeare", "Charles Dickens", "Jane Austen", "Leo Tolstoy"],
        "answer": "Shakespeare"
      },
      {
        "contentType": "image_match",
        "question": "Match the fruit with its image.",
        "items": [
          {
            "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/1/15/Red_Apple.jpg",
            "label": "Apple"
          },
          {
            "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/8/8a/Banana-Single.jpg",
            "label": "Banana"
          }
        ],
        "correctMatches": {
          "Apple": "https://upload.wikimedia.org/wikipedia/commons/1/15/Red_Apple.jpg",
          "Banana": "https://upload.wikimedia.org/wikipedia/commons/8/8a/Banana-Single.jpg"
        }
      },
      {
        "contentType": "audio",
        "audioUrl": "audio/lion-roaring-sfx-293295.mp3",
        "question": "Which animal makes this sound?",
        "answer": "lion"
      },
      {
        "contentType": "audio",
        "audioUrl": "audio/background-music-soft-piano-334995.mp3",
        "question": "Guess the musical instrument.",
        "answer": "piano"
      },
      {
        "contentType": "sentence",
        "sentence": ["Flutter", "is", "awesome"],
        "correctOrder": ["Flutter", "is", "awesome"]
      },
      {
        "contentType": "sentence",
        "sentence": ["I", "love", "programming"],
        "correctOrder": ["I", "love", "programming"]
      }
    ];

    return dummyJson.map((item) => CourseContent.fromJson(item)).toList();
  }
}
