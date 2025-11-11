import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text_app/services/database_helper.dart';
import 'package:speech_to_text_app/main.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    final speechProvider = Provider.of<SpeechProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to Text'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                speechProvider.recognizedText.isEmpty ? 'Press the button and start speaking' : 'Recognized text:',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                speechProvider.recognizedText,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    if (speechProvider.recognizedText.isNotEmpty) {
                      await DatabaseHelper.instance.insertTranscription(speechProvider.recognizedText);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Transcription saved!'),
                        ),
                      );
                      speechProvider.updateRecognizedText('');
                    }
                  },
                  child: const Text('Save Transcription')
              ),
            ],
          ),
        ),
      ),
      floatingActionButton:
      FloatingActionButton(
        onPressed: _listen,
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
      ),
    );
  }

  void _listen() async {
    final speechProvider = Provider.of<SpeechProvider>(context, listen: false);
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            speechProvider.updateRecognizedText(val.recognizedWords);
            if (val.hasConfidenceRating && val.confidence > 0) {
              print('Confidence: ${val.confidence}');
            }
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
