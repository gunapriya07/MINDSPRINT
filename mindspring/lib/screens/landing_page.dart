import 'package:flutter/material.dart';
import 'course_screen.dart';
// import '../models/course_content.dart';
import '../services/api_service.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to MindBloom')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final api = ApiService();
            final contents = await api.fetchCourseContent();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CourseScreen(contents: contents),
              ),
            );
          },
          child: const Text('Start Quiz'),
        ),
      ),
    );
  }
}
