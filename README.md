# MINDBLOOM Flutter Learning App

MINDBLOOM is a Flutter-based educational app designed to deliver interactive and engaging learning experiences for students. It dynamically renders content such as fill-in-the-blank, image matching, audio identification, sentence reordering, and multiple-choice questions based on JSON API responses.

---

## 🚀 Features

- 🎯 **Dynamic Content Rendering**: Displays different UI components based on `contentType`.
- ✏️ **Fill in the Blank**: Input-based questions for language learning.
- 🖼️ **Image Match**: Interactive image selection for matching activities.
- 🔊 **Audio Recognition**: Users listen and identify correct answers from audio clips.
- 📚 **Sentence Reorder**: Drag-and-drop UI for arranging words into correct sentences.
- ✅ **Multiple Choice (MCQ)**: Choose from a set of options to answer questions.

---

## 🧩 Content Types Supported

Each content item from the backend includes a `contentType` field. The app currently supports:

| Content Type     | Widget             | Description                                  |
|------------------|--------------------|----------------------------------------------|
| `fill`           | `FillInBlankWidget`| User fills in a blank word.                  |
| `image_match`    | `ImageMatchWidget` | Match words to images.                       |
| `audio`          | `AudioContentWidget`| Play audio and answer related questions.    |
| `sentence`       | `SentenceReorderWidget` | Reorder jumbled words into a sentence. |
| `mcq`            | `MCQWidget`        | Multiple-choice question format.             |

---

## 📦 Folder Structure

lib/
├── widgets/
│ ├── content_wrapper.dart
│ ├── fill_in_blank_widget.dart
│ ├── image_match_widget.dart
│ ├── audio_content_widget.dart
│ ├── sentence_reorder_widget.dart
│ └── mcq_widget.dart
├── models/
│ └── content_model.dart
├── screens/
│ └── home_screen.dart
├── services/
│ └── content_service.dart
└── main.dart


---

## 🔧 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code

### Installation

```bash
git clone repo link
cd mindbloom-flutter-app
flutter pub get
flutter run

🔌 API Integration
This app uses a dummy JSON API response structure. Example format:


{
  "contentType": "fill",
  "question": "The capital of France is ___",
  "answer": "Paris"
}
