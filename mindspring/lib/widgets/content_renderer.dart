import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';

class ContentWrapper extends StatelessWidget {
  final List<Map<String, dynamic>> contentList;

  const ContentWrapper({super.key, required this.contentList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contentList.length,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ContentRenderer(contentData: contentList[index]),
        );
      },
    );
  }
}

class ContentRenderer extends StatelessWidget {
  final Map<String, dynamic> contentData;

  const ContentRenderer({super.key, required this.contentData});

  @override
  Widget build(BuildContext context) {
    switch (contentData['contentType']) {
      case 'fill':
        return FillInTheBlankWidget(contentData: contentData);
      case 'image_match':
        return ImageMatchWidget(contentData: contentData);
      case 'audio':
        return AudioContentWidget(contentData: contentData);
      case 'sentence':
        return SentenceReorderWidget(contentData: contentData);
      case 'mcq':
        return McqWidget(contentData: contentData);
      default:
        return const Center(child: Text("Unknown content type"));
    }
  }
}

class FillInTheBlankWidget extends StatefulWidget {
  final Map<String, dynamic> contentData;

  const FillInTheBlankWidget({super.key, required this.contentData});

  @override
  _FillInTheBlankWidgetState createState() => _FillInTheBlankWidgetState();
}

class _FillInTheBlankWidgetState extends State<FillInTheBlankWidget> {
  final TextEditingController _controller = TextEditingController();
  String _feedback = '';

  void _checkAnswer() {
    String userAnswer = _controller.text.trim().toLowerCase();
    String correctAnswer = widget.contentData['answer'].toLowerCase();
    setState(() {
      _feedback = userAnswer == correctAnswer ? 'Correct!' : 'Try again!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.contentData['question'],
              style: Theme.of(context).textTheme.titleLarge ??
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Enter your answer",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _checkAnswer,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Submit'),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _feedback,
              style: TextStyle(
                fontSize: 16,
                color: _feedback == 'Correct!' ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageMatchWidget extends StatefulWidget {
  final Map<String, dynamic> contentData;

  const ImageMatchWidget({super.key, required this.contentData});

  @override
  _ImageMatchWidgetState createState() => _ImageMatchWidgetState();
}

class _ImageMatchWidgetState extends State<ImageMatchWidget> {
  final Map<String, String> _selectedMatches = {};
  String _feedback = '';

  void _checkMatches() {
    bool isCorrect = true;
    widget.contentData['correctMatches'].forEach((key, value) {
      if (_selectedMatches[key] != value) {
        isCorrect = false;
      }
    });

    setState(() {
      _feedback = isCorrect ? 'Correct!' : 'Try again!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.contentData['question'],
              style: Theme.of(context).textTheme.titleLarge ??
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List<Widget>.from(
                widget.contentData['items'].map<Widget>((item) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMatches[item['label']] =
                            _selectedMatches[item['label']] == item['imageUrl']
                                ? ''
                                : item['imageUrl'];
                      });
                    },
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item['imageUrl'],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['label'],
                          style: const TextStyle(fontSize: 16),
                        ),
                        if (_selectedMatches[item['label']] != null)
                          Text(
                            "Selected",
                            style: TextStyle(color: Colors.green, fontSize: 14),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkMatches,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Submit'),
            ),
            const SizedBox(height: 12),
            Text(
              _feedback,
              style: TextStyle(
                fontSize: 16,
                color: _feedback == 'Correct!' ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class AudioContentWidget extends StatefulWidget {
  final Map<String, dynamic> contentData;

  const AudioContentWidget({super.key, required this.contentData});

  @override
  _AudioContentWidgetState createState() => _AudioContentWidgetState();
}

class _AudioContentWidgetState extends State<AudioContentWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String _selectedAnswer = '';
  String _feedback = '';

  void _togglePlay() async {
    String? source = widget.contentData['audioUrl'];
    if (source != null && source.isNotEmpty) {
      try {
        if (_isPlaying) {
          await _audioPlayer.pause();
        } else {
          if (source.startsWith('http')) {
            await _audioPlayer.play(UrlSource(source));
          } else {
            await _audioPlayer.play(AssetSource(source));
          }
        }
        setState(() => _isPlaying = !_isPlaying);
      } catch (e) {
        debugPrint("Audio playback error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unable to play audio")),
        );
      }
    } else {
      debugPrint("Invalid or missing audio URL: $source");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Audio URL is missing or invalid")),
      );
    }
  }

  void _checkAnswer() {
    setState(() {
      _feedback = _selectedAnswer.toLowerCase() == widget.contentData['answer'].toLowerCase()
          ? 'Correct!'
          : 'Try again!';
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.contentData['question'],
              style: Theme.of(context).textTheme.titleLarge ??
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                    size: 36,
                    color: Colors.blueAccent,
                  ),
                  onPressed: _togglePlay,
                ),
                Text(
                  _isPlaying ? 'Pause' : 'Play',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: (value) {
                setState(() {
                  _selectedAnswer = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Enter your answer (e.g., "Lion")',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _checkAnswer,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Submit'),
            ),
            const SizedBox(height: 12),
            Text(
              _feedback,
              style: TextStyle(
                fontSize: 16,
                color: _feedback == 'Correct!' ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SentenceReorderWidget extends StatefulWidget {
  final Map<String, dynamic> contentData;

  const SentenceReorderWidget({super.key, required this.contentData});

  @override
  _SentenceReorderWidgetState createState() => _SentenceReorderWidgetState();
}

class _SentenceReorderWidgetState extends State<SentenceReorderWidget> {
  late List<String> words;
  String _feedback = '';

  @override
  void initState() {
    super.initState();
    words = List<String>.from(widget.contentData['sentence'])..shuffle();
  }

  void _checkOrder() {
    final List<String> correctOrder = List<String>.from(widget.contentData['correctOrder']);
    setState(() {
      _feedback = const DeepCollectionEquality().equals(words, correctOrder)
          ? 'Correct!'
          : 'Wrong order!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reorder the sentence:",
              style: Theme.of(context).textTheme.titleLarge ??
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List<Widget>.generate(words.length, (index) {
                return InputChip(
                  label: Text(words[index], style: const TextStyle(fontSize: 16)),
                  backgroundColor: Colors.grey[200],
                  onDeleted: () {
                    setState(() {
                      final String word = words.removeAt(index);
                      words.add(word);
                    });
                  },
                  deleteIcon: const Icon(Icons.swap_horiz),
                );
              }),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _checkOrder,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Check', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _feedback,
              style: TextStyle(
                fontSize: 16,
                color: _feedback == 'Correct!' ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class McqWidget extends StatefulWidget {
  final Map<String, dynamic> contentData;

  const McqWidget({super.key, required this.contentData});

  @override
  _McqWidgetState createState() => _McqWidgetState();
}

class _McqWidgetState extends State<McqWidget> {
  String? selectedOption;
  String _feedback = '';

  void _checkAnswer() {
    final correct = widget.contentData['answer'];
    setState(() {
      _feedback = selectedOption == correct ? 'Correct!' : 'Try again!';
    });
  }

  @override
  Widget build(BuildContext context) {
    final options = List<String>.from(widget.contentData['options']);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.contentData['question'],
              style: Theme.of(context).textTheme.titleLarge ??
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...options.map((option) {
              return RadioListTile<String>(
                value: option,
                groupValue: selectedOption,
                title: Text(option),
                onChanged: (value) {
                  setState(() => selectedOption = value);
                },
              );
            }).toList(),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _checkAnswer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Submit', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _feedback,
              style: TextStyle(
                fontSize: 16,
                color: _feedback == 'Correct!' ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
