import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text_app/screens/speech_screen.dart';
import 'package:speech_to_text_app/services/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SpeechProvider(),
      child: MaterialApp(
        title: 'Speech-to-Text Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SpeechScreen(),
      ),
    );
  }
}

class SpeechProvider extends ChangeNotifier {
  String _recognizedText = '';

  String get recognizedText => _recognizedText;

  void updateRecognizedText(String text) {
    _recognizedText = text;
    notifyListeners();
  }
}