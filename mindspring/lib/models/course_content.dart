class CourseContent {
  final String contentType;
  final String question;
  final String answer;
  final List<String>? options;
  final String? audioUrl;
  final List<Map<String, String>>? items;
  final List<String>? sentence;
  final Map<String, String>? correctMatches;
  final List<String>? correctOrder;

  CourseContent({
    required this.contentType,
    required this.question,
    required this.answer,
    this.options,
    this.audioUrl,
    this.items,
    this.sentence,
    this.correctMatches,
    this.correctOrder,
  });

  factory CourseContent.fromJson(Map<String, dynamic> json) {
    return CourseContent(
      contentType: json['contentType'] != null ? json['contentType'] : '', // Default empty string for missing contentType
      question: json['question'] != null ? json['question'] : '', // Default empty string for missing question
      answer: json['answer'] != null ? json['answer'] : '', // Default empty string for missing answer
      options: json['options'] != null ? List<String>.from(json['options']) : null,
      audioUrl: json['audioUrl'], // Allow null if audioUrl is missing
      items: json['items'] != null
          ? List<Map<String, String>>.from(json['items'].map((item) => Map<String, String>.from(item)))
          : null,
      sentence: json['sentence'] != null ? List<String>.from(json['sentence']) : null,
      correctMatches: json['correctMatches'] != null
          ? Map<String, String>.from(json['correctMatches'])
          : null,
      correctOrder: json['correctOrder'] != null ? List<String>.from(json['correctOrder']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contentType': contentType,
      'question': question,
      'answer': answer,
      'options': options,
      'audioUrl': audioUrl,
      'items': items,
      'sentence': sentence,
      'correctMatches': correctMatches,
      'correctOrder': correctOrder,
    };
  }
}
